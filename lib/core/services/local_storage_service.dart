import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/prescription_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/health_record_model.dart';
import '../../data/models/reminder_model.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // User session
  static Future<void> saveUser(UserModel user) async {
    await init();
    await _prefs!.setString(ApiConstants.keyUserData, jsonEncode(user.toJson()));
    await _prefs!.setString(ApiConstants.keyUserRole, user.role.name);
  }

  static UserModel? getUser() {
    final str = _prefs?.getString(ApiConstants.keyUserData);
    if (str == null || str.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(str));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await init();
    await _prefs!.remove(ApiConstants.keyUserData);
    await _prefs!.remove(ApiConstants.keyUserRole);
  }

  // Preferences
  static String getLanguage() => _prefs?.getString(ApiConstants.keySelectedLanguage) ?? 'en';
  static Future<void> setLanguage(String lang) async {
    await init();
    await _prefs!.setString(ApiConstants.keySelectedLanguage, lang);
  }

  static bool isDarkMode() => _prefs?.getBool(ApiConstants.keyIsDarkMode) ?? false;
  static Future<void> setDarkMode(bool val) async {
    await init();
    await _prefs!.setBool(ApiConstants.keyIsDarkMode, val);
  }

  static bool isSimpleMode() => _prefs?.getBool(ApiConstants.keySimpleMode) ?? false;
  static Future<void> setSimpleMode(bool val) async {
    await init();
    await _prefs!.setBool(ApiConstants.keySimpleMode, val);
  }

  static double getTextScale() => _prefs?.getDouble(ApiConstants.keyTextScale) ?? 1.0;
  static Future<void> setTextScale(double scale) async {
    await init();
    await _prefs!.setDouble(ApiConstants.keyTextScale, scale);
  }

  static String getGeminiKey() => _prefs?.getString(ApiConstants.keyGeminiCustomKey) ?? '';
  static Future<void> setGeminiKey(String key) async {
    await init();
    await _prefs!.setString(ApiConstants.keyGeminiCustomKey, key);
  }

  // Chat History
  static List<ChatMessage> getChatHistory() {
    final str = _prefs?.getString(ApiConstants.keyChatHistory);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => ChatMessage.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveChatHistory(List<ChatMessage> messages) async {
    await init();
    final jsonList = messages.map((m) => m.toJson()).toList();
    await _prefs!.setString(ApiConstants.keyChatHistory, jsonEncode(jsonList));
  }

  // Prescriptions
  static List<PrescriptionModel> getPrescriptions() {
    final str = _prefs?.getString(ApiConstants.keyPrescriptions);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => PrescriptionModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> savePrescriptions(List<PrescriptionModel> prescriptions) async {
    await init();
    final jsonList = prescriptions.map((p) => p.toJson()).toList();
    await _prefs!.setString(ApiConstants.keyPrescriptions, jsonEncode(jsonList));
  }

  // Appointments
  static List<AppointmentModel> getAppointments() {
    final str = _prefs?.getString(ApiConstants.keyAppointments);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => AppointmentModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveAppointments(List<AppointmentModel> appointments) async {
    await init();
    final jsonList = appointments.map((a) => a.toJson()).toList();
    await _prefs!.setString(ApiConstants.keyAppointments, jsonEncode(jsonList));
  }

  // Health Records
  static List<HealthRecordModel> getHealthRecords() {
    final str = _prefs?.getString(ApiConstants.keyHealthRecords);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => HealthRecordModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveHealthRecords(List<HealthRecordModel> records) async {
    await init();
    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs!.setString(ApiConstants.keyHealthRecords, jsonEncode(jsonList));
  }

  // Medicine Reminders
  static List<ReminderModel> getReminders() {
    final str = _prefs?.getString(ApiConstants.keyMedicineReminders);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => ReminderModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveReminders(List<ReminderModel> reminders) async {
    await init();
    final jsonList = reminders.map((r) => r.toJson()).toList();
    await _prefs!.setString(ApiConstants.keyMedicineReminders, jsonEncode(jsonList));
  }
}
