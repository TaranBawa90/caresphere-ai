import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/prescription_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/audio_speak_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../data/models/prescription_model.dart';
import '../../data/models/health_record_model.dart';

class PrescriptionScannerScreen extends StatefulWidget {
  final bool isEmbedded;

  const PrescriptionScannerScreen({super.key, this.isEmbedded = false});

  @override
  State<PrescriptionScannerScreen> createState() => _PrescriptionScannerScreenState();
}

class _PrescriptionScannerScreenState extends State<PrescriptionScannerScreen> {
  String _selectedLang = 'en';

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final rxProvider = context.watch<PrescriptionProvider>();
    final healthRecords = context.watch<HealthRecordsProvider>();

    final rx = rxProvider.currentAnalysis;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(
                lang.tr('rxScannerTitle'),
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
            // Header Description
            Text(
              lang.tr('rxScannerSubtitle'),
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Scan Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                    label: Text(
                      lang.tr('takePhoto'),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      rxProvider.scanPrescription(imagePath: 'camera_capture_temp.jpg');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.secondary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
                    label: Text(
                      lang.tr('uploadPhoto'),
                      style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      rxProvider.scanPrescription(imagePath: 'gallery_upload_temp.jpg');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Load Sample Demo Prescription Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryUltraLight,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.receipt_long_rounded, size: 18),
                label: Text(
                  lang.tr('useSampleRx'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                onPressed: () {
                  rxProvider.scanPrescription(isDemo: true);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Scanning Progress
            if (rxProvider.isScanning) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang.tr('scanningRx'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AI OCR analyzing handwritten text, dosages, and confidence levels...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Analyzed Prescription Details
            if (rx != null && !rxProvider.isScanning) ...[
              // Doctor & Hospital Header Card
              MedicalCard(
                margin: EdgeInsets.zero,
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              rx.hospitalClinicName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryUltraLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'AI Verified',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Prescribed by: ${rx.doctorName}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                    Text(
                      'Date: ${rx.date.day}/${rx.date.month}/${rx.date.year}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Translation Controls Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.tr('extractedMedicines'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  // Translation Switcher
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLangBtn('en', 'EN'),
                        _buildLangBtn('hi', 'हिन्दी'),
                        _buildLangBtn('pa', 'ਪੰਜਾਬੀ'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Medicines List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rx.medicines.length,
                itemBuilder: (context, idx) {
                  final med = rx.medicines[idx];
                  return _buildMedicineCard(med, _selectedLang);
                },
              ),

              const SizedBox(height: 14),

              // Doctor Advice & General Instructions
              MedicalCard(
                margin: EdgeInsets.zero,
                backgroundColor: AppColors.lightBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tips_and_updates_outlined, color: AppColors.secondary, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Doctor Advice & Follow-up',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      rx.generalAdvice,
                      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Next follow up: ${rx.followUpDate}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Save to Health Records Button
              CustomButton(
                text: lang.tr('saveToHealthRecords'),
                icon: Icons.bookmark_added_rounded,
                onPressed: () {
                  rxProvider.saveCurrentPrescription();
                  healthRecords.addRecord(
                    HealthRecordModel(
                      id: 'rec_rx_${DateTime.now().millisecondsSinceEpoch}',
                      patientId: rx.patientId,
                      title: 'Prescription: ${rx.doctorName}',
                      recordType: RecordType.prescription,
                      date: rx.date,
                      doctorOrLabName: rx.hospitalClinicName,
                      notes: 'Contains ${rx.medicines.length} medicines. Extracted via CareSphere AI OCR.',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prescription successfully saved to Digital Health Records!')),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLangBtn(String code, String label) {
    final isSelected = _selectedLang == code;
    return InkWell(
      onTap: () => setState(() => _selectedLang = code),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(MedicineItem med, String langCode) {
    String instruction;
    switch (langCode) {
      case 'hi':
        instruction = med.instructionsHi.isNotEmpty ? med.instructionsHi : med.instructionsEn;
        break;
      case 'pa':
        instruction = med.instructionsPa.isNotEmpty ? med.instructionsPa : med.instructionsEn;
        break;
      default:
        instruction = med.instructionsEn;
    }

    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 12),
      backgroundColor: Colors.white,
      borderSide: med.isCertain
          ? const BorderSide(color: AppColors.border)
          : const BorderSide(color: AppColors.warning, width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  med.name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
              AudioSpeakButton(
                textToSpeak: '${med.name}. ${med.dosage}. $instruction',
                language: langCode,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Dosage and Frequency badges
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  med.dosage,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  med.frequency,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  med.duration,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Translated Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.translate_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      langCode == 'pa'
                          ? 'ਖੁਰਾਕ ਲੈਣ ਦਾ ਤਰੀਕਾ (ਪੰਜਾਬੀ)'
                          : langCode == 'hi'
                              ? 'दवा लेने का तरीका (हिंदी)'
                              : 'How to Take (Instructions)',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  instruction,
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Plain Language Explanation
          Text(
            'Purpose: ${med.plainLanguagePurpose}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
          ),

          // Uncertainty Warning
          if (!med.isCertain) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '⚠️ Unclear doctor handwriting. Never guess medicine names. Please confirm with your local pharmacist or doctor.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
