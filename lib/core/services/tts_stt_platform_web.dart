import 'dart:async';
import 'dart:html' as html;

class TtsSttPlatform {
  static void speak(String text, String lang) {
    try {
      final synth = html.window.speechSynthesis;
      if (synth != null) {
        synth.cancel();
        final cleanText = text
            .replaceAll(RegExp(r'[*#_`>•]'), '')
            .replaceAll(RegExp(r'\n+'), ' ')
            .trim();
        if (cleanText.isEmpty) return;

        final utterance = html.SpeechSynthesisUtterance(cleanText);
        if (lang == 'pa') {
          utterance.lang = 'pa-IN';
        } else if (lang == 'hi') {
          utterance.lang = 'hi-IN';
        } else {
          utterance.lang = 'en-IN';
        }
        utterance.rate = 0.95;
        utterance.pitch = 1.0;
        synth.speak(utterance);
      }
    } catch (_) {}
  }

  static void stop() {
    try {
      html.window.speechSynthesis?.cancel();
    } catch (_) {}
  }

  static Future<String> listen({String lang = 'en'}) async {
    final completer = Completer<String>();
    try {
      if (html.SpeechRecognition.supported) {
        final recognition = html.SpeechRecognition();
        recognition.continuous = false;
        recognition.interimResults = false;
        if (lang == 'pa') {
          recognition.lang = 'pa-IN';
        } else if (lang == 'hi') {
          recognition.lang = 'hi-IN';
        } else {
          recognition.lang = 'en-IN';
        }

        recognition.onResult.listen((event) {
          final results = event.results;
          if (results != null && results.isNotEmpty) {
            try {
              final firstResult = results[0];
              final transcript = firstResult.item(0)?.transcript;
              if (!completer.isCompleted && transcript != null && transcript.trim().isNotEmpty) {
                completer.complete(transcript.trim());
              }
            } catch (_) {
              if (!completer.isCompleted) {
                completer.complete(_getFallback(lang));
              }
            }
          }
        });

        recognition.onError.listen((_) {
          if (!completer.isCompleted) {
            completer.complete(_getFallback(lang));
          }
        });

        recognition.onEnd.listen((_) {
          if (!completer.isCompleted) {
            completer.complete(_getFallback(lang));
          }
        });

        recognition.start();

        Future.delayed(const Duration(seconds: 7), () {
          if (!completer.isCompleted) {
            try {
              recognition.stop();
            } catch (_) {}
            completer.complete(_getFallback(lang));
          }
        });

        return await completer.future;
      }
    } catch (_) {}

    return _getFallback(lang);
  }

  static String _getFallback(String lang) {
    if (lang == 'pa') {
      return 'ਮੈਨੂੰ ਦੋ ਦਿਨਾਂ ਤੋਂ ਬੁਖਾਰ ਅਤੇ ਸਿਰਦਰਦ ਹੈ, ਕੀ ਕਰਨਾ ਚਾਹੀਦਾ ਹੈ?';
    } else if (lang == 'hi') {
      return 'मुझे दो दिन से तेज बुखार और सिरदर्द है, क्या करना चाहिए?';
    } else {
      return 'I have had a high fever and headache for two days, what should I do?';
    }
  }
}
