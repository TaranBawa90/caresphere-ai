import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/ai_chat_provider.dart';
import '../../widgets/language_selector_widget.dart';
import '../../widgets/audio_speak_button.dart';
import '../../data/models/chat_message.dart';
import '../emergency/emergency_sos_screen.dart';

class AiChatScreen extends StatefulWidget {
  final bool isEmbedded;

  const AiChatScreen({super.key, this.isEmbedded = false});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? query]) {
    final text = query ?? _textController.text;
    if (text.trim().isEmpty) return;
    final lang = context.read<LanguageProvider>().currentLanguage;
    context.read<AiChatProvider>().sendMessage(text, lang);
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final chat = context.watch<AiChatProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.tr('aiAssistantTitle'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    lang.tr('aiAssistantSubtitle'),
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.textMuted),
                  tooltip: lang.tr('clearChat'),
                  onPressed: () => chat.clearHistory(lang.currentLanguage),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: LanguageSelectorWidget(isCompact: true),
                ),
              ],
            ),
      body: Column(
        children: [
          // Medical Safety Disclaimer Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFFF8E1),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFF57C00)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lang.tr('aiDisclaimer'),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chat.messages.length + (chat.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chat.messages.length) {
                  return _buildTypingIndicator(lang);
                }
                final message = chat.messages[index];
                return _buildMessageBubble(message, lang);
              },
            ),
          ),

          // Suggested Prompts Horizontal Chips
          if (!chat.isLoading && chat.messages.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  _buildChip(lang.tr('suggestedFever')),
                  _buildChip(lang.tr('suggestedBP')),
                  _buildChip(lang.tr('suggestedDiabetes')),
                  _buildChip(lang.tr('suggestedSnakeBite')),
                ],
              ),
            ),
          ],

          // Voice Listening Indicator (when recording)
          if (chat.isListening)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: AppColors.primaryUltraLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    lang.tr('listening'),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          // Chat Input Box
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Voice Input Microphone Button
                IconButton(
                  icon: Icon(
                    chat.isListening ? Icons.mic : Icons.mic_none_rounded,
                    color: chat.isListening ? AppColors.emergency : AppColors.primary,
                    size: 26,
                  ),
                  tooltip: 'Voice Input (Punjabi / Hindi / English)',
                  onPressed: () => chat.triggerVoiceInput(lang.currentLanguage),
                ),
                // Text Field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (val) => _handleSend(),
                    decoration: InputDecoration(
                      hintText: lang.tr('aiHintText'),
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () => _handleSend(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => _handleSend(label),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, LanguageProvider lang) {
    final isUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.isEmergencyAlert ? AppColors.emergency : AppColors.primary,
              child: Icon(
                message.isEmergencyAlert ? Icons.warning_rounded : Icons.medical_services_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : message.isEmergencyAlert
                            ? const Color(0xFFFFEBEE)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                      bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
                    ),
                    border: Border.all(
                      color: message.isEmergencyAlert
                          ? AppColors.emergency
                          : isUser
                              ? AppColors.primary
                              : AppColors.border,
                      width: message.isEmergencyAlert ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        message.text,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: isUser
                              ? Colors.white
                              : message.isEmergencyAlert
                                  ? const Color(0xFFB71C1C)
                                  : AppColors.textDark,
                          fontWeight: message.isEmergencyAlert ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (message.isEmergencyAlert) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emergency,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          icon: const Icon(Icons.call, size: 16),
                          label: const Text('Open Emergency SOS 112 / 108'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const EmergencySosScreen()),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Audio Read Aloud & Timestamp Row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser) ...[
                      AudioSpeakButton(
                        textToSpeak: message.text,
                        language: message.language ?? lang.currentLanguage,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryUltraLight,
              child: Icon(Icons.person_rounded, color: AppColors.primary, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                SizedBox(width: 8),
                Text(
                  'CareSphere AI is thinking...',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
