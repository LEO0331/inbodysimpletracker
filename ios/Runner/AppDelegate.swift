import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UIDocumentPickerDelegate {
  private var pendingHealthExport: FlutterResult?
  private var healthVisible = false
  private var healthPrivacyCovers: [UIView] = []
  private var healthPrivacyObservers: [NSObjectProtocol] = []
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    healthPrivacyObservers.append(NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
      guard let self = self, self.healthVisible else { return }
      for scene in UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }) {
        for window in scene.windows where !window.isHidden {
          let cover = UIView(frame: window.bounds)
          cover.backgroundColor = .systemBackground
          cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          window.addSubview(cover)
          self.healthPrivacyCovers.append(cover)
        }
      }
    })
    healthPrivacyObservers.append(NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
      self?.removeHealthPrivacyCovers()
    })
    let channel = FlutterMethodChannel(
      name: "inbodysimpletracker/private_health",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "setSensitiveView", let self = self,
         let args = call.arguments as? [String: Any], let visible = args["visible"] as? Bool {
        self.healthVisible = visible
        if !visible { self.removeHealthPrivacyCovers() }
        result(true)
        return
      }
      guard let self = self,
            let args = call.arguments as? [String: Any],
            let path = args["path"] as? String else {
        result(FlutterError(code: "private_health", message: "Private operation unavailable.", details: nil))
        return
      }
      switch call.method {
      case "protectImportFile":
        do {
          let requested = URL(fileURLWithPath: path).standardizedFileURL
          let resolved = requested.resolvingSymlinksInPath()
          let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].resolvingSymlinksInPath()
          let temporary = FileManager.default.temporaryDirectory.resolvingSymlinksInPath()
          guard resolved.path.hasPrefix(cache.path + "/") || resolved.path.hasPrefix(temporary.path + "/"),
                ["xml", "zip"].contains(resolved.pathExtension.lowercased()) else {
            throw CocoaError(.fileReadNoPermission)
          }
          let shape = try requested.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
          guard shape.isRegularFile == true, shape.isSymbolicLink != true else {
            throw CocoaError(.fileReadNoPermission)
          }
          try self.protectHealthURL(resolved)
          result(true)
        } catch {
          result(FlutterError(code: "private_health", message: "Protected import unavailable.", details: nil))
        }
      case "protectDirectory":
        do {
          let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
          let expected = support.appendingPathComponent("private_health_data").resolvingSymlinksInPath().standardizedFileURL
          let requested = URL(fileURLWithPath: path).resolvingSymlinksInPath().standardizedFileURL
          guard requested.path == expected.path else { throw CocoaError(.fileReadNoPermission) }
          try self.protectHealthURL(requested)
          if let files = FileManager.default.enumerator(at: requested, includingPropertiesForKeys: [.isSymbolicLinkKey]) {
            for case let file as URL in files {
              if try file.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink == true {
                throw CocoaError(.fileReadNoPermission)
              }
              try self.protectHealthURL(file)
            }
          }
          result(true)
        } catch {
          result(FlutterError(code: "private_health", message: "Protected storage unavailable.", details: nil))
        }
      case "exportBackup": self.exportHealthBackup(path: path, result: result)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  private func protectHealthURL(_ original: URL) throws {
    var url = original
    var values = URLResourceValues()
    values.isExcludedFromBackup = true
    try url.setResourceValues(values)
    try FileManager.default.setAttributes([.protectionKey: FileProtectionType.complete], ofItemAtPath: url.path)
    let stored = try url.resourceValues(forKeys: [.isExcludedFromBackupKey])
    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
    guard stored.isExcludedFromBackup == true,
          attributes[.protectionKey] as? String == FileProtectionType.complete.rawValue else {
      throw CocoaError(.fileWriteNoPermission)
    }
  }

  private func removeHealthPrivacyCovers() {
    for cover in healthPrivacyCovers { cover.removeFromSuperview() }
    healthPrivacyCovers.removeAll()
  }

  private func exportHealthBackup(path: String, result: @escaping FlutterResult) {
    let file = URL(fileURLWithPath: path).resolvingSymlinksInPath().standardizedFileURL
    let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let allowed = cache.appendingPathComponent("health_backups").resolvingSymlinksInPath().standardizedFileURL
    guard pendingHealthExport == nil, file.deletingLastPathComponent().path == allowed.path,
          file.lastPathComponent.range(of: "^[a-f0-9]{32}\\.healthbackup$", options: .regularExpression) != nil,
          FileManager.default.fileExists(atPath: file.path) else {
      result(FlutterError(code: "private_health", message: "Encrypted backup unavailable.", details: nil)); return
    }
    let root = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }.first { $0.isKeyWindow }?.rootViewController
    guard var presenter = root else {
      result(FlutterError(code: "private_health", message: "Files export unavailable.", details: nil)); return
    }
    while let presented = presenter.presentedViewController { presenter = presented }
    let picker: UIDocumentPickerViewController
    if #available(iOS 14.0, *) {
      picker = UIDocumentPickerViewController(forExporting: [file], asCopy: true)
    } else {
      picker = UIDocumentPickerViewController(url: file, in: .exportToService)
    }
    pendingHealthExport = result
    picker.delegate = self
    presenter.present(picker, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    pendingHealthExport?(!urls.isEmpty)
    pendingHealthExport = nil
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pendingHealthExport?(false)
    pendingHealthExport = nil
  }
}
