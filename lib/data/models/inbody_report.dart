class InbodyReport {
  final String id;
  final DateTime reportDate;
  final double weight;
  final double bodyFatPercent;
  final double muscleMass;
  final double visceralFat;

  InbodyReport({
    required this.id,
    required this.reportDate,
    required this.weight,
    required this.bodyFatPercent,
    required this.muscleMass,
    required this.visceralFat,
  });

  Map<String, dynamic> toMap() => {
    "reportDate": reportDate.toIso8601String(),
    "weight": weight,
    "bodyFatPercent": bodyFatPercent,
    "muscleMass": muscleMass,
    "visceralFat": visceralFat,
  };

  factory InbodyReport.fromMap(String id, Map<String, dynamic> map) => InbodyReport(
    id: id,
    reportDate: DateTime.parse(map["reportDate"]),
    weight: map["weight"],
    bodyFatPercent: map["bodyFatPercent"],
    muscleMass: map["muscleMass"],
    visceralFat: map["visceralFat"],
  );
}
