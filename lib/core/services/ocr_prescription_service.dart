import 'package:uuid/uuid.dart';
import '../../data/models/prescription_model.dart';
import '../../data/mock/seed_data.dart';

class OcrPrescriptionService {
  static Future<PrescriptionModel> analyzePrescriptionImage({
    String? imagePath,
    bool isDemoSample = false,
  }) async {
    // Simulate real OCR extraction processing delay
    await Future.delayed(const Duration(milliseconds: 1400));

    if (isDemoSample || imagePath == null || imagePath.isEmpty) {
      return SeedData.samplePrescription;
    }

    // Dynamic parsing logic for scanned images or user uploads
    const uuid = Uuid();
    return PrescriptionModel(
      id: 'rx_${uuid.v4().substring(0, 8)}',
      patientId: 'user_patient_01',
      doctorName: 'Dr. Gurleen Singh (Civil Hospital)',
      hospitalClinicName: 'Rural Health Outpost, Punjab',
      date: DateTime.now(),
      imageUrl: imagePath,
      extractedRawOcr: '''
Civil Hospital Punjab - OPD Prescription
Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}
Rx:
1. Tab Azithromycin 500mg - 1 daily after dinner x 3 days
2. Tab Paracetamol 650mg - 1 SOS for high body temperature
3. Tab Cetirizine 10mg - 1 at bedtime (0-0-1) x 5 days
4. [Handwriting unclear: Sy. ...pex 10ml] - Caution: Please verify with pharmacist
''',
      medicines: [
        MedicineItem(
          name: 'Azithromycin',
          dosage: '500 mg',
          frequency: 'Once daily after dinner',
          duration: '3 days',
          instructionsEn: 'Take 1 tablet every evening after dinner. Complete full 3-day course.',
          instructionsHi: 'प्रतिदिन रात के भोजन के बाद 1 गोली लें। 3 दिन का पूरा कोर्स अवश्य समाप्त करें।',
          instructionsPa: 'ਹਰ ਰੋਜ਼ ਰਾਤ ਦੇ ਖਾਣੇ ਤੋਂ ਬਾਅਦ 1 ਗੋਲੀ ਲਵੋ। 3 ਦਿਨਾਂ ਦਾ ਪੂਰਾ ਕੋਰਸ ਜ਼ਰੂਰ ਮੁਕੰਮਲ ਕਰੋ।',
          isCertain: true,
          plainLanguagePurpose: 'Antibiotic medicine to cure bacterial throat or chest infections.',
          warnings: 'Do not stop early even if feeling better.',
        ),
        MedicineItem(
          name: 'Paracetamol',
          dosage: '650 mg',
          frequency: 'SOS (As needed for fever)',
          duration: '3 days',
          instructionsEn: 'Take 1 tablet only if fever exceeds 100°F or with body pain.',
          instructionsHi: 'केवल तभी लें जब बुखार 100°F से अधिक हो या शरीर में तेज दर्द हो।',
          instructionsPa: 'ਸਿਰਫ਼ ਉਦੋਂ ਲਵੋ ਜਦੋਂ ਬੁਖਾਰ 100°F ਤੋਂ ਵੱਧ ਹੋਵੇ ਜਾਂ ਸਰੀਰ ਵਿੱਚ ਦਰਦ ਹੋਵੇ।',
          isCertain: true,
          plainLanguagePurpose: 'Reduces high body temperature and relieves pain.',
          warnings: 'Maintain minimum 6-hour interval between doses.',
        ),
        MedicineItem(
          name: 'Cetirizine',
          dosage: '10 mg',
          frequency: '0-0-1 (Once at bedtime)',
          duration: '5 days',
          instructionsEn: 'Take 1 tablet at night before sleeping.',
          instructionsHi: 'रात को सोने से पहले 1 गोली लें।',
          instructionsPa: 'ਰਾਤ ਨੂੰ ਸੌਣ ਤੋਂ ਪਹਿਲਾਂ 1 ਗੋਲੀ ਲਵੋ।',
          isCertain: true,
          plainLanguagePurpose: 'Antihistamine for allergic cold, runny nose, and sneezing.',
          warnings: 'May cause drowsiness. Avoid driving or operating heavy farm machinery.',
        ),
        MedicineItem(
          name: 'Cough Syrup [Uncertain Name]',
          dosage: '10 ml',
          frequency: 'Twice daily',
          duration: '5 days',
          instructionsEn: 'Unclear handwriting on label. Do not guess dosage or syrup brand.',
          instructionsHi: 'पर्चे पर लिखावट स्पष्ट नहीं है। कृपया फ़ार्मासिस्ट से पुष्टि करवाएं।',
          instructionsPa: 'ਪਰਚੀ ਉੱਤੇ ਲਿਖਾਈ ਸਾਫ਼ ਨਹੀਂ ਹੈ। ਕਿਰਪਾ ਕਰਕੇ ਮੈਡੀਕਲ ਸਟੋਰ ਵਾਲੇ ਜਾਂ ਡਾਕਟਰ ਤੋਂ ਪੁਸ਼ਟੀ ਕਰੋ।',
          isCertain: false,
          plainLanguagePurpose: 'Potentially for cough relief, but brand cannot be safely confirmed.',
          warnings: '⚠️ DO NOT CONSUME until confirmed by a licensed pharmacist.',
        ),
      ],
      generalAdvice: 'Drink warm water, take steam inhalation twice daily, adequate rest.',
      followUpDate: 'After 3 days if symptoms persist',
    );
  }
}
