class ReminderModel {
  final String id;
  final String medicineName;
  final String dosage;
  final String timeString; // e.g. "08:00 AM"
  final bool isMorning;
  final bool isAfternoon;
  final bool isNight;
  final bool beforeFood;
  final DateTime startDate;
  final DateTime endDate;
  bool isTakenToday;
  DateTime? lastTakenAt;
  final String instructions;

  ReminderModel({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.timeString,
    this.isMorning = true,
    this.isAfternoon = false,
    this.isNight = false,
    this.beforeFood = false,
    required this.startDate,
    required this.endDate,
    this.isTakenToday = false,
    this.lastTakenAt,
    this.instructions = 'Take with a glass of water',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'timeString': timeString,
      'isMorning': isMorning,
      'isAfternoon': isAfternoon,
      'isNight': isNight,
      'beforeFood': beforeFood,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isTakenToday': isTakenToday,
      'lastTakenAt': lastTakenAt?.toIso8601String(),
      'instructions': instructions,
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] ?? '',
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      timeString: json['timeString'] ?? '08:00 AM',
      isMorning: json['isMorning'] ?? true,
      isAfternoon: json['isAfternoon'] ?? false,
      isNight: json['isNight'] ?? false,
      beforeFood: json['beforeFood'] ?? false,
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      isTakenToday: json['isTakenToday'] ?? false,
      lastTakenAt: json['lastTakenAt'] != null
          ? DateTime.tryParse(json['lastTakenAt'])
          : null,
      instructions: json['instructions'] ?? 'Take with a glass of water',
    );
  }
}
