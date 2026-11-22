import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../data/models/user_model.dart';
import '../patient/patient_home_nav.dart';
import '../doctor/doctor_dashboard.dart';
import '../admin/admin_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserRole _selectedRole = UserRole.patient;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specializationController = TextEditingController();
  final _licenseController = TextEditingController();
  final _bloodGroupController = TextEditingController(text: 'B+');
  final _emergencyContactController = TextEditingController();

  void _handleRegister() async {
    final auth = context.read<AuthProvider>();
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields.')),
      );
      return;
    }

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      password: _passwordController.text.trim(),
      specialization: _specializationController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      bloodGroup: _bloodGroupController.text.trim(),
      emergencyContact: _emergencyContactController.text.trim(),
    );

    if (success && mounted) {
      Widget target;
      switch (_selectedRole) {
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => target),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(lang.tr('registerTitle')),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.tr('registerSubtitle'),
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Role Selector Segmented
              Text(
                lang.tr('selectRole'),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text(lang.tr('rolePatient')),
                      selected: _selectedRole == UserRole.patient,
                      onSelected: (val) => setState(() => _selectedRole = UserRole.patient),
                      selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(lang.tr('roleDoctor')),
                      selected: _selectedRole == UserRole.doctor,
                      onSelected: (val) => setState(() => _selectedRole = UserRole.doctor),
                      selectedColor: AppColors.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(lang.tr('roleAdmin')),
                      selected: _selectedRole == UserRole.admin,
                      onSelected: (val) => setState(() => _selectedRole = UserRole.admin),
                      selectedColor: Colors.blueGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Full Name
              Text(lang.tr('name'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
                  hintText: 'e.g. Jaswinder Kaur',
                ),
              ),
              const SizedBox(height: 16),

              // Email
              Text(lang.tr('email'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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

              // Phone
              Text(lang.tr('phone'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textMuted),
                  hintText: '+91 98765 43210',
                ),
              ),
              const SizedBox(height: 16),

              // Role Specific Inputs
              if (_selectedRole == UserRole.doctor) ...[
                const Text('Specialization', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _specializationController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined, color: AppColors.textMuted),
                    hintText: 'e.g. General Physician, Pediatrician',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Medical License / Registration No.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _licenseController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.verified_outlined, color: AppColors.textMuted),
                    hintText: 'e.g. PMC-48291',
                  ),
                ),
                const SizedBox(height: 16),
              ] else if (_selectedRole == UserRole.patient) ...[
                const Text('Blood Group', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _bloodGroupController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.bloodtype_outlined, color: AppColors.emergency),
                    hintText: 'O+, A+, B+, AB+',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Emergency Contact Phone', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: _emergencyContactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.contact_phone_outlined, color: AppColors.textMuted),
                    hintText: 'Family member contact number',
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Password
              Text(lang.tr('password'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                  hintText: '••••••••',
                ),
              ),
              const SizedBox(height: 24),

              // Register Button
              CustomButton(
                text: lang.tr('register'),
                icon: Icons.person_add_rounded,
                isLoading: auth.isLoading,
                onPressed: _handleRegister,
              ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    lang.tr('alreadyHaveAccount'),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
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
