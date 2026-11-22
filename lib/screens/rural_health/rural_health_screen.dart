import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/rural_health_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/audio_speak_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/rural_health_model.dart';
import '../../core/services/emergency_service.dart';

class RuralHealthScreen extends StatelessWidget {
  const RuralHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final rural = context.watch<RuralHealthProvider>();
    final currentLang = lang.currentLanguage;

    final camps = rural.healthCamps;
    final schemes = rural.schemes;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          lang.tr('ruralHealthTitle'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: LanguageSelectorWidget(isCompact: true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Camps Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.tr('upcomingCamps'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryUltraLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${camps.length} Camps',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Free Camps Cards
            ...camps.map((camp) => _buildCampCard(camp, context)),

            const SizedBox(height: 24),

            // Government Healthcare Schemes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.tr('governmentSchemes'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
              ],
            ),
            const SizedBox(height: 12),

            // Schemes Cards
            ...schemes.map((scheme) => _buildSchemeCard(scheme, currentLang)),
          ],
        ),
      ),
    );
  }

  Widget _buildCampCard(HealthCampModel camp, BuildContext context) {
    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              camp.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        camp.title,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '100% Free',
                  style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${camp.venue}, ${camp.village}, Dist. ${camp.district}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '${camp.date} • ${camp.time}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Services chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: camp.services.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(service, style: const TextStyle(fontSize: 11, color: AppColors.textDark)),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Organized by: ${camp.organizer}',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.call, size: 14),
                label: const Text('Enquire', style: TextStyle(fontSize: 11)),
                onPressed: () => EmergencyService.dialEmergencyNumber(camp.contactPhone),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
),
);
}

  Widget _buildSchemeCard(GovernmentSchemeModel scheme, String langCode) {
    String title;
    String desc;

    switch (langCode) {
      case 'pa':
        title = scheme.titlePa;
        desc = scheme.descriptionPa;
        break;
      case 'hi':
        title = scheme.titleHi;
        desc = scheme.descriptionHi;
        break;
      default:
        title = scheme.titleEn;
        desc = scheme.descriptionEn;
    }

    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  scheme.badge,
                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              AudioSpeakButton(
                textToSpeak: '$title. $desc. Coverage: ${scheme.coverageAmount}',
                language: langCode,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
          ),
          const SizedBox(height: 10),

          // Benefit Amount Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Benefit: ${scheme.coverageAmount}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'Eligibility: ${scheme.eligibility}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            'Required Documents: ${scheme.requiredDocuments.join(", ")}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                'Helpline: ${scheme.helplineNumber}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => EmergencyService.dialEmergencyNumber(scheme.helplineNumber),
                child: const Text('Call Helpline', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
