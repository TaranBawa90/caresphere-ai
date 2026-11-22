import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/network_status_banner.dart';
import '../../widgets/language_selector_widget.dart';
import '../../widgets/emergency_sos_fab.dart';
import 'patient_dashboard.dart';
import '../ai_assistant/ai_chat_screen.dart';
import '../prescription/prescription_scanner_screen.dart';
import '../hospital/hospital_finder_screen.dart';
import '../records/health_records_screen.dart';
import '../reminders/medicine_reminders_screen.dart';
import '../emergency/emergency_sos_screen.dart';
import '../rural_health/rural_health_screen.dart';
import '../settings/settings_screen.dart';
import '../auth/login_screen.dart';
import '../doctor/doctor_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../../data/models/user_model.dart';

class PatientHomeNav extends StatefulWidget {
  final int initialIndex;
  const PatientHomeNav({super.key, this.initialIndex = 0});

  @override
  State<PatientHomeNav> createState() => _PatientHomeNavState();
}

class _PatientHomeNavState extends State<PatientHomeNav> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = const [
    PatientDashboard(),
    AiChatScreen(isEmbedded: true),
    PrescriptionScannerScreen(isEmbedded: true),
    HospitalFinderScreen(isEmbedded: true),
    HealthRecordsScreen(isEmbedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              lang.tr('appName'),
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
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0] : 'P',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              accountName: Text(
                user?.name ?? 'Gurpreet Singh',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              accountEmail: Text(
                '${user?.phone ?? '+91 98765 43210'} • ${lang.tr('rolePatient')}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home_rounded, color: AppColors.primary),
              title: Text(lang.tr('navHome')),
              selected: _currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
              title: Text(lang.tr('navAiChat')),
              selected: _currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_rounded, color: AppColors.secondary),
              title: Text(lang.tr('navPrescriptions')),
              selected: _currentIndex == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital_rounded, color: AppColors.primary),
              title: Text(lang.tr('navHospitals')),
              selected: _currentIndex == 3,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_shared_rounded, color: Colors.teal),
              title: Text(lang.tr('navRecords')),
              selected: _currentIndex == 4,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 4);
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm_rounded, color: Colors.indigo),
              title: Text(lang.tr('navReminders')),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MedicineRemindersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign_rounded, color: Colors.orange),
              title: Text(lang.tr('navRuralHealth')),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RuralHealthScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.emergency_rounded, color: AppColors.emergency),
              title: Text(
                lang.tr('navEmergency'),
                style: const TextStyle(color: AppColors.emergency, fontWeight: FontWeight.w700),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EmergencySosScreen()),
                );
              },
            ),

            const Divider(),

            // Demo Role Switcher for Hackathon Judges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Switch Demo Role (Hackathon)',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade600),
              ),
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
              leading: const Icon(Icons.settings_accessibility_rounded, color: AppColors.textMuted),
              title: Text(lang.tr('navSettings')),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
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
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
      floatingActionButton: _currentIndex == 0 ? const EmergencySosFab() : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: lang.tr('navHome'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome_rounded),
            label: lang.tr('navAiChat'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.document_scanner_outlined),
            activeIcon: const Icon(Icons.document_scanner_rounded),
            label: lang.tr('navPrescriptions'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_hospital_outlined),
            activeIcon: const Icon(Icons.local_hospital_rounded),
            label: lang.tr('navHospitals'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder_shared_outlined),
            activeIcon: const Icon(Icons.folder_shared_rounded),
            label: lang.tr('navRecords'),
          ),
        ],
      ),
    );
  }
}
