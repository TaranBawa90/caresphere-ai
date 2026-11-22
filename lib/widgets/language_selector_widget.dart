import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../core/constants/app_colors.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final bool isCompact;

  const LanguageSelectorWidget({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final current = langProvider.currentLanguage;

    final languages = [
      {'code': 'en', 'label': 'English', 'native': 'English'},
      {'code': 'hi', 'label': 'Hindi', 'native': 'हिन्दी'},
      {'code': 'pa', 'label': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
    ];

    if (isCompact) {
      return PopupMenuButton<String>(
        initialValue: current,
        onSelected: (code) => langProvider.setLanguage(code),
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryUltraLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                current.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        itemBuilder: (context) {
          return languages.map((lang) {
            final isSelected = lang['code'] == current;
            return PopupMenuItem<String>(
              value: lang['code'],
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: isSelected ? AppColors.primary : Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${lang['native']} (${lang['label']})',
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
      );
    }

    // Expanded Segmented / Card Selector
    return Row(
      children: languages.map((lang) {
        final isSelected = lang['code'] == current;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => langProvider.setLanguage(lang['code']!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Text(
                      lang['native']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lang['label']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white70 : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
