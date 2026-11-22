import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/health_record_model.dart';
import 'emergency_passport_screen.dart';

class HealthRecordsScreen extends StatefulWidget {
  final bool isEmbedded;

  const HealthRecordsScreen({super.key, this.isEmbedded = false});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  void _showAddVitalsDialog() {
    final systolicController = TextEditingController(text: '128');
    final diastolicController = TextEditingController(text: '82');
    final sugarController = TextEditingController(text: '120');
    final spo2Controller = TextEditingController(text: '98');
    final heartRateController = TextEditingController(text: '72');
    final weightController = TextEditingController(text: '72');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
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
              const Text(
                'Log Health Vitals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: systolicController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Systolic BP (mmHg)'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: diastolicController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Diastolic BP (mmHg)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sugarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fasting Sugar (mg/dL)'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: spo2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Blood Oxygen SpO2 (%)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: heartRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Heart Rate (bpm)'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Save Vitals',
                icon: Icons.check_rounded,
                onPressed: () {
                  final auth = context.read<AuthProvider>();
                  context.read<HealthRecordsProvider>().recordQuickVitals(
                        patientId: auth.currentUser?.id ?? 'user_patient_01',
                        systolic: int.tryParse(systolicController.text) ?? 120,
                        diastolic: int.tryParse(diastolicController.text) ?? 80,
                        bloodSugar: int.tryParse(sugarController.text) ?? 110,
                        heartRate: int.tryParse(heartRateController.text) ?? 72,
                        spO2: int.tryParse(spo2Controller.text) ?? 98,
                        weight: double.tryParse(weightController.text) ?? 70.0,
                      );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vitals saved to local offline records!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final healthRecords = context.watch<HealthRecordsProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final records = healthRecords.records;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(
                lang.tr('healthRecordsTitle'),
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
            // Emergency Health Passport Banner
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EmergencyPassportScreen()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFC62828)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emergency.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.badge_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.tr('emergencyPassport'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Blood Group • Allergies • Emergency Contacts for First Responders (Works 100% Offline)',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Known Allergies & Chronic Conditions
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.amber),
                            const SizedBox(width: 6),
                            Text(
                              lang.tr('allergies'),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user?.allergies?.join(', ') ?? 'Penicillin, Sulfa',
                          style: const TextStyle(fontSize: 12, color: AppColors.emergency, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.healing_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              lang.tr('chronicConditions'),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user?.chronicConditions ?? 'Type 2 Diabetes, Mild BP',
                          style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Records List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Health Logs & Documents',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Log Vitals', style: TextStyle(fontSize: 12)),
                  onPressed: _showAddVitalsDialog,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Records List
            if (records.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No health records found.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, idx) {
                  final rec = records[idx];
                  return _buildRecordCard(rec, healthRecords);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(HealthRecordModel rec, HealthRecordsProvider provider) {
    IconData icon;
    Color iconColor;

    switch (rec.recordType) {
      case RecordType.vitals:
        icon = Icons.monitor_heart_rounded;
        iconColor = AppColors.emergency;
        break;
      case RecordType.prescription:
        icon = Icons.receipt_long_rounded;
        iconColor = AppColors.primary;
        break;
      case RecordType.labReport:
        icon = Icons.science_rounded;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.medical_information_rounded;
        iconColor = Colors.blue;
    }

    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rec.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(
                      '${rec.date.day}/${rec.date.month}/${rec.date.year} • ${rec.doctorOrLabName ?? "Self recorded"}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                onPressed: () => provider.deleteRecord(rec.id),
              ),
            ],
          ),

          if (rec.recordType == RecordType.vitals) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                spacing: 14,
                runSpacing: 8,
                children: [
                  if (rec.systolicBP != null)
                    _buildVitalParam('BP', '${rec.systolicBP}/${rec.diastolicBP} mmHg'),
                  if (rec.bloodSugarFasting != null)
                    _buildVitalParam('Sugar', '${rec.bloodSugarFasting} mg/dL'),
                  if (rec.spO2 != null)
                    _buildVitalParam('SpO2', '${rec.spO2}%'),
                  if (rec.heartRate != null)
                    _buildVitalParam('Heart Rate', '${rec.heartRate} bpm'),
                ],
              ),
            ),
          ],

          if (rec.notes != null && rec.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              rec.notes!,
              style: const TextStyle(fontSize: 12, color: AppColors.textDark),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVitalParam(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      ],
    );
  }
}
