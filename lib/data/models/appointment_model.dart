enum AppointmentStatus { pending, confirmed, inProgress, completed, cancelled }

class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String hospitalName;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final String tokenNumber;
  final bool isOnlineVideo;
  final String jitsiRoomId;
  final String symptoms;
  final String? doctorNotes;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.hospitalName,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.tokenNumber,
    required this.isOnlineVideo,
    required this.jitsiRoomId,
    required this.symptoms,
    this.doctorNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialty': specialty,
      'hospitalName': hospitalName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status.name,
      'tokenNumber': tokenNumber,
      'isOnlineVideo': isOnlineVideo,
      'jitsiRoomId': jitsiRoomId,
      'symptoms': symptoms,
      'doctorNotes': doctorNotes,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      specialty: json['specialty'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      timeSlot: json['timeSlot'] ?? '10:00 AM',
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.confirmed,
      ),
      tokenNumber: json['tokenNumber'] ?? 'CS-101',
      isOnlineVideo: json['isOnlineVideo'] ?? true,
      jitsiRoomId: json['jitsiRoomId'] ?? 'CareSphere-Room',
      symptoms: json['symptoms'] ?? '',
      doctorNotes: json['doctorNotes'],
    );
  }

  AppointmentModel copyWith({
    AppointmentStatus? status,
    String? doctorNotes,
  }) {
    return AppointmentModel(
      id: id,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      hospitalName: hospitalName,
      date: date,
      timeSlot: timeSlot,
      status: status ?? this.status,
      tokenNumber: tokenNumber,
      isOnlineVideo: isOnlineVideo,
      jitsiRoomId: jitsiRoomId,
      symptoms: symptoms,
      doctorNotes: doctorNotes ?? this.doctorNotes,
    );
  }
}
