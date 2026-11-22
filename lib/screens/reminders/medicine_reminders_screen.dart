import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/reminder_model.dart';

class MedicineRemindersScreen extends StatefulWidget {
  const MedicineRemindersScreen({super.key});

  @override
  State<MedicineRemindersScreen> createState() => _MedicineRemindersScreenState();
}

class _MedicineRemindersScreenState extends State<MedicineRemindersScreen> {
  void _showAddReminderDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController(text: '1 Tablet');
    final timeController = TextEditingController(text: '08:30 AM');
    final instructionController = TextEditingController(text: 'Take after breakfast');

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
                'Add Medicine Reminder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Medicine Name (e.g. Metformin 500mg)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(labelText: 'Dosage (e.g. 1 Tablet)'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      decoration: const InputDecoration(labelText: 'Reminder Time'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instructionController,
                decoration: const InputDecoration(labelText: 'Instructions (e.g. With warm water)'),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Schedule Reminder',
                icon: Icons.alarm_add_rounded,
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    context.read<ReminderProvider>().addReminder(
                          name: nameController.text.trim(),
                          dosage: dosageController.text.trim(),
                          timeString: timeController.text.trim(),
                          instructions: instructionController.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Medicine reminder scheduled!')),
                    );
                  }
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
    final remProvider = context.watch<ReminderProvider>();
    final reminders = remProvider.reminders;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          lang.tr('medicineRemindersTitle'),
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
            // Adherence Tracker Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: remProvider.adherenceRatePercentage / 100,
                          strokeWidth: 6,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${remProvider.adherenceRatePercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.tr('adherenceStreak'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Keep up your daily medicine schedule to maintain steady health and blood sugar levels.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Header & Add Reminder button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Schedule",
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
                  label: Text(lang.tr('addReminder'), style: const TextStyle(fontSize: 12)),
                  onPressed: _showAddReminderDialog,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Reminders List
            if (reminders.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No active medicine reminders.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                itemBuilder: (context, idx) {
                  final rem = reminders[idx];
                  return _buildReminderCard(rem, remProvider, lang);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(ReminderModel rem, ReminderProvider provider, LanguageProvider lang) {
    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: rem.isTakenToday ? AppColors.successLight : AppColors.primaryUltraLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              rem.isTakenToday ? Icons.check_circle_rounded : Icons.medication_rounded,
              color: rem.isTakenToday ? AppColors.success : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rem.medicineName,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Text(
                  '${rem.dosage} • Time: ${rem.timeString}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                if (rem.instructions.isNotEmpty)
                  Text(
                    rem.instructions,
                    style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: rem.isTakenToday ? AppColors.success : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => provider.toggleTaken(rem.id),
            child: Text(
              rem.isTakenToday ? lang.tr('taken') : lang.tr('markTaken'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
