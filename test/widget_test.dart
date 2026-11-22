import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caresphere_ai/main.dart';
import 'package:caresphere_ai/core/constants/app_strings.dart';
import 'package:caresphere_ai/core/services/ai_service.dart';
import 'package:caresphere_ai/core/services/ocr_prescription_service.dart';
import 'package:caresphere_ai/data/mock/seed_data.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AppStrings localization returns correct translations for En, Hi, Pa', () {
    expect(AppStrings.get('appName', 'en'), 'CareSphere AI');
    expect(AppStrings.get('appName', 'hi'), contains('केयरस्फ़ीयर'));
    expect(AppStrings.get('appName', 'pa'), contains('ਕੇਅਰਸਫੀਅਰ'));

    // Emergency number & role translations
    expect(AppStrings.get('rolePatient', 'en'), 'Patient');
    expect(AppStrings.get('rolePatient', 'hi'), contains('मरीज़'));
    expect(AppStrings.get('rolePatient', 'pa'), contains('ਮਰੀਜ਼'));
  });

  test('AI Service correctly flags critical emergencies', () {
    expect(AiService.detectEmergency('Patient has severe chest pain and cannot breathe'), isTrue);
    expect(AiService.detectEmergency('सांप ने काटा है बहुत खून बह रहा है'), isTrue);
    expect(AiService.detectEmergency('ਮਰੀਜ਼ ਬੇਹੋਸ਼ ਹੋ ਗਿਆ ਹੈ ਛਾਤੀ ਵਿੱਚ ਦਰਦ ਹੈ'), isTrue);

    // Non-emergency query
    expect(AiService.detectEmergency('What is the normal blood sugar level?'), isFalse);
    expect(AiService.detectEmergency('Diet tips for high BP'), isFalse);
  });

  test('Prescription OCR parser flags blurry medicines and translates', () async {
    final rx = await OcrPrescriptionService.analyzePrescriptionImage(isDemoSample: true);
    expect(rx.medicines.isNotEmpty, isTrue);

    final certainMeds = rx.medicines.where((m) => m.isCertain).toList();
    final uncertainMeds = rx.medicines.where((m) => !m.isCertain).toList();

    expect(certainMeds.isNotEmpty, isTrue);
    expect(uncertainMeds.isNotEmpty, isTrue); // Critical safety requirement met!

    // Verify translations exist
    expect(certainMeds.first.instructionsHi.isNotEmpty, isTrue);
    expect(certainMeds.first.instructionsPa.isNotEmpty, isTrue);
  });

  test('SeedData contains Punjab hospitals, doctors, and health camps', () {
    expect(SeedData.punjabHospitals.length, greaterThanOrEqualTo(5));
    expect(SeedData.punjabDoctors.length, greaterThanOrEqualTo(4));
    expect(SeedData.punjabHealthCamps.length, greaterThanOrEqualTo(4));
    expect(SeedData.punjabGovernmentSchemes.length, greaterThanOrEqualTo(3));
  });

  testWidgets('CareSphere AI app smoke and render test', (WidgetTester tester) async {
    await tester.pumpWidget(const CareSphereRootApp());
    await tester.pumpAndSettle();

    expect(find.text('CareSphere AI'), findsWidgets);
    expect(find.text("The Builder's Theory 1.0"), findsOneWidget);
  });
}
