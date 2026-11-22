import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/network_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/language_selector_widget.dart';
import '../../core/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = LocalStorageService.getGeminiKey();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveApiKey() async {
    await LocalStorageService.setGeminiKey(_apiKeyController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gemini API Key updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final theme = context.watch<ThemeProvider>();
    final network = context.watch<NetworkProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          lang.tr('navSettings'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Multilingual Selection Section
            Text(
              lang.tr('selectLanguage'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const LanguageSelectorWidget(),

            const SizedBox(height: 24),

            // Accessibility Features
            Text(
              lang.tr('accessibilitySettings'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),

            // Simple Rural Mode Toggle
            MedicalCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(14),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryUltraLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.elderly_rounded, color: AppColors.primary),
                ),
                title: Text(
                  lang.tr('simpleMode'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: const Text(
                  'Extra large text and high-contrast buttons designed for rural seniors.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                value: theme.isSimpleMode,
                onChanged: (val) => theme.toggleSimpleMode(),
              ),
            ),

            const SizedBox(height: 12),

            // Text Size Slider
            MedicalCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_size_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            lang.tr('textSize'),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                      Text(
                        '${(theme.textScale * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: theme.textScale,
                    min: 0.85,
                    max: 1.35,
                    divisions: 5,
                    activeColor: AppColors.primary,
                    label: '${(theme.textScale * 100).toInt()}%',
                    onChanged: (val) => theme.setTextScale(val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Dark Mode Toggle
            MedicalCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(14),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryUltraLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.dark_mode_rounded, color: AppColors.secondary),
                ),
                title: Text(
                  lang.tr('darkMode'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: const Text('Easy on the eyes for night usage', style: TextStyle(fontSize: 12)),
                value: theme.isDarkMode,
                onChanged: (val) => theme.toggleDarkMode(),
              ),
            ),

            const SizedBox(height: 24),

            // Low-Internet & Offline Simulation (Hackathon Testing)
            const Text(
              'Network & Offline Resilience (Hackathon Testing)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            MedicalCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(14),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: network.isOnline ? AppColors.successLight : AppColors.warningLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    network.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    color: network.isOnline ? AppColors.success : AppColors.warning,
                  ),
                ),
                title: Text(
                  network.isOnline ? 'Online (Connected)' : 'Simulated Offline Mode',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: const Text(
                  'Toggle to demonstrate how offline caching, emergency passport, and first aid work without internet.',
                  style: TextStyle(fontSize: 12),
                ),
                value: network.isOnline,
                onChanged: (val) => network.toggleOnlineStatus(),
              ),
            ),

            const SizedBox(height: 24),

            // Gemini API Key Configuration
            const Text(
              'Gemini AI API Configuration',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            MedicalCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Optional: Provide custom Gemini API Key for live AI responses (fallback clinical AI works automatically).',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Gemini API Key',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save_rounded, color: AppColors.primary),
                        onPressed: _saveApiKey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App & Hackathon Credentials
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryUltraLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lang.tr('hackathonBadge'),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lang.tr('appVersion'),
                    style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
