import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/rural_health_provider.dart';
import '../../providers/hospital_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/audio_speak_button.dart';
import '../../core/services/emergency_service.dart';
import '../../core/services/tts_stt_service.dart';
import '../../data/models/doctor_model.dart';
import '../ai_assistant/ai_chat_screen.dart';
import '../prescription/prescription_scanner_screen.dart';
import '../hospital/hospital_finder_screen.dart';
import '../records/health_records_screen.dart';
import '../records/emergency_passport_screen.dart';
import '../emergency/emergency_sos_screen.dart';
import '../consultation/video_consultation_screen.dart';
import '../rural_health/rural_health_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showLogVitalsDialog(BuildContext context, String patientId) {
    final sysController = TextEditingController(text: '120');
    final diaController = TextEditingController(text: '80');
    final sugarController = TextEditingController(text: '110');
    final spo2Controller = TextEditingController(text: '98');
    final hrController = TextEditingController(text: '72');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.monitor_heart_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Log Today\'s Vitals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sysController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Systolic BP', suffixText: 'mmHg'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: diaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Diastolic BP', suffixText: 'mmHg'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Fasting Blood Sugar', suffixText: 'mg/dL'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: spo2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Blood Oxygen (SpO2)', suffixText: '%'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: hrController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Pulse Rate', suffixText: 'bpm'),
                    ),
                  ),
                ],
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
              final sys = int.tryParse(sysController.text) ?? 120;
              final dia = int.tryParse(diaController.text) ?? 80;
              final sugar = int.tryParse(sugarController.text) ?? 110;
              final spo2 = int.tryParse(spo2Controller.text) ?? 98;
              final hr = int.tryParse(hrController.text) ?? 72;

              context.read<HealthRecordsProvider>().recordQuickVitals(
                    patientId: patientId,
                    systolic: sys,
                    diastolic: dia,
                    bloodSugar: sugar,
                    heartRate: hr,
                    spO2: spo2,
                  );

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vitals updated successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save to Records'),
          ),
        ],
      ),
    );
  }

  void _showDoctorBookingSheet(BuildContext context, DoctorModel doctor) {
    String selectedSlot = doctor.timeSlots.first;
    final symptomsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(doctor.avatarUrl),
                      onBackgroundImageError: (_, __) {},
                      child: Text(doctor.name[0]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            '${doctor.specialty} • ${doctor.hospitalName}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Choose Consultation Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: doctor.timeSlots.map((slot) {
                    final isSel = selectedSlot == slot;
                    return ChoiceChip(
                      label: Text(slot),
                      selected: isSel,
                      onSelected: (val) => setModalState(() => selectedSlot = slot),
                      selectedColor: AppColors.primaryUltraLight,
                      labelStyle: TextStyle(
                        color: isSel ? AppColors.primary : AppColors.textDark,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Text('Describe Health Issue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: symptomsController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Fever, persistent cough, blood pressure checkup',
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();
                      final patient = auth.currentUser;
                      final appointment = await context.read<AppointmentProvider>().bookAppointment(
                            patientId: patient?.id ?? 'user_patient_01',
                            patientName: patient?.name ?? 'Gurpreet Singh',
                            patientPhone: patient?.phone ?? '+91 98765 43210',
                            doctor: doctor,
                            date: DateTime.now().add(const Duration(days: 1)),
                            timeSlot: selectedSlot,
                            symptoms: symptomsController.text.trim().isNotEmpty
                                ? symptomsController.text.trim()
                                : 'General Consultation',
                            isOnlineVideo: true,
                          );

                      if (context.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Appointment confirmed! Token: ${appointment.tokenNumber}'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    child: const Text('Confirm Tele-Consultation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final auth = context.watch<AuthProvider>();
    final healthRecords = context.watch<HealthRecordsProvider>();
    final reminders = context.watch<ReminderProvider>();
    final appointments = context.watch<AppointmentProvider>();
    final rural = context.watch<RuralHealthProvider>();
    final hospitals = context.watch<HospitalProvider>();

    final user = auth.currentUser;
    final latestVitals = healthRecords.latestVitals;
    final upcomingApt = appointments.appointments.firstOrNull;
    final nextCamp = rural.healthCamps.firstOrNull;
    final doctorsList = hospitals.doctors;
    final hospitalList = hospitals.hospitals;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Hero Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33008F87),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            backgroundImage: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            onBackgroundImageError: (_, __) {},
                            child: user?.avatarUrl == null || user!.avatarUrl!.isEmpty
                                ? Text(
                                    user?.name.isNotEmpty == true ? user!.name[0] : 'G',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getGreeting()},',
                              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              user?.name ?? 'Gurpreet Singh',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: Colors.white70, size: 13),
                                const SizedBox(width: 4),
                                const Text(
                                  'Sahnewal, Ludhiana (Punjab)',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Blood Group Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bloodtype_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            user?.bloodGroup ?? 'O+',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Emergency SOS Quick Call Strip
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EmergencySosScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      gradient: AppColors.emergencyGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.tr('emergencyTitle'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                'National 112 • Ambulance 108 • Punjab 104',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: const Text(
                            'SOS HELP',
                            style: TextStyle(
                              color: AppColors.emergency,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Vitals Snapshot Section + "Log Vitals"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: AppColors.emergency, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      lang.tr('vitals'),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showLogVitalsDialog(context, user?.id ?? 'user_patient_01'),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primary),
                  label: const Text(
                    '+ Log Vitals',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildVitalItem(
                    label: 'Blood Pressure',
                    value: '${latestVitals?.systolicBP ?? 130}/${latestVitals?.diastolicBP ?? 84}',
                    unit: 'mmHg',
                    status: (latestVitals?.systolicBP ?? 130) > 135 ? 'Elevated' : 'Normal',
                    icon: Icons.favorite_rounded,
                    color: AppColors.emergency,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildVitalItem(
                    label: 'Fasting Glucose',
                    value: '${latestVitals?.bloodSugarFasting ?? 126}',
                    unit: 'mg/dL',
                    status: (latestVitals?.bloodSugarFasting ?? 126) > 130 ? 'Check' : 'Normal',
                    icon: Icons.water_drop_rounded,
                    color: AppColors.accentAmber,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildVitalItem(
                    label: 'Blood Oxygen',
                    value: '${latestVitals?.spO2 ?? 98}%',
                    unit: 'SpO2',
                    status: 'Optimal',
                    icon: Icons.air_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // AI Healthcare Assistant Feature Card with Voice & Audio
          MedicalCard(
            backgroundColor: AppColors.primaryUltraLight,
            borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.4), width: 1.5),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AiChatScreen()),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 5),
                          Text(
                            'CareSphere AI Assistant',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const AudioSpeakButton(
                      textToSpeak: 'Ask CareSphere AI health questions in English, Hindi, or Punjabi with real-time voice input.',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lang.tr('aiAssistantTitle'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang.tr('aiAssistantSubtitle'),
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lang.tr('aiHintText'),
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 22),
                        onPressed: () async {
                          final text = await TtsSttService.simulateVoiceInput(lang: lang.currentLanguage);
                          if (context.mounted && text.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AiChatScreen()),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick Access Services Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _buildActionTile(
                  context,
                  icon: Icons.document_scanner_rounded,
                  title: lang.tr('navPrescriptions'),
                  subtitle: 'OCR & Punjabi Translation',
                  color: AppColors.secondary,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrescriptionScannerScreen()),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.local_hospital_rounded,
                  title: lang.tr('navHospitals'),
                  subtitle: 'Punjab Civil & PHCs',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HospitalFinderScreen()),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.badge_rounded,
                  title: lang.tr('emergencyPassport'),
                  subtitle: 'Medical ID for 1st Responders',
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EmergencyPassportScreen()),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.campaign_rounded,
                  title: lang.tr('navRuralHealth'),
                  subtitle: 'Free Camps & Ayushman',
                  color: Colors.teal.shade800,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RuralHealthScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Telemedicine Doctors in Punjab with Real Images
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.video_call_rounded, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Verified Doctors in Punjab',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HospitalFinderScreen()),
                    );
                  },
                  child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 195,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: doctorsList.length,
              itemBuilder: (context, idx) {
                final doc = doctorsList[idx];
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 14, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                doc.avatarUrl,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 52,
                                  height: 52,
                                  color: AppColors.primaryUltraLight,
                                  child: const Icon(Icons.person, color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.name,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    doc.specialty,
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                      const SizedBox(width: 3),
                                      Text('${doc.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      Text(' (${doc.reviewsCount})', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              doc.fee == 0.0 ? 'Free (Govt)' : '₹${doc.fee.toInt()}',
                              style: TextStyle(
                                color: doc.fee == 0.0 ? AppColors.success : AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.calendar_today_rounded, size: 14),
                              label: const Text('Book', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              onPressed: () => _showDoctorBookingSheet(context, doc),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // Upcoming Appointment (Tele-consultation / Jitsi)
          if (upcomingApt != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Text(
                lang.tr('videoConsultTitle'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
              ),
            ),
            MedicalCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryUltraLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          upcomingApt.tokenNumber,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Confirmed',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    upcomingApt.doctorName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${upcomingApt.specialty} • ${upcomingApt.hospitalName}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 15, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        'Tomorrow at ${upcomingApt.timeSlot}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.video_camera_front_rounded, size: 20),
                      label: Text(lang.tr('joinVideoCall'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VideoConsultationScreen(appointment: upcomingApt),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Medicine Reminders Widget with real adherence
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medication_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      lang.tr('medicineRemindersTitle'),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${reminders.adherenceRatePercentage}% Adherence',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reminders.reminders.take(2).length,
            itemBuilder: (context, idx) {
              final rem = reminders.reminders[idx];
              return MedicalCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: rem.isTakenToday ? AppColors.successLight : AppColors.primaryUltraLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        rem.isTakenToday ? Icons.check_circle_rounded : Icons.medication_rounded,
                        color: rem.isTakenToday ? AppColors.success : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rem.medicineName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          Text(
                            '${rem.dosage} • ${rem.timeString}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rem.isTakenToday ? AppColors.success : AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => reminders.toggleTaken(rem.id),
                      child: Text(
                        rem.isTakenToday ? lang.tr('taken') : lang.tr('markTaken'),
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          // Nearby Punjab Hospitals Preview Carousel with Images
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_hospital_rounded, color: AppColors.secondary, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Nearby Hospitals & PHCs',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HospitalFinderScreen()),
                    );
                  },
                  child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hospitalList.take(3).length,
              itemBuilder: (context, idx) {
                final hosp = hospitalList[idx];
                return Container(
                  width: 270,
                  margin: const EdgeInsets.only(right: 14, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: Stack(
                          children: [
                            Image.network(
                              hosp.imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 100,
                                color: AppColors.primaryUltraLight,
                                child: const Center(child: Icon(Icons.local_hospital, size: 36, color: AppColors.primary)),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: hosp.availableBeds > 10 ? AppColors.success : AppColors.emergency,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${hosp.availableBeds} Beds Free',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hosp.name,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, size: 13, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${hosp.cityOrVillage} • ${hosp.distanceKm} km',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                  onPressed: () => EmergencyService.openMapDirections(
                                    latitude: hosp.latitude,
                                    longitude: hosp.longitude,
                                    destinationName: hosp.name,
                                  ),
                                  child: const Text('Directions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // Free Health Camp in Punjab Announcement Banner
          if (nextCamp != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        nextCamp.imageUrl,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDE68A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.campaign_rounded, color: Color(0xFF92400E), size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nextCamp.title,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF92400E)),
                                  ),
                                  Text(
                                    '${nextCamp.village}, ${nextCamp.district} • ${nextCamp.date}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Services: ${nextCamp.services.join(", ")}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF78350F)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVitalItem({
    required String label,
    required String value,
    required String unit,
    required String status,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          Text(
            '$unit • $label',
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
