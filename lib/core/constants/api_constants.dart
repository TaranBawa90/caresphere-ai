class ApiConstants {
  // Gemini API Configuration
  // Can be overridden via environment variables or settings in-app
  static const String defaultGeminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // Video Consultation Configuration (Jitsi Meet)
  static const String jitsiServerUrl = 'https://meet.jit.si';
  static const String appRoomPrefix = 'CareSphere-AI-Consult-';

  // Emergency Contact Numbers (India / Punjab)
  static const String emergencyNational = '112'; // All-in-One Emergency
  static const String emergencyAmbulance = '108'; // Free Ambulance
  static const String emergencyPunjabHelpline = '104'; // Punjab Medical Helpline
  static const String emergencyMotherChild = '102'; // Pregnancy & Child Ambulance
  static const String emergencyChildline = '1098'; // National Childline

  // Local Storage Keys
  static const String keyUserToken = 'user_token';
  static const String keyUserData = 'user_data';
  static const String keyUserRole = 'user_role';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keySimpleMode = 'simple_mode';
  static const String keyTextScale = 'text_scale';
  static const String keyChatHistory = 'chat_history';
  static const String keyPrescriptions = 'saved_prescriptions';
  static const String keyAppointments = 'saved_appointments';
  static const String keyHealthRecords = 'saved_health_records';
  static const String keyMedicineReminders = 'saved_medicine_reminders';
  static const String keyGeminiCustomKey = 'custom_gemini_key';
}
