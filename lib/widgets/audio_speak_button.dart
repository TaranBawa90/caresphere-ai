import 'package:flutter/material.dart';
import '../core/services/tts_stt_service.dart';
import '../core/constants/app_colors.dart';

class AudioSpeakButton extends StatefulWidget {
  final String textToSpeak;
  final String language;
  final double size;

  const AudioSpeakButton({
    super.key,
    required this.textToSpeak,
    this.language = 'en',
    this.size = 20,
  });

  @override
  State<AudioSpeakButton> createState() => _AudioSpeakButtonState();
}

class _AudioSpeakButtonState extends State<AudioSpeakButton> {
  bool _isPlaying = false;

  void _handleToggle() async {
    if (_isPlaying) {
      await TtsSttService.stopSpeaking();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (mounted) setState(() => _isPlaying = true);
      await TtsSttService.speak(widget.textToSpeak, lang: widget.language);
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.volume_up_rounded : Icons.volume_up_outlined,
        color: _isPlaying ? AppColors.primary : AppColors.textMuted,
        size: widget.size,
      ),
      tooltip: 'Read Aloud (TTS)',
      onPressed: _handleToggle,
      visualDensity: VisualDensity.compact,
    );
  }
}
