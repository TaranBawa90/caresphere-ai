enum MessageSender { user, ai, system }

class ChatMessage {
  final String id;
  final MessageSender sender;
  final String text;
  final DateTime timestamp;
  final bool isEmergencyAlert;
  final List<String>? suggestedChips;
  final String? language;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isEmergencyAlert = false,
    this.suggestedChips,
    this.language = 'en',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.name,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isEmergencyAlert': isEmergencyAlert,
      'suggestedChips': suggestedChips,
      'language': language,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      sender: MessageSender.values.firstWhere(
        (e) => e.name == json['sender'],
        orElse: () => MessageSender.user,
      ),
      text: json['text'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isEmergencyAlert: json['isEmergencyAlert'] ?? false,
      suggestedChips: json['suggestedChips'] != null
          ? List<String>.from(json['suggestedChips'])
          : null,
      language: json['language'] ?? 'en',
    );
  }
}
