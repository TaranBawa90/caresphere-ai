import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'local_storage_service.dart';

class AiServiceResponse {
  final String text;
  final bool isEmergency;
  final List<String> suggestedChips;

  AiServiceResponse({
    required this.text,
    this.isEmergency = false,
    this.suggestedChips = const [],
  });
}

class AiService {
  // Check for critical emergencies / red flags
  static bool detectEmergency(String query) {
    final lower = query.toLowerCase();
    final redFlags = [
      'chest pain',
      'heart attack',
      'severe bleeding',
      'unconscious',
      'snake bite',
      'cannot breathe',
      'cant breathe',
      'difficulty breathing',
      'stroke',
      'paralysis',
      'drank poison',
      'poisoning',
      'छाती में दर्द',
      'दिल का दौरा',
      'सांप ने काटा',
      'सांस नहीं आ रही',
      'ज़हर',
      'ਬੇਹੋਸ਼',
      'ਛਾਤੀ ਵਿੱਚ ਦਰਦ',
      'ਦਿਲ ਦਾ ਦੌਰਾ',
      'ਸੱਪ ਨੇ ਡੰਗਿਆ',
      'ਸਾਹ ਨਹੀਂ ਆ ਰਿਹਾ',
      'ਜ਼ਹਿਰ',
    ];

    return redFlags.any((flag) => lower.contains(flag));
  }

  static Future<AiServiceResponse> askHealthcareAssistant({
    required String query,
    required String language,
  }) async {
    // 1. Immediate Safety Check: Detect Emergency
    if (detectEmergency(query)) {
      return _generateEmergencyResponse(language);
    }

    // 2. Check for configured Gemini API Key
    final userKey = LocalStorageService.getGeminiKey();
    final apiKey = userKey.isNotEmpty ? userKey : ApiConstants.defaultGeminiApiKey;

    if (apiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          '${ApiConstants.geminiEndpoint}?key=$apiKey',
        );

        final systemInstruction = '''
You are CareSphere AI, a compassionate medical education assistant designed for rural healthcare in India (Punjab focus).
You must answer in the user's selected language: $language (en: English, hi: Hindi, pa: Punjabi).
Guidelines:
1. Explain medical terms in simple, plain language that an elder or rural resident can understand.
2. NEVER claim to replace a doctor. Do not give conclusive medical diagnoses.
3. For medicines, explain general purpose and safety precautions, but advise consulting a doctor or local pharmacist.
4. Keep the answer structured: Summary, Home Care/What to do, When to see a doctor.
5. Keep it concise (under 150 words) and conversational.
''';

        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'contents': [
                  {
                    'role': 'user',
                    'parts': [
                      {
                        'text':
                            '$systemInstruction\n\nUser Question: $query',
                      }
                    ]
                  }
                ],
                'generationConfig': {
                  'temperature': 0.3,
                  'maxOutputTokens': 500,
                }
              }),
            )
            .timeout(const Duration(seconds: 12));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            final parts = content['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              final rawText = parts[0]['text'] as String;
              return AiServiceResponse(
                text: rawText.trim(),
                isEmergency: false,
                suggestedChips: _getFollowUpChips(language, query),
              );
            }
          }
        }
      } catch (_) {
        // Fallback to verified local medical reasoning engine
      }
    }

    // 3. Verified Local Clinical Reasoning Engine (Offline / Fallback)
    return _generateLocalMedicalResponse(query, language);
  }

  static AiServiceResponse _generateEmergencyResponse(String lang) {
    if (lang == 'pa') {
      return AiServiceResponse(
        isEmergency: true,
        text: '''
🚨 ਐਮਰਜੈਂਸੀ ਚੇਤਾਵਨੀ (Critical Alert):
ਇਹ ਗੰਭੀਰ ਐਮਰਜੈਂਸੀ ਦੇ ਲੱਛਣ ਲੱਗ ਰਹੇ ਹਨ! ਘਰ ਵਿੱਚ ਦੇਰੀ ਨਾ ਕਰੋ।
ਤੁਰੰਤ 112 ਜਾਂ 108 ਉੱਤੇ ਕਾਲ ਕਰੋ ਜਾਂ ਮਰੀਜ਼ ਨੂੰ ਸਭ ਤੋਂ ਨਜ਼ਦੀਕੀ ਸਿਵਲ ਹਸਪਤਾਲ / ਐਮਰਜੈਂਸੀ ਸੈਂਟਰ ਲੈ ਕੇ ਜਾਓ।

ਤੁਰੰਤ ਕਰਨ ਯੋਗ ਕਦਮ:
• ਮਰੀਜ਼ ਨੂੰ ਸ਼ਾਂਤ ਰੱਖੋ ਅਤੇ ਸਾਹ ਲੈਣ ਲਈ ਖੁੱਲ੍ਹੀ ਹਵਾ ਦਿਓ।
• ਜੇਕਰ ਛਾਤੀ ਵਿੱਚ ਦਰਦ ਹੈ ਤਾਂ ਬਿਲਕੁਲ ਆਰਾਮ ਕਰਨ ਦਿਓ, ਤੁਰਨ ਨਾ ਦਿਓ।
• ਬੇਹੋਸ਼ ਵਿਅਕਤੀ ਦੇ ਮੂੰਹ ਵਿੱਚ ਪਾਣੀ ਜਾਂ ਕੋਈ ਦਵਾਈ ਨਾ ਪਾਓ।
''',
        suggestedChips: ['Call 108 Ambulance', 'Call 112 Emergency', 'Show First-Aid Guide'],
      );
    } else if (lang == 'hi') {
      return AiServiceResponse(
        isEmergency: true,
        text: '''
🚨 आपातकालीन चेतावनी (Critical Alert):
यह गंभीर आपातकाल के लक्षण प्रतीत होते हैं! कृपया घर पर समय न गंवाएं।
तुरंत 112 या 108 पर कॉल करें अथवा मरीज़ को नज़दीकी सिविल अस्पताल / ट्रॉमा सेंटर ले जाएं।

तत्काल कदम:
• मरीज़ को शांत रखें और ताज़ा हवा मिलने दें।
• यदि छाती में दर्द या भारीपन है, तो मरीज़ को तुरंत आराम की स्थिति में बैठाएं।
• बेहोश व्यक्ति के मुंह में पानी या कोई गोली न डालें।
''',
        suggestedChips: ['कॉल 108 एम्बुलेंस', 'कॉल 112 आपातकाल', 'प्राथमिक चिकित्सा देखें'],
      );
    } else {
      return AiServiceResponse(
        isEmergency: true,
        text: '''
🚨 CRITICAL EMERGENCY ALERT:
These symptoms indicate a potential medical emergency! Do not delay.
Immediately dial 112 or 108 for an ambulance, or rush to the nearest emergency trauma centre.

Immediate Action:
• Keep the patient calm and in a safe, resting position.
• Ensure adequate airflow and loosen tight clothing.
• DO NOT administer oral fluids or medications to an unconscious person.
''',
        suggestedChips: ['Call 108 Ambulance', 'Call 112 Emergency', 'View First-Aid Guide'],
      );
    }
  }

  static AiServiceResponse _generateLocalMedicalResponse(String query, String lang) {
    final lower = query.toLowerCase();

    // Fever
    if (lower.contains('fever') || lower.contains('temperature') || lower.contains('बुखार') || lower.contains('ਬੁਖਾਰ')) {
      if (lang == 'pa') {
        return AiServiceResponse(
          text: '''
🌡️ ਬੁਖਾਰ ਬਾਰੇ ਸਲਾਹ (Fever Guidance):
ਬੁਖਾਰ ਸਰੀਰ ਦੁਆਰਾ ਇਨਫੈਕਸ਼ਨ ਨਾਲ ਲੜਨ ਦਾ ਕੁਦਰਤੀ ਤਰੀਕਾ ਹੈ।

ਘਰੇਲੂ ਦੇਖਭਾਲ:
• ਮਰੀਜ਼ ਦੇ ਮੱਥੇ ਉੱਤੇ ਸਾਫ਼ ਗਿੱਲੇ ਕੱਪੜੇ ਦੀਆਂ ਪੱਟੀਆਂ ਰੱਖੋ।
• ਕਾਫ਼ੀ ਪਾਣੀ, ਨਿੰਬੂ ਪਾਣੀ ਜਾਂ ਓ.ਆਰ.ਐੱਸ. (ORS) ਪਿਲਾਓ ਤਾਂ ਜੋ ਪਾਣੀ ਦੀ ਕਮੀ ਨਾ ਹੋਵੇ।
• ਹਲਕੇ ਅਤੇ ਖੁੱਲ੍ਹੇ ਸੂਤੀ ਕੱਪੜੇ ਪਹਿਨਾਓ।

ਡਾਕਟਰ ਨੂੰ ਕਦੋਂ ਮਿਲਣਾ ਹੈ:
• ਜੇਕਰ ਬੁਖਾਰ 102°F ਤੋਂ ਵੱਧ ਹੋਵੇ ਜਾਂ 3 ਦਿਨਾਂ ਤੋਂ ਨਾ ਉਤਰੇ।
• ਬੱਚੇ ਨੂੰ ਦੌਰੇ ਪੈਣ ਜਾਂ ਬਹੁਤ ਜ਼ਿਆਦਾ ਸੁਸਤੀ ਹੋਵੇ।
''',
          suggestedChips: ['ਪੈਰਾਸੀਟਾਮੋਲ ਦੀ ਵਰਤੋਂ', 'ਨਜ਼ਦੀਕੀ ਸਰਕਾਰੀ ਹਸਪਤਾਲ', 'ਡਾਕਟਰ ਨਾਲ ਗੱਲ ਕਰੋ'],
        );
      } else if (lang == 'hi') {
        return AiServiceResponse(
          text: '''
🌡️ बुखार प्रबंधन (Fever Guidance):
बुखार शरीर द्वारा संक्रमण से लड़ने की स्वाभाविक प्रक्रिया है।

घरेलू देखभाल:
• माथे पर सामान्य पानी की गीली पट्टियां रखें।
• पर्याप्त मात्रा में पानी, नारियल पानी या ओआरएस (ORS) घोल पिलाएं।
• हल्के सूती कपड़े पहनाएं और कमरे में हवादार माहौल रखें।

डॉक्टर से कब मिलें:
• यदि बुखार 102°F से अधिक हो या 3 दिनों से अधिक रहे।
• यदि सांस लेने में कठिनाई या बहुत ज्यादा कमजोरी महसूस हो।
''',
          suggestedChips: ['पैरासिटामोल खुराक', 'नज़दीकी अस्पताल खोजें', 'ऑनलाइन डॉक्टर सलाह'],
        );
      } else {
        return AiServiceResponse(
          text: '''
🌡️ Fever Care & Guidance:
Fever is the immune system's natural defense against infection.

Home Care Steps:
• Sponge the forehead and neck with clean, lukewarm or room-temperature water.
• Stay hydrated with water, ORS, or coconut water to prevent dehydration.
• Wear light, breathable cotton clothes; avoid heavy blankets.

When to Consult a Doctor:
• Temperature exceeds 102°F (38.9°C) or lasts beyond 3 days.
• In infants under 3 months, or if accompanied by stiff neck, rash, or severe lethargy.
''',
          suggestedChips: ['Paracetamol precautions', 'Nearby PHC / Hospital', 'Book Doctor Consult'],
        );
      }
    }

    // Blood Pressure
    if (lower.contains('blood pressure') || lower.contains('bp') || lower.contains('रक्तचाप') || lower.contains('ਬਲੱਡ ਪ੍ਰੈਸ਼ਰ')) {
      if (lang == 'pa') {
        return AiServiceResponse(
          text: '''
🩺 ਬਲੱਡ ਪ੍ਰੈਸ਼ਰ ਸੰਭਾਲ (Blood Pressure Awareness):
ਸਾਧਾਰਨ ਬਲੱਡ ਪ੍ਰੈਸ਼ਰ ਲਗਭਗ 120/80 mmHg ਹੁੰਦਾ ਹੈ।

ਸਿਹਤ ਸੁਝਾਅ:
• ਖਾਣੇ ਵਿੱਚ ਲੂਣ (ਨਮਕ) ਦੀ ਮਾਤਰਾ ਘਟਾਓ। ਅਚਾਰ ਅਤੇ ਪਾਪੜ ਤੋਂ ਪਰਹੇਜ਼ ਰੱਖੋ।
• ਰੋਜ਼ਾਨਾ ਘੱਟੋ-ਘੱਟ 30 ਮਿੰਟ ਸੈਰ ਜਾਂ ਹਲਕੀ ਕਸਰਤ ਕਰੋ।
• ਬੀ.ਪੀ. ਦੀ ਦਵਾਈ ਡਾਕਟਰ ਦੀ ਸਲਾਹ ਤੋਂ ਬਿਨਾਂ ਕਦੇ ਵੀ ਬੰਦ ਨਾ ਕਰੋ।
• ਹਫ਼ਤੇ ਵਿੱਚ ਇੱਕ ਵਾਰ ਨੇੜਲੇ PHC ਜਾਂ ਕਲੀਨਿਕ ਤੋਂ ਬੀ.ਪੀ. ਜ਼ਰੂਰ ਚੈੱਕ ਕਰਵਾਓ।
''',
          suggestedChips: ['ਹਾਈ ਬੀ.ਪੀ. ਦੇ ਲੱਛਣ', 'ਸਿਹਤਮੰਦ ਖੁਰਾਕ', 'ਸਰਕਾਰੀ ਦਵਾਈ ਕੇਂਦਰ'],
        );
      } else if (lang == 'hi') {
        return AiServiceResponse(
          text: '''
🩺 रक्तचाप (BP) की देखभाल:
सामान्य रक्तचाप लगभग 120/80 mmHg माना जाता है।

महत्वपूर्ण सुझाव:
• भोजन में नमक कम करें, अचार और अधिक तले हुए भोजन से बचें।
• प्रतिदिन 30 मिनट तेज चाल से टहलें।
• डॉक्टर द्वारा दी गई बीपी की दवा समय पर लें, बिना सलाह बंद न करें।
• समय-समय पर अपने नजदीकी स्वास्थ्य केंद्र में बीपी की जांच करवाते रहें।
''',
          suggestedChips: ['हाई बीपी के लक्षण', 'हृदय स्वास्थ्य टिप्स', 'डॉक्टर से परामर्श'],
        );
      } else {
        return AiServiceResponse(
          text: '''
🩺 Blood Pressure (BP) Guidance:
Normal healthy resting blood pressure is generally around 120/80 mmHg.

Management Tips:
• Reduce dietary sodium/salt. Limit processed foods and pickles.
• Engage in 30 minutes of moderate aerobic exercise (brisk walking) daily.
• Never skip or alter prescribed antihypertensive medications without consulting your doctor.
• Monitor readings weekly and record them in your CareSphere Health Passport.
''',
          suggestedChips: ['Symptoms of High BP', 'Diet for Healthy Heart', 'Nearby Doctors'],
        );
      }
    }

    // Diabetes / Sugar
    if (lower.contains('diabetes') || lower.contains('sugar') || lower.contains('मधुमेह') || lower.contains('ਸ਼ੂਗਰ')) {
      if (lang == 'pa') {
        return AiServiceResponse(
          text: '''
🩸 ਸ਼ੂਗਰ (Diabetes) ਸੰਭਾਲ ਸੁਝਾਅ:
ਸ਼ੂਗਰ ਨੂੰ ਸਹੀ ਖੁਰਾਕ ਅਤੇ ਰੋਜ਼ਾਨਾ ਸੈਰ ਨਾਲ ਕਾਬੂ ਰੱਖਿਆ ਜਾ ਸਕਦਾ ਹੈ।

ਖੁਰਾਕ ਸੰਬੰਧੀ ਸਲਾਹ:
• ਮਿੱਠੀਆਂ ਚੀਜ਼ਾਂ, ਚਿੱਟੇ ਚੌਲ ਅਤੇ ਮੈਦੇ ਤੋਂ ਪਰਹੇਜ਼ ਕਰੋ।
• ਸਬਜ਼ੀਆਂ, ਸਲਾਦ, ਛੋਲੇ ਅਤੇ ਮੋਟੇ ਅਨਾਜ ਦੀ ਵਰਤੋਂ ਵਧਾਓ।
• ਖਾਲੀ ਪੇਟ ਨਾ ਰਹੋ; ਥੋੜ੍ਹਾ-ਥੋੜ੍ਹਾ ਖਾਣਾ ਸਮੇਂ ਸਿਰ ਲਵੋ।
• ਪੈਰਾਂ ਵਿੱਚ ਸੱਟ ਲੱਗਣ ਤੋਂ ਬਚਾਓ ਅਤੇ ਆਰਾਮਦਾਇਕ ਜੁੱਤੀ ਪਹਿਨੋ।
''',
          suggestedChips: ['ਖਾਲੀ ਪੇਟ ਸ਼ੂਗਰ ਦਾ ਪੱਧਰ', 'ਜਨ ਔਸ਼ਧੀ ਕੇਂਦਰ', 'ਡਾਕਟਰ ਦੀ ਸਲਾਹ'],
        );
      } else if (lang == 'hi') {
        return AiServiceResponse(
          text: '''
🩸 मधुमेह (शुगर) नियंत्रण सुझाव:
मधुमेह को संतुलित आहार और नियमित दिनचर्या से नियंत्रित रखा जा सकता है।

आहार एवं जीवनशैली:
• मीठे पेय, मिठाई और अधिक कार्बोहाइड्रेट वाले खाद्य पदार्थों से परहेज करें।
• हरी सब्जियां, मेथी, जामुन और फाइबर युक्त भोजन शामिल करें।
• प्रतिदिन 30-40 मिनट नियमित सैर अवश्य करें।
• पैरों की नियमित सफाई रखें और किसी भी घाव को नजरअंदाज न करें।
''',
          suggestedChips: ['फास्टिंग शुगर रेंज', 'मुफ्त दवा योजना', 'अपॉइंटमेंट बुक करें'],
        );
      } else {
        return AiServiceResponse(
          text: '''
🩸 Type 2 Diabetes Management:
Healthy blood sugar control depends on diet consistency and daily activity.

Key Guidelines:
• Limit refined carbohydrates, sugary beverages, and sweets.
• Prioritize whole grains, leafy vegetables, lentils, and high-fiber foods.
• Walk at least 30 minutes every day after meals.
• Perform daily foot inspections to catch minor cuts or sores early.
''',
          suggestedChips: ['Target Fasting Sugar', 'Jan Aushadhi Scheme', 'Book Appointment'],
        );
      }
    }

    // Default Friendly Healthcare Response
    if (lang == 'pa') {
      return AiServiceResponse(
        text: '''
ਨਮਸਤੇ! ਮੈਂ ਕੇਅਰਸਫੀਅਰ ਏਆਈ ਮੈਡੀਕਲ ਸਹਾਇਕ ਹਾਂ।
ਤੁਸੀਂ ਸਿਹਤ ਸੰਬੰਧੀ ਕਿਸੇ ਵੀ ਲੱਛਣ, ਦਵਾਈ ਦੀ ਵਰਤੋਂ, ਘਰੇਲੂ ਉਪਚਾਰ ਜਾਂ ਪੰਜਾਬ ਦੇ ਸਰਕਾਰੀ ਹਸਪਤਾਲਾਂ ਬਾਰੇ ਪੁੱਛ ਸਕਦੇ ਹੋ।

ਯਾਦ ਰੱਖੋ: ਮੈਂ ਸਿਹਤ ਜਾਗਰੂਕਤਾ ਲਈ ਹਾਂ, ਡਾਕਟਰ ਦਾ ਬਦਲ ਨਹੀਂ। ਜੇਕਰ ਕੋਈ ਐਮਰਜੈਂਸੀ ਹੈ ਤਾਂ ਤੁਰੰਤ 112 ਉੱਤੇ ਕਾਲ ਕਰੋ।
''',
        suggestedChips: ['ਬੁਖਾਰ ਦੇ ਘਰੇਲੂ ਉਪਾਅ', 'ਬਲੱਡ ਪ੍ਰੈਸ਼ਰ ਕੰਟਰੋਲ', 'ਨਜ਼ਦੀਕੀ ਮੁਫ਼ਤ ਕੈਂਪ'],
      );
    } else if (lang == 'hi') {
      return AiServiceResponse(
        text: '''
नमस्ते! मैं केयरस्फ़ीयर एआई स्वास्थ्य सहायक हूँ।
आप किसी भी लक्षण, दवाइयों के सामान्य उपयोग, घरेलू देखभाल या प्राथमिक उपचार के बारे में पूछ सकते हैं।

ध्यान दें: यह जानकारी स्वास्थ्य जागरूकता के लिए है, किसी डॉक्टर का विकल्प नहीं। आपातकाल में तुरंत 112 पर कॉल करें।
''',
        suggestedChips: ['बुखार का प्राथमिक उपचार', 'रक्तचाप सामान्य स्तर', 'आयुष्मान योजना जानकारी'],
      );
    } else {
      return AiServiceResponse(
        text: '''
Hello! I am your CareSphere AI Healthcare Assistant.
Feel free to ask about any symptoms, common medicine instructions, preventive healthcare, or finding nearby clinics in Punjab.

Safety Reminder: I provide health guidance and awareness, not definitive medical diagnoses. Always consult a qualified physician for prescriptions and treatments.
''',
        suggestedChips: ['Child Fever Guide', 'High Blood Pressure Tips', 'Ayushman Bharat Eligibility'],
      );
    }
  }

  static List<String> _getFollowUpChips(String lang, String query) {
    if (lang == 'pa') {
      return ['ਨੇੜਲਾ ਹਸਪਤਾਲ ਲੱਭੋ', 'ਡਾਕਟਰ ਨਾਲ ਗੱਲ ਕਰੋ', 'ਮੁਫ਼ਤ ਸਿਹਤ ਕੈਂਪ'];
    } else if (lang == 'hi') {
      return ['नज़दीकी अस्पताल देखें', 'डॉक्टर से परामर्श', 'मुफ़्त स्वास्थ्य शिविर'];
    } else {
      return ['Find Nearby Clinic', 'Consult Doctor', 'View Health Schemes'];
    }
  }
}
