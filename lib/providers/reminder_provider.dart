import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/reminder_model.dart';
import '../data/mock/seed_data.dart';
import '../core/services/local_storage_service.dart';

class ReminderProvider extends ChangeNotifier {
  final List<ReminderModel> _reminders = [];
  final _uuid = const Uuid();

  List<ReminderModel> get reminders => List.unmodifiable(_reminders);

  ReminderProvider() {
    _loadReminders();
  }

  void _loadReminders() {
    final list = LocalStorageService.getReminders();
    if (list.isNotEmpty) {
      _reminders.addAll(list);
    } else {
      _reminders.addAll(SeedData.sampleReminders);
    }
    notifyListeners();
  }

  int get adherenceRatePercentage {
    if (_reminders.isEmpty) return 100;
    final takenCount = _reminders.where((r) => r.isTakenToday).length;
    return ((takenCount / _reminders.length) * 100).round();
  }

  Future<void> toggleTaken(String reminderId) async {
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      final rem = _reminders[index];
      rem.isTakenToday = !rem.isTakenToday;
      rem.lastTakenAt = rem.isTakenToday ? DateTime.now() : null;
      await LocalStorageService.saveReminders(_reminders);
      notifyListeners();
    }
  }

  Future<void> addReminder({
    required String name,
    required String dosage,
    required String timeString,
    bool isMorning = true,
    bool isAfternoon = false,
    bool isNight = false,
    bool beforeFood = false,
    String instructions = 'Take with water',
  }) async {
    final reminder = ReminderModel(
      id: 'rem_${_uuid.v4().substring(0, 8)}',
      medicineName: name,
      dosage: dosage,
      timeString: timeString,
      isMorning: isMorning,
      isAfternoon: isAfternoon,
      isNight: isNight,
      beforeFood: beforeFood,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      instructions: instructions,
    );

    _reminders.add(reminder);
    await LocalStorageService.saveReminders(_reminders);
    notifyListeners();
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await LocalStorageService.saveReminders(_reminders);
    notifyListeners();
  }
}
