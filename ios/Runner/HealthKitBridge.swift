import Flutter
import HealthKit
import UIKit

/// Read-only, foreground HealthKit access. Anchors are returned to the encrypted
/// Dart vault together with their page; this bridge never persists health data.
final class NativeHealthKitBridge {
  private let store = HKHealthStore()
  private var activeQuery: HKAnchoredObjectQuery?
  private var pendingResult: FlutterResult?
  private var operation: UUID?
  private let maximumAnchorBytes = 65_536

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if !Thread.isMainThread {
      DispatchQueue.main.async { self.handle(call, result: result) }
      return
    }
    switch call.method {
    case "healthKitAvailable":
      result(HKHealthStore.isHealthDataAvailable())
    case "healthKitCancel":
      cancel()
      result(true)
    case "healthKitAuthorize":
      authorize(call.arguments, result: result)
    case "healthKitReadPage":
      readPage(call.arguments, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private var canRead: Bool {
    HKHealthStore.isHealthDataAvailable()
      && UIApplication.shared.isProtectedDataAvailable
      && UIApplication.shared.applicationState == .active
  }

  private func failure(_ code: String = "healthkit_unavailable") -> FlutterError {
    // NSError descriptions can contain private sample information.
    FlutterError(code: code, message: "Private Health refresh unavailable.", details: nil)
  }

  private func begin(_ result: @escaping FlutterResult) -> UUID? {
    guard pendingResult == nil else { result(failure("healthkit_busy")); return nil }
    guard canRead else { result(failure()); return nil }
    let token = UUID()
    operation = token
    pendingResult = result
    return token
  }

  private func finish(_ token: UUID, _ value: Any?) {
    guard operation == token else { return }
    let callback = pendingResult
    pendingResult = nil
    activeQuery = nil
    operation = nil
    callback?(value)
  }

  private func cancel() {
    if let query = activeQuery { store.stop(query) }
    if let token = operation { finish(token, failure("healthkit_cancelled")) }
  }

  private func authorize(_ arguments: Any?, result: @escaping FlutterResult) {
    guard let args = arguments as? [String: Any],
          let metrics = args["metrics"] as? [String],
          !metrics.isEmpty, metrics.count <= 10,
          Set(metrics).count == metrics.count else {
      result(failure("healthkit_arguments")); return
    }
    var types = Set<HKObjectType>()
    for metric in metrics {
      guard let type = sampleType(metric) else {
        result(failure("healthkit_arguments")); return
      }
      types.insert(type)
    }
    guard let token = begin(result) else { return }
    // A successful request means the sheet completed, NOT read access granted.
    // HealthKit deliberately does not disclose whether reads were denied.
    store.requestAuthorization(toShare: Set<HKSampleType>(), read: types) { [weak self] completed, error in
      DispatchQueue.main.async {
        guard let self = self, self.operation == token else { return }
        if error != nil || !UIApplication.shared.isProtectedDataAvailable {
          self.finish(token, self.failure())
        } else {
          self.finish(token, completed)
        }
      }
    }
  }

  private func readPage(_ arguments: Any?, result: @escaping FlutterResult) {
    guard let args = arguments as? [String: Any],
          let metric = args["metric"] as? String,
          let type = sampleType(metric),
          let requestedLimit = args["limit"] as? NSNumber,
          CFGetTypeID(requestedLimit) != CFBooleanGetTypeID(),
          requestedLimit.doubleValue.isFinite,
          requestedLimit.doubleValue.rounded() == requestedLimit.doubleValue,
          requestedLimit.doubleValue >= 1, requestedLimit.doubleValue <= 500 else {
      result(failure("healthkit_arguments")); return
    }
    let limit = requestedLimit.intValue
    let anchor: HKQueryAnchor?
    do {
      if let encoded = args["anchor"], !(encoded is NSNull) {
        guard let text = encoded as? String,
              !text.isEmpty, text.utf8.count <= maximumAnchorBytes,
              let data = Data(base64Encoded: text), data.count <= maximumAnchorBytes,
              let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data) else {
          result(failure("healthkit_arguments")); return
        }
        anchor = decoded
      } else {
        anchor = nil
      }
    } catch {
      result(failure("healthkit_arguments")); return
    }
    guard let token = begin(result) else { return }
    let query = HKAnchoredObjectQuery(type: type, predicate: nil, anchor: anchor, limit: limit) {
      [weak self] _, samples, deleted, nextAnchor, error in
      DispatchQueue.main.async {
        guard let self = self, self.operation == token else { return }
        guard error == nil, self.canRead,
              let nextAnchor = nextAnchor else {
          self.finish(token, self.failure()); return
        }
        let samples = samples ?? []
        let deleted = deleted ?? []
        // A bounded query may return up to limit samples AND limit deletions.
        // Do not return an anchor from an unexpectedly oversized response.
        guard samples.count <= limit, deleted.count <= limit,
              samples.count + deleted.count <= 1_000 else {
          self.finish(token, self.failure()); return
        }
        do {
          let data = try NSKeyedArchiver.archivedData(withRootObject: nextAnchor, requiringSecureCoding: true)
          let encoded = data.base64EncodedString()
          guard data.count <= self.maximumAnchorBytes,
                encoded.utf8.count <= self.maximumAnchorBytes else {
            self.finish(token, self.failure()); return
          }
          let rows = samples.compactMap { self.observation($0, metric: metric) }
          guard rows.count == samples.count else {
            self.finish(token, self.failure()); return
          }
          self.finish(token, [
            "samples": rows,
            "deletedIds": deleted.map { "hk:\(metric):\($0.uuid.uuidString.lowercased())" },
            "anchor": encoded,
            "more": samples.count + deleted.count >= limit,
          ])
        } catch {
          self.finish(token, self.failure())
        }
      }
    }
    activeQuery = query
    store.execute(query)
  }

  private func sampleType(_ metric: String) -> HKSampleType? {
    if metric == "sleep" { return HKObjectType.categoryType(forIdentifier: .sleepAnalysis) }
    let identifier: HKQuantityTypeIdentifier
    switch metric {
    case "weight": identifier = .bodyMass
    case "steps": identifier = .stepCount
    case "distance": identifier = .distanceWalkingRunning
    case "activeEnergy": identifier = .activeEnergyBurned
    case "basalEnergy": identifier = .basalEnergyBurned
    case "exerciseMinutes": identifier = .appleExerciseTime
    case "restingHeartRate": identifier = .restingHeartRate
    case "hrvSdnn": identifier = .heartRateVariabilitySDNN
    case "vo2Max": identifier = .vo2Max
    default: return nil
    }
    return HKObjectType.quantityType(forIdentifier: identifier)
  }

  private func unit(_ metric: String) -> (HKUnit, String)? {
    switch metric {
    case "weight": return (HKUnit.gramUnit(with: .kilo), "kg")
    case "steps": return (HKUnit.count(), "count")
    case "distance": return (HKUnit.meterUnit(with: .kilo), "km")
    case "activeEnergy", "basalEnergy": return (HKUnit.kilocalorie(), "kcal")
    case "exerciseMinutes": return (HKUnit.minute(), "min")
    case "restingHeartRate": return (HKUnit.count().unitDivided(by: HKUnit.minute()), "count/min")
    case "hrvSdnn": return (HKUnit.secondUnit(with: .milli), "ms")
    case "vo2Max":
      return (HKUnit.literUnit(with: .milli).unitDivided(by:
        HKUnit.gramUnit(with: .kilo).unitMultiplied(by: HKUnit.minute())), "mL/min·kg")
    default: return nil
    }
  }

  private func observation(_ sample: HKSample, metric: String) -> [String: Any]? {
    guard sample.sampleType == sampleType(metric) else { return nil }
    let start = sample.startDate.timeIntervalSince1970
    let end = sample.endDate.timeIntervalSince1970
    // Years 0001 through 9999 keep millisecond conversion safe and dates portable.
    guard start.isFinite, end.isFinite, end >= start,
          start >= -62_135_596_800, end <= 253_402_300_799 else { return nil }
    let source = sample.sourceRevision.source.name
    guard !source.isEmpty, source.utf8.count <= 512 else { return nil }
    let zone: TimeZone
    if let name = sample.metadata?[HKMetadataKeyTimeZone] as? String {
      guard name.utf8.count <= 128, let parsed = TimeZone(identifier: name) else { return nil }
      zone = parsed
    } else {
      zone = TimeZone.current
    }
    let offset = zone.secondsFromGMT(for: sample.startDate) / 60
    guard abs(offset) <= 14 * 60 else { return nil }
    let value: Any
    let category: Any
    let raw: String
    let unitName: String
    if metric == "sleep" {
      guard let sleep = sample as? HKCategorySample else { return nil }
      // Raw values avoid requiring iOS 16 symbols for stage-specific categories.
      let categories = [0: "inBed", 1: "asleep", 2: "awake", 3: "core", 4: "deep", 5: "rem"]
      guard let name = categories[sleep.value] else { return nil }
      value = NSNull()
      category = name
      raw = String(sleep.value)
      unitName = "min"
    } else {
      guard let quantity = sample as? HKQuantitySample,
            let (canonical, name) = unit(metric),
            quantity.quantity.is(compatibleWith: canonical) else { return nil }
      let number = quantity.quantity.doubleValue(for: canonical)
      guard number.isFinite, number >= 0 else { return nil }
      value = number
      category = NSNull()
      raw = String(number)
      unitName = name
    }
    let id = "hk:\(metric):\(sample.uuid.uuidString.lowercased())"
    return [
      "id": id, "logical_id": id, "metric": metric,
      "source": "HealthKit · " + source, "raw_value": raw,
      "original_unit": unitName, "canonical_unit": unitName,
      "value": value, "category": category,
      "start_ms": Int64((start * 1_000).rounded(.down)),
      "end_ms": Int64((end * 1_000).rounded(.down)),
      "offset_minutes": offset, "time_zone": zone.identifier,
      "sync_version": 0,
    ]
  }
}
