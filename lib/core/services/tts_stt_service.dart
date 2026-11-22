import 'package:flutter/foundation.dart';
import 'tts_stt_platform_stub.dart'
    if (dart.library.html) 'tts_stt_platform_web.dart'
    if (dart.library.io) 'tts_stt_platform_io.dart';

class TtsSttService {
  static bool _isSpeaking = false;
  static bool _isListening = false;

  static bool get isSpeaking => _isSpeaking;
  static bool get isListening => _isListening;

  // Read aloud text (TTS)
  static Future<void> speak(String text, {String lang = 'en'}) async {
    _isSpeaking = true;
    debugPrint('[TTS] Speaking in ($lang): $text');
    TtsSttPlatform.speak(text, lang);

    // Track speech active state
    final durationMs = (text.length * 45).clamp(1000, 6000);
    await Future.delayed(Duration(milliseconds: durationMs));
    _isSpeaking = false;
  }

  static Future<void> stopSpeaking() async {
    _isSpeaking = false;
    TtsSttPlatform.stop();
    debugPrint('[TTS] Stopped speaking');
  }

  // Voice speech-to-text input (STT)
  static Future<String> simulateVoiceInput({String lang = 'en'}) async {
    _isListening = true;
    final result = await TtsSttPlatform.listen(lang: lang);
    _isListening = false;
    return result;
  }
}
