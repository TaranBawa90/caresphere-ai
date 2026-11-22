import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/appointment_model.dart';
import '../data/models/doctor_model.dart';
import '../data/mock/seed_data.dart';
import '../core/services/local_storage_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<AppointmentModel> _appointments = [];
  final _uuid = const Uuid();

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);

  AppointmentProvider() {
    _loadAppointments();
  }

  void _loadAppointments() {
    final list = LocalStorageService.getAppointments();
    if (list.isNotEmpty) {
      _appointments.addAll(list);
    } else {
      _appointments.addAll(SeedData.sampleAppointments);
    }
    notifyListeners();
  }

  Future<AppointmentModel> bookAppointment({
    required String patientId,
    required String patientName,
    required String patientPhone,
    required DoctorModel doctor,
    required DateTime date,
    required String timeSlot,
    required String symptoms,
    bool isOnlineVideo = true,
  }) async {
    final tokenSuffix = 100 + _appointments.length + 1;
    final token = 'CS-PB-$tokenSuffix';
    final roomId = 'CareSphere-Consult-$token';

    final appointment = AppointmentModel(
      id: 'apt_${_uuid.v4().substring(0, 8)}',
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      doctorId: doctor.id,
      doctorName: doctor.name,
      specialty: doctor.specialty,
      hospitalName: doctor.hospitalName,
      date: date,
      timeSlot: timeSlot,
      status: AppointmentStatus.confirmed,
      tokenNumber: token,
      isOnlineVideo: isOnlineVideo,
      jitsiRoomId: roomId,
      symptoms: symptoms,
    );

    _appointments.insert(0, appointment);
    await LocalStorageService.saveAppointments(_appointments);
    notifyListeners();
    return appointment;
  }

  Future<void> updateStatus(String appointmentId, AppointmentStatus status, {String? notes}) async {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: status,
        doctorNotes: notes,
      );
      await LocalStorageService.saveAppointments(_appointments);
      notifyListeners();
    }
  }

  List<AppointmentModel> getAppointmentsForPatient(String patientId) {
    return _appointments.where((a) => a.patientId == patientId).toList();
  }

  List<AppointmentModel> getAppointmentsForDoctor(String doctorId) {
    return _appointments.where((a) => a.doctorId == doctorId).toList();
  }
}
