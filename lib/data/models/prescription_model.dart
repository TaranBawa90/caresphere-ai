class MedicineItem {
  final String name;
  final String dosage;
  final String frequency; // e.g., "1-0-1 (Twice daily after meals)"
  final String duration; // e.g., "5 days"
  final String instructionsEn;
  final String instructionsHi;
  final String instructionsPa;
  final bool isCertain; // false if handwritten text was blurry/uncertain
  final String plainLanguagePurpose; // What this medicine does in simple terms
  final String warnings; // e.g. "Do not take on empty stomach"

  MedicineItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructionsEn,
    required this.instructionsHi,
    required this.instructionsPa,
    required this.isCertain,
    required this.plainLanguagePurpose,
    this.warnings = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructionsEn': instructionsEn,
      'instructionsHi': instructionsHi,
      'instructionsPa': instructionsPa,
      'isCertain': isCertain,
      'plainLanguagePurpose': plainLanguagePurpose,
      'warnings': warnings,
    };
  }

  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructionsEn: json['instructionsEn'] ?? '',
      instructionsHi: json['instructionsHi'] ?? '',
      instructionsPa: json['instructionsPa'] ?? '',
      isCertain: json['isCertain'] ?? true,
      plainLanguagePurpose: json['plainLanguagePurpose'] ?? '',
      warnings: json['warnings'] ?? '',
    );
  }
}

class PrescriptionModel {
  final String id;
  final String patientId;
  final String doctorName;
  final String hospitalClinicName;
  final DateTime date;
  final String? imageUrl;
  final String extractedRawOcr;
  final List<MedicineItem> medicines;
  final String generalAdvice;
  final String followUpDate;

  PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.hospitalClinicName,
    required this.date,
    this.imageUrl,
    required this.extractedRawOcr,
    required this.medicines,
    required this.generalAdvice,
    this.followUpDate = 'After 7 days',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorName': doctorName,
      'hospitalClinicName': hospitalClinicName,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'extractedRawOcr': extractedRawOcr,
      'medicines': medicines.map((m) => m.toJson()).toList(),
      'generalAdvice': generalAdvice,
      'followUpDate': followUpDate,
    };
  }

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      hospitalClinicName: json['hospitalClinicName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      imageUrl: json['imageUrl'],
      extractedRawOcr: json['extractedRawOcr'] ?? '',
      medicines: (json['medicines'] as List<dynamic>?)
              ?.map((m) => MedicineItem.fromJson(m))
              .toList() ??
          [],
      generalAdvice: json['generalAdvice'] ?? '',
      followUpDate: json['followUpDate'] ?? 'After 7 days',
    );
  }
}
