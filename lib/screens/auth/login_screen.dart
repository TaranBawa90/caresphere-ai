import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/user_model.dart';
import '../patient/patient_home_nav.dart';
import '../doctor/doctor_dashboard.dart';
import '../admin/admin_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'gurpreet.singh@caresphere.ai');
  final _passwordController = TextEditingController(text: 'demo1234');
  bool _obscurePassword = true;

  void _routeToRole(UserRole role) {
    Widget target;
    switch (role) {
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
  }

  void _handleLogin() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success && mounted) {
      _routeToRole(auth.currentRole);
    }
  }

  void _handleQuickDemoLogin(UserRole role) async {
    final auth = context.read<AuthProvider>();
    await auth.switchDemoRole(role);
    if (mounted) {
      _routeToRole(role);
    }
  }

  void _showForgotPasswordDialog() {
    final lang = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.tr('forgotPassword')),
        content: const Text(
          'Password reset instructions will be sent to your registered mobile number and email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.tr('confirm')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryUltraLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryLight, width: 2),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    size: 38,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  lang.tr('appName'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Center(
                child: Text(
                  lang.tr('loginSubtitle'),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Hackathon Quick Demo Account Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          lang.tr('quickDemoLogin'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.person_rounded, size: 16, color: AppColors.primary),
                          label: Text(lang.tr('rolePatient')),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.primary),
                          onPressed: () => _handleQuickDemoLogin(UserRole.patient),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.medical_services_rounded, size: 16, color: AppColors.secondary),
                          label: Text(lang.tr('roleDoctor')),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.secondary),
                          onPressed: () => _handleQuickDemoLogin(UserRole.doctor),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.admin_panel_settings_rounded, size: 16, color: Colors.blueGrey),
                          label: Text(lang.tr('roleAdmin')),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.blueGrey),
                          onPressed: () => _handleQuickDemoLogin(UserRole.admin),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email input
              Text(
                lang.tr('email'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted),
                  hintText: 'name@example.com',
                ),
              ),
              const SizedBox(height: 16),

              // Password input
              Text(
                lang.tr('password'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text(
                    lang.tr('forgotPassword'),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Login Button
              CustomButton(
                text: lang.tr('login'),
                icon: Icons.login_rounded,
                isLoading: auth.isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 20),

              // Switch to Register
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    lang.tr('dontHaveAccount'),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
