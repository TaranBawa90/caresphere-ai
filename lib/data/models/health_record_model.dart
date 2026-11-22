enum RecordType { vitals, prescription, labReport, allergy, immunization }

class HealthRecordModel {
  final String id;
  final String patientId;
  final String title;
  final RecordType recordType;
  final DateTime date;
  final String? doctorOrLabName;
  final String? notes;

  // Vitals measurements
  final int? systolicBP;
  final int? diastolicBP;
  final int? bloodSugarFasting;
  final int? bloodSugarPostPrandial;
  final int? heartRate;
  final int? spO2;
  final double? weightKg;
  final double? temperatureF;

  // Document attachments
  final String? documentUrl;
  final String? documentName;

  HealthRecordModel({
    required this.id,
    required this.patientId,
    required this.title,
    required this.recordType,
    required this.date,
    this.doctorOrLabName,
    this.notes,
    this.systolicBP,
    this.diastolicBP,
    this.bloodSugarFasting,
    this.bloodSugarPostPrandial,
    this.heartRate,
    this.spO2,
    this.weightKg,
    this.temperatureF,
    this.documentUrl,
    this.documentName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'title': title,
      'recordType': recordType.name,
      'date': date.toIso8601String(),
      'doctorOrLabName': doctorOrLabName,
      'notes': notes,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'bloodSugarFasting': bloodSugarFasting,
      'bloodSugarPostPrandial': bloodSugarPostPrandial,
      'heartRate': heartRate,
      'spO2': spO2,
      'weightKg': weightKg,
      'temperatureF': temperatureF,
      'documentUrl': documentUrl,
      'documentName': documentName,
    };
  }

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      title: json['title'] ?? '',
      recordType: RecordType.values.firstWhere(
        (e) => e.name == json['recordType'],
        orElse: () => RecordType.vitals,
      ),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      doctorOrLabName: json['doctorOrLabName'],
      notes: json['notes'],
      systolicBP: json['systolicBP'],
      diastolicBP: json['diastolicBP'],
      bloodSugarFasting: json['bloodSugarFasting'],
      bloodSugarPostPrandial: json['bloodSugarPostPrandial'],
      heartRate: json['heartRate'],
      spO2: json['spO2'],
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      temperatureF: (json['temperatureF'] as num?)?.toDouble(),
      documentUrl: json['documentUrl'],
      documentName: json['documentName'],
    );
  }
}
