import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message.dart';
import '../core/services/ai_service.dart';
import '../core/services/tts_stt_service.dart';
import '../core/services/local_storage_service.dart';

class AiChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _currentlySpeakingMessageId;
  bool _isListening = false;
  final _uuid = const Uuid();

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get currentlySpeakingMessageId => _currentlySpeakingMessageId;
  bool get isListening => _isListening;

  AiChatProvider() {
    _loadMessages();
  }

  void _loadMessages() {
    final history = LocalStorageService.getChatHistory();
    if (history.isNotEmpty) {
      _messages.addAll(history);
    } else {
      _addWelcomeMessage('en');
    }
    notifyListeners();
  }

  void _addWelcomeMessage(String lang) {
    String text = 'Hello! I am your CareSphere AI Healthcare Assistant. You can ask me any health questions in English, Hindi, or Punjabi, or describe your symptoms. In emergency situations, please call 112 or 108 immediately.';
    if (lang == 'pa') {
      text = 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਕੇਅਰਸਫੀਅਰ ਏਆਈ ਸਿਹਤ ਸਹਾਇਕ ਹਾਂ। ਤੁਸੀਂ ਪੰਜਾਬੀ, ਹਿੰਦੀ ਜਾਂ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਕੋਈ ਵੀ ਸਿਹਤ ਸਵਾਲ ਪੁੱਛ ਸਕਦੇ ਹੋ ਜਾਂ ਲੱਛਣ ਦੱਸ ਸਕਦੇ ਹੋ। ਐਮਰਜੈਂਸੀ ਵਿੱਚ ਤੁਰੰਤ 112 ਜਾਂ 108 ਉੱਤੇ ਕਾਲ ਕਰੋ।';
    } else if (lang == 'hi') {
      text = 'नमस्ते! मैं आपका केयरस्फ़ीयर एआई स्वास्थ्य सहायक हूँ। आप हिंदी, पंजाबी या अंग्रेजी में कोई भी स्वास्थ्य प्रश्न पूछ सकते हैं। किसी भी आपातकाल में तुरंत 112 या 108 पर कॉल करें।';
    }

    _messages.add(
      ChatMessage(
        id: _uuid.v4(),
        sender: MessageSender.ai,
        text: text,
        timestamp: DateTime.now(),
        suggestedChips: lang == 'pa'
            ? ['ਬੁਖਾਰ ਦੇ ਘਰੇਲੂ ਨੁਸਖੇ', 'ਹਾਈ ਬੀ.ਪੀ. ਦੇ ਲੱਛਣ', 'ਸੱਪ ਦੇ ਕੱਟਣ ਤੇ ਮੁਢਲੀ ਸਹਾਇਤਾ']
            : lang == 'hi'
                ? ['बुखार के घरेलू उपाय', 'हाई बीपी के लक्षण', 'सांप के काटने पर प्राथमिक उपचार']
                : ['High fever home care', 'Normal blood pressure range', 'Snake bite first aid'],
        language: lang,
      ),
    );
  }

  Future<void> sendMessage(String text, String lang) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      sender: MessageSender.user,
      text: text.trim(),
      timestamp: DateTime.now(),
      language: lang,
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AiService.askHealthcareAssistant(
        query: text.trim(),
        language: lang,
      );

      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        sender: MessageSender.ai,
        text: response.text,
        timestamp: DateTime.now(),
        isEmergencyAlert: response.isEmergency,
        suggestedChips: response.suggestedChips,
        language: lang,
      );

      _messages.add(aiMessage);
      await LocalStorageService.saveChatHistory(_messages);
    } catch (_) {
      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          sender: MessageSender.ai,
          text: lang == 'pa'
              ? 'ਮੁਆਫ਼ ਕਰਨਾ, ਇਸ ਸਮੇਂ ਸਰਵਰ ਨਾਲ ਸੰਪਰਕ ਨਹੀਂ ਹੋ ਸਕਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।'
              : 'Unable to reach the assistant right now. Please verify your connection or retry.',
          timestamp: DateTime.now(),
          language: lang,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> triggerVoiceInput(String lang) async {
    _isListening = true;
    notifyListeners();

    final recognizedText = await TtsSttService.simulateVoiceInput(lang: lang);
    _isListening = false;
    notifyListeners();

    if (recognizedText.isNotEmpty) {
      await sendMessage(recognizedText, lang);
    }
  }

  Future<void> toggleSpeak(ChatMessage message) async {
    if (_currentlySpeakingMessageId == message.id) {
      await TtsSttService.stopSpeaking();
      _currentlySpeakingMessageId = null;
    } else {
      _currentlySpeakingMessageId = message.id;
      notifyListeners();
      await TtsSttService.speak(message.text, lang: message.language ?? 'en');
      _currentlySpeakingMessageId = null;
    }
    notifyListeners();
  }

  Future<void> clearHistory(String lang) async {
    await TtsSttService.stopSpeaking();
    _messages.clear();
    _addWelcomeMessage(lang);
    await LocalStorageService.saveChatHistory(_messages);
    notifyListeners();
  }
}
