import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/user_model.dart';
import '../consultation/video_consultation_screen.dart';
import '../patient/patient_home_nav.dart';
import '../admin/admin_dashboard.dart';
import '../auth/login_screen.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();
    final appointments = context.watch<AppointmentProvider>();
    final doctor = auth.currentUser;

    final doctorAppointments = appointments.appointments;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.medical_services_rounded, color: AppColors.secondary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Doctor Portal • CareSphere',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: LanguageSelectorWidget(isCompact: true),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, Color(0xFF004D40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.medical_services_rounded, color: AppColors.secondary, size: 36),
              ),
              accountName: Text(
                doctor?.name ?? 'Dr. Harpreet Kaur',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              accountEmail: Text(
                '${doctor?.specialization ?? 'Internal Medicine'} • ${doctor?.licenseNumber ?? 'PMC-54892'}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline_rounded, color: AppColors.secondary),
              title: const Text('Patient Consultation Queue'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Demo Role Switcher (Hackathon)',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade600),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded, color: AppColors.primary),
              title: const Text('Switch to Patient Portal'),
              onTap: () async {
                Navigator.pop(context);
                await auth.switchDemoRole(UserRole.patient);
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const PatientHomeNav()),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blueGrey),
              title: const Text('Switch to Administrator Portal'),
              onTap: () async {
                Navigator.pop(context);
                await auth.switchDemoRole(UserRole.admin);
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AdminDashboard()),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: Text(lang.tr('logout')),
              onTap: () async {
                Navigator.pop(context);
                await auth.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, Color(0xFF004D40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.medical_services_rounded, color: AppColors.secondary, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor?.name ?? 'Dr. Harpreet Kaur',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              doctor?.specialization ?? 'General Physician & Diabetologist',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            Text(
                              'Civil Hospital & Telemedicine Centre, Ludhiana',
                              style: const TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDoctorStat('Today Queue', '${doctorAppointments.length}'),
                      _buildDoctorStat('Tele-Consults', '18'),
                      _buildDoctorStat('Experience', '14 Yrs'),
                      _buildDoctorStat('Rating', '4.9 ★'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Queue Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Patient Queue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '● Active Consultations',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Appointments List
            if (doctorAppointments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No appointments in queue for today.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: doctorAppointments.length,
                itemBuilder: (context, idx) {
                  final apt = doctorAppointments[idx];
                  return MedicalCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                apt.tokenNumber,
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              apt.timeSlot,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          apt.patientName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Phone: ${apt.patientPhone}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reported Symptoms / Concern:',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                apt.symptoms.isNotEmpty
                                    ? apt.symptoms
                                    : 'Follow-up consultation for chronic disease monitoring.',
                                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Start Jitsi Video',
                                icon: Icons.video_camera_front_rounded,
                                color: AppColors.secondary,
                                height: 42,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => VideoConsultationScreen(
                                        appointment: apt,
                                        isDoctorView: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                side: const BorderSide(color: AppColors.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                              label: const Text('Mark Done'),
                              onPressed: () {
                                appointments.updateStatus(apt.id, AppointmentStatus.completed);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Consultation marked completed.')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
