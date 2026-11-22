import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/language_selector_widget.dart';
import '../widgets/custom_button.dart';
import 'patient/patient_home_nav.dart';
import 'doctor/doctor_dashboard.dart';
import 'admin/admin_dashboard.dart';
import 'auth/login_screen.dart';
import '../data/models/user_model.dart';

class SplashOnboardingScreen extends StatefulWidget {
  const SplashOnboardingScreen({super.key});

  @override
  State<SplashOnboardingScreen> createState() => _SplashOnboardingScreenState();
}

class _SplashOnboardingScreenState extends State<SplashOnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  void _navigateToDashboard() {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      Widget target;
      switch (auth.currentRole) {
        case UserRole.doctor:
          target = const DoctorDashboard();
          break;
        case UserRole.admin:
          target = const AdminDashboard();
          break;
        case UserRole.patient:
          target = const PatientHomeNav();
          break;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => target),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    final slides = [
      {
        'icon': Icons.medical_services_rounded,
        'title': lang.tr('appName'),
        'subtitle': lang.tr('tagline'),
        'desc': 'Bridging the rural healthcare gap with multilingual AI, prescription recognition, and tele-consultations.',
      },
      {
        'icon': Icons.record_voice_over_rounded,
        'title': 'Multilingual & Voice Enabled',
        'subtitle': 'English • हिन्दी • ਪੰਜਾਬੀ',
        'desc': 'Designed for rural citizens and elderly patients with complete voice input, audio read-aloud, and plain-language explanations.',
      },
      {
        'icon': Icons.emergency_rounded,
        'title': 'Emergency SOS & 100% Offline Support',
        'subtitle': 'One-Tap 112 / 108 Calling',
        'desc': 'Works reliably even in low connectivity zones with offline health passport and first-aid guides.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LanguageSelectorWidget(isCompact: true),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Hackathon Badge
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryUltraLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    lang.tr('hackathonBadge'),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primaryUltraLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryLight, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              slide['icon'] as IconData,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            slide['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide['subtitle'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            slide['desc'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Language Selector Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.tr('selectLanguage'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const LanguageSelectorWidget(),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: lang.tr('continueBtn'),
                icon: Icons.arrow_forward_rounded,
                onPressed: _navigateToDashboard,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
