import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/rural_health_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/audio_speak_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../core/services/emergency_service.dart';
import '../../data/models/rural_health_model.dart';

class EmergencySosScreen extends StatelessWidget {
  const EmergencySosScreen({super.key});

  void _confirmAndDial(BuildContext context, String number, String serviceName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.call_rounded, color: AppColors.emergency, size: 26),
            const SizedBox(width: 10),
            Text('Call $serviceName?'),
          ],
        ),
        content: Text(
          'Are you sure you want to dial $number ($serviceName)? You will be connected to emergency dispatch services.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergency),
            onPressed: () {
              Navigator.pop(ctx);
              EmergencyService.dialEmergencyNumber(number);
            },
            child: const Text('Dial Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();
    final rural = context.watch<RuralHealthProvider>();
    final user = auth.currentUser;
    final currentLang = lang.currentLanguage;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          lang.tr('emergencyTitle'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.emergency),
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
            // Big Emergency Dial Grid
            Row(
              children: [
                Expanded(
                  child: _buildDialCard(
                    context,
                    number: '112',
                    title: 'National Emergency',
                    subtitle: 'Police • Ambulance • Fire',
                    color: AppColors.emergency,
                    icon: Icons.emergency_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDialCard(
                    context,
                    number: '108',
                    title: 'Free Ambulance',
                    subtitle: 'Medical Emergency Rapid',
                    color: Colors.red.shade700,
                    icon: Icons.medical_services_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDialCard(
                    context,
                    number: '104',
                    title: 'Punjab Medical Helpline',
                    subtitle: 'Doctor On Call 24x7',
                    color: AppColors.secondary,
                    icon: Icons.support_agent_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDialCard(
                    context,
                    number: '102',
                    title: 'Mother & Child Van',
                    subtitle: 'Pregnancy Rapid Transit',
                    color: Colors.pink.shade700,
                    icon: Icons.pregnant_woman_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Personal Emergency Contact Card
            MedicalCard(
              margin: EdgeInsets.zero,
              backgroundColor: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryUltraLight,
                    child: Icon(Icons.contact_phone_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saved Personal Emergency Contact',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${user?.emergencyContactRelation ?? "Son (Manpreet)"}: ${user?.emergencyContact ?? "+91 98140 12345"}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_rounded, color: AppColors.success, size: 26),
                    onPressed: () {
                      _confirmAndDial(
                        context,
                        user?.emergencyContact ?? '9814012345',
                        'Personal Contact (${user?.emergencyContactRelation ?? "Family"})',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Offline First-Aid Guides Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.tr('firstAidGuides'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '100% Offline',
                    style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // First-Aid Guides List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rural.firstAidGuides.length,
              itemBuilder: (context, idx) {
                final guide = rural.firstAidGuides[idx];
                return _buildFirstAidCard(guide, currentLang);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialCard(
    BuildContext context, {
    required String number,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => _confirmAndDial(context, number, title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const Icon(Icons.call, color: Colors.white70, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstAidCard(EmergencyFirstAidGuide guide, String langCode) {
    String title;
    List<String> steps;
    String doNotDo;

    switch (langCode) {
      case 'pa':
        title = guide.titlePa;
        steps = guide.stepsPa;
        doNotDo = guide.doNotDoPa;
        break;
      case 'hi':
        title = guide.titleHi;
        steps = guide.stepsHi;
        doNotDo = guide.doNotDoHi;
        break;
      default:
        title = guide.titleEn;
        steps = guide.stepsEn;
        doNotDo = guide.doNotDoEn;
    }

    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(guide.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
              AudioSpeakButton(
                textToSpeak: '$title. ${steps.join('. ')}. $doNotDo',
                language: langCode,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Steps
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  step,
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                ),
              )),

          const SizedBox(height: 8),

          // Do Not Do Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              doNotDo,
              style: const TextStyle(fontSize: 12, color: Color(0xFFC62828), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
