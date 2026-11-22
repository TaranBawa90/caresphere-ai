class TtsSttPlatform {
  static void speak(String text, String lang) {}
  static void stop() {}
  static Future<String> listen({String lang = 'en'}) async => '';
}
