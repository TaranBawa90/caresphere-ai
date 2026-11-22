import 'dart:async';

class TtsSttPlatform {
  static void speak(String text, String lang) {}
  static void stop() {}
  static Future<String> listen({String lang = 'en'}) async {
    if (lang == 'pa') {
      return 'ਮੈਨੂੰ ਦੋ ਦਿਨਾਂ ਤੋਂ ਬੁਖਾਰ ਅਤੇ ਸਿਰਦਰਦ ਹੈ, ਕੀ ਕਰਨਾ ਚਾਹੀਦਾ ਹੈ?';
    } else if (lang == 'hi') {
      return 'मुझे दो दिन से तेज बुखार और सिरदर्द है, क्या करना चाहिए?';
    } else {
      return 'I have had a high fever and headache for two days, what should I do?';
    }
  }
}
