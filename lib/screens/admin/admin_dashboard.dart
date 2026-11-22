import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/rural_health_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/user_model.dart';
import '../patient/patient_home_nav.dart';
import '../doctor/doctor_dashboard.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _showAddCampDialog() {
    final titleController = TextEditingController();
    final villageController = TextEditingController();
    final districtController = TextEditingController(text: 'Ludhiana');
    final dateController = TextEditingController(text: 'Dec 22, 2026');
    final timeController = TextEditingController(text: '09:00 AM - 02:00 PM');
    final venueController = TextEditingController();
    final phoneController = TextEditingController(text: '104');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Announce Free Rural Health Camp'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Camp Title / Specialty'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: villageController,
                decoration: const InputDecoration(labelText: 'Village Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'District'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: venueController,
                decoration: const InputDecoration(labelText: 'Venue (e.g. Panchayat Bhavan)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Helpline Contact Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty && villageController.text.trim().isNotEmpty) {
                context.read<RuralHealthProvider>().addHealthCamp(
                      title: titleController.text.trim(),
                      village: villageController.text.trim(),
                      district: districtController.text.trim(),
                      date: dateController.text.trim(),
                      time: timeController.text.trim(),
                      venue: venueController.text.trim(),
                      organizer: 'Punjab Health Mission & District Health Society',
                      services: ['General Checkup', 'BP & Sugar Screening', 'Free Medicines'],
                      contactPhone: phoneController.text.trim(),
                    );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New Rural Health Camp broadcasted successfully!')),
                );
              }
            },
            child: const Text('Broadcast Camp'),
          ),
        ],
      ),
    );
  }

  void _showBroadcastAlertDialog() {
    final alertController = TextEditingController(
      text: 'Seasonal Dengue & Viral Fever Alert: Free testing kits available at all Civil Hospitals & PHCs.',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Broadcast Public Health Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This emergency awareness notification will be pushed to all rural patients in the selected districts.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: alertController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Alert Message'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergency),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('District Health Alert sent to 4,820 registered patients!')),
              );
            },
            child: const Text('Send Broadcast Alert'),
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
    final admin = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.admin_panel_settings_rounded, color: Colors.blueGrey, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Admin Portal • Punjab Health',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                  colors: [Colors.blueGrey, Color(0xFF263238)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings_rounded, color: Colors.blueGrey, size: 36),
              ),
              accountName: Text(
                admin?.name ?? 'Rajinder Sharma',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              accountEmail: const Text(
                'District Health Officer • Punjab State Health Mission',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined, color: Colors.blueGrey),
              title: const Text('Overview & Analytics'),
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
              leading: const Icon(Icons.medical_services_rounded, color: AppColors.secondary),
              title: const Text('Switch to Doctor Portal'),
              onTap: () async {
                Navigator.pop(context);
                await auth.switchDemoRole(UserRole.doctor);
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const DoctorDashboard()),
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
            // Analytics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildMetricCard(
                  title: 'Rural Patients',
                  value: '4,820',
                  subtitle: '+124 this week',
                  icon: Icons.groups_rounded,
                  color: AppColors.primary,
                ),
                _buildMetricCard(
                  title: 'Verified Doctors',
                  value: '48',
                  subtitle: '8 pending review',
                  icon: Icons.verified_user_rounded,
                  color: AppColors.secondary,
                ),
                _buildMetricCard(
                  title: 'Tele-Consultations',
                  value: '1,240',
                  subtitle: '98% satisfaction',
                  icon: Icons.video_call_rounded,
                  color: Colors.indigo,
                ),
                _buildMetricCard(
                  title: 'Free Health Camps',
                  value: '${rural.healthCamps.length}',
                  subtitle: 'Punjab villages',
                  icon: Icons.campaign_rounded,
                  color: Colors.orange.shade800,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Quick Actions Strip
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: '+ Announce Camp',
                    icon: Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                    height: 44,
                    onPressed: _showAddCampDialog,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: 'Send Alert',
                    icon: Icons.notifications_active_rounded,
                    color: AppColors.emergency,
                    height: 44,
                    onPressed: _showBroadcastAlertDialog,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Doctor Verification Queue
            const Text(
              'Doctor Verification Queue (3 New Applicants)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            _buildDoctorVerificationCard(
              name: 'Dr. Gurpreet Singh Sandhu',
              specialty: 'MBBS, DCH (Pediatrics)',
              hospital: 'Sub-Divisional Hospital Khanna',
              license: 'PMC-89412',
            ),
            _buildDoctorVerificationCard(
              name: 'Dr. Manjinder Kaur',
              specialty: 'MBBS, MS (Obstetrics & Gynae)',
              hospital: 'Civil Hospital Moga',
              license: 'PMC-77123',
            ),

            const SizedBox(height: 20),

            // Rural Health Camps in Punjab
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Rural Camps in Punjab',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${rural.healthCamps.length} Camps Active',
                  style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rural.healthCamps.length,
              itemBuilder: (context, idx) {
                final camp = rural.healthCamps[idx];
                return MedicalCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              camp.title,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Verified Free',
                              style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${camp.village}, District ${camp.district} • ${camp.venue}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      Text(
                        'Date: ${camp.date} • Time: ${camp.time}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
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

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorVerificationCard({
    required String name,
    required String specialty,
    required String hospital,
    required String license,
  }) {
    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primaryUltraLight,
            child: Icon(Icons.person_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                Text('$specialty • $hospital', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                Text('License: $license', style: const TextStyle(fontSize: 11, color: AppColors.primary)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Doctor $name verified successfully!')),
              );
            },
            child: const Text('Verify', style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
