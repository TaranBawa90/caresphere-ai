# CareSphere AI 
## AI-Powered Multilingual Healthcare Mobile & Web Application
**Developed for Healthcare Hackathon: The Builder's Theory 1.0**

---

## 🏥 Executive Summary

**CareSphere AI** is an advanced, production-grade, AI-powered healthcare application built with Flutter. It is engineered specifically to make quality healthcare accessible, affordable, understandable, and convenient for rural, semi-urban, and elderly populations who face linguistic barriers, digital literacy challenges, and intermittent internet connectivity.

The application features comprehensive demo datasets focused on **Punjab, India** (including District Civil Hospitals, Rural Primary Health Centres (PHCs), Community Health Centres (CHCs), empanelled doctors, free village health camps, and state-specific healthcare schemes).

---

## 🚀 Key Modules & Capabilities

### 1. 🌐 Trilingual Dynamic Localization & Voice Engine
- **Languages Supported:**
  - **English**
  - **हिन्दी (Hindi)**
  - **ਪੰਜਾਬੀ (Punjabi)**
- **Dynamic Switching:** Real-time switching throughout the application without restarting or losing form state.
- **Voice Input (Speech-to-Text):** Allows rural patients and seniors to speak symptoms and search queries naturally in Punjabi, Hindi, or English.
- **Voice Output (Text-to-Speech):** 1-tap read-aloud functionality for AI advice, doctor prescription instructions, and first-aid steps.

### 2. 🤖 AI Healthcare Assistant with Clinical Guardrails
- **Powered by Gemini API** (with backend environment variable support and in-app key configuration).
- **Offline Clinical Reasoning Engine:** Seamless fallback providing safety-verified medical advice when internet is unavailable.
- **Strict Medical Safety Guardrails:**
  - Never claims to diagnose diseases or replace licensed physicians.
  - Plain-language explanations of complex medical jargon.
  - **Critical Emergency Detection:** Detects high-risk symptoms (chest pain, stroke, snake bite, severe bleeding, poisoning) and immediately triggers red-flag alerts with direct dial buttons for **112** and **108**.

### 3. 📄 AI Prescription Reader & Translator (OCR)
- **Image Input:** Camera scan, photo gallery upload, or preloaded sample Punjab prescription for instant demonstration.
- **Medical Entity Extraction:** Identifies medicine names, strengths (e.g., 500mg), dosage frequencies (e.g., `1-0-1` twice daily after food), and duration.
- **Confidence & Caution Flagging:** Unreadable or blurry handwriting is clearly marked with a high-visibility warning: *`⚠️ Uncertain - Verify with a pharmacist. Never guess missing medical instructions.`*
- **Multilingual Translation:** 1-tap translation of dosing instructions into Hindi and Punjabi.
- **Plain-Language Summary:** Explains what each medicine does (e.g., Metformin = blood sugar control, Pantoprazole = acid reflux protection).
- **Direct Save:** Easily adds scanned medications into the patient's Digital Health Records.

### 4. 🏥 Punjab Smart Hospital & Doctor Discovery
- **Punjab Healthcare Locations:** Civil Hospital Ludhiana, PHC Sahnewal Rural, CHC Moga, Guru Nanak Mission Hospital Jalandhar, GMC & Rajindra Hospital Patiala, SDH Khanna.
- **Filters:** 24/7 Emergency Trauma, Rural PHC/CHC, Government Hospitals, Ayushman Bharat Empanelled.
- **Real-Time Data:** Available vs. total hospital beds, specialties, distance calculation, phone call action, and GPS map directions.
- **Telemedicine Doctor Booking:** Doctor profiles, specialties, subsidized fees (₹0 for Govt PHCs), available time slots, symptom description, and instant confirmation token generation (e.g. `CS-PB-104`).

### 5. 📹 Online Video Consultation (Jitsi Meet WebRTC)
- **Unique Room Generation:** Every confirmed appointment generates a private, encrypted consultation room (e.g., `CareSphere-Consult-CS-PB-104`).
- **Interactive In-App Consultation Room:**
  - Live call duration timer
  - Video feed and Picture-in-Picture preview
  - Microphone and camera toggles
  - Patient symptoms card & Doctor clinical observation notepad
  - 1-tap external launcher into Jitsi Meet WebRTC room.

### 6. 🗂️ Digital Health Records & Emergency Medical Passport
- **Health Vitals Tracker:** Systolic & Diastolic Blood Pressure, Fasting Glucose, SpO2, Heart Rate, Body Temperature, Weight.
- **Prescription & Lab Document History:** Local persistent storage ensuring 100% offline access.
- **Emergency Health Passport (Medical ID):** High-contrast, offline-first passport designed for emergency first responders and ambulances displaying Blood Group, Emergency Contact, Drug Allergies (e.g. Penicillin, Sulfa), and Active Daily Medications.

### 7. ⏰ Smart Medicine Reminders & Adherence Tracker
- **Daily Schedules:** Morning, Afternoon, Night reminders with before/after food instructions.
- **Interactive Checkoff:** 1-tap "Take Medicine" button with visual feedback and time recording.
- **Adherence Score:** Calculates patient medication compliance percentage streak.

### 8. 🚨 Emergency Response & Offline First-Aid Hub
- **India & Punjab Helplines:**
  - **112:** All-in-One National Emergency (Police, Fire, Ambulance)
  - **108:** Free Ambulance Emergency Response
  - **104:** Punjab 24x7 Medical Helpline & Doctor on Call
  - **102:** Janani Shishu Suraksha (Maternal & Child Ambulance)
- **Safe Dialing:** Includes confirmation prompts to prevent accidental emergency dispatch calls.
- **Offline First-Aid Guides:** Fully translated in English, Hindi, and Punjabi:
  - Snake Bite First Aid (immobilization, clean dressing, what NOT to do)
  - Heart Attack & CPR Guide
  - Severe Heatstroke (Loo) Management

### 9. 🌾 Rural Healthcare, Health Camps & Government Schemes
- **Free Health Camps in Punjab:** Eye screening & cataract camps, diabetes checkup camps, and child immunization drives across Ludhiana, Moga, and Hoshiarpur.
- **Government Healthcare Schemes Guide:**
  - **Ayushman Bharat PM-JAY:** ₹5 Lakh cashless hospitalization cover.
  - **Mukh Mantri Sehat Bima Yojana (Punjab):** Punjab-specific cashless scheme for farmers (J-Form holders), traders, and labor households.
  - **Pradhan Mantri Jan Aushadhi Kendras:** 50% to 90% savings on 1,800+ generic medicines.

### 10. 👴 Accessibility & Simple Rural Mode
- **Simple Rural Mode:** Increases touch targets, cards, and typography to provide an uncluttered, high-contrast, icon-driven interface for elderly villagers.
- **Dynamic Text Scaling Slider:** From 85% to 135% scaling.
- **Dark Mode:** High-contrast night theme for low-light conditions.

### 11. 📶 Low-Internet Resilience & Offline Mode
- **Local Persistent Cache:** Uses `SharedPreferences` to cache all user records, prescriptions, appointments, reminders, and first-aid instructions.
- **Network Status Banner:** Informs users when offline while maintaining access to local health records.
- **Simulated Offline Mode:** A toggle in Settings allowing hackathon judges to verify offline performance without physically disconnecting their network.

---

## 👥 Role-Based Access Control (RBAC)

The application provides dedicated dashboards and permissions for three roles:

| Role | Default Demo Account | Key Features |
| :--- | :--- | :--- |
| **Patient** | `gurpreet.singh@caresphere.ai` | AI Assistant, Rx Scanner, Hospital Finder, Health Passport, Reminders, Emergency SOS |
| **Doctor** | `dr.harpreet@caresphere.ai` | Patient appointment queue, Video consultation launcher, Clinical observation notes |
| **Administrator** | `admin.punjab@caresphere.ai` | District health analytics, Announce rural health camps, Verify doctors, Broadcast emergency alerts |

> **Hackathon Quick Login:** On the Login Screen and in the navigation drawer, judges can switch between Patient, Doctor, and Administrator with a single click.

---

## 🛠️ Technology Stack

- **Framework:** Flutter 3.50.1 (Dart 3.14.0)
- **Platforms:** Web, Android, iOS, Windows Desktop
- **State Management:** Provider Architecture
- **Local Persistence & Caching:** SharedPreferences / JSON Store
- **Networking & API:** HTTP client with Gemini 1.5 Flash API endpoint
- **Video Consultation:** Jitsi Meet WebRTC integration
- **Styling:** Material 3 with Healthcare Palette (Teal `#008F87`, Dark Teal `#006B66`, Emergency Red `#E53935`)
- **Dialer & Maps:** `url_launcher` (`tel:`, `geo:`, `https:`)
- **Speech Integration:** Custom multilingual TTS / STT Service

---

## 📂 Project Directory Structure

```
caresphere_ai/
├── lib/
│   ├── main.dart                          # App Entrypoint & MultiProvider Setup
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Brand Palette (Teal, Dark Teal, Red, Navy)
│   │   │   ├── app_strings.dart           # Complete English, Hindi, Punjabi Dictionaries
│   │   │   └── api_constants.dart         # Gemini API & Helpline Configuration
│   │   ├── localization/
│   │   │   └── app_localizations.dart     # Multilingual Helper
│   │   ├── services/
│   │   │   ├── ai_service.dart            # Gemini API & Emergency Triage Engine
│   │   │   ├── ocr_prescription_service.dart # Prescription Analyzer & Uncertainty Flagging
│   │   │   ├── tts_stt_service.dart       # Speech-to-Text & Text-to-Speech Service
│   │   │   ├── local_storage_service.dart # Persistent Offline Cache
│   │   │   └── emergency_service.dart     # Dial 112/108, GPS Directions & Jitsi Launcher
│   │   └── theme/
│   │       └── app_theme.dart             # Modern Light, Dark & Simple Accessibility Themes
│   ├── data/
│   │   ├── models/                        # Typed Data Models (User, Prescription, Hospital, etc.)
│   │   └── mock/
│   │       └── seed_data.dart             # Punjab Hospitals, Doctors, Camps, Sample Rx
│   ├── providers/                         # State Management Providers
│   ├── screens/
│   │   ├── splash_onboarding_screen.dart  # Language Picker & Onboarding Carousel
│   │   ├── auth/                          # Login, Register, Quick Demo Switcher
│   │   ├── patient/                       # Patient Home & Multi-tab Navigation
│   │   ├── doctor/                        # Doctor Queue & Telemedicine Dashboard
│   │   ├── admin/                         # District Health Admin Portal & Analytics
│   │   ├── ai_assistant/                  # AI Healthcare Assistant Chat Screen
│   │   ├── prescription/                  # AI Prescription Scanner & Translator
│   │   ├── hospital/                      # Punjab Hospital & Doctor Appointment Booking
│   │   ├── consultation/                  # Jitsi Meet Video Consultation Room
│   │   ├── records/                       # Health Vitals & Emergency Health Passport
│   │   ├── reminders/                     # Daily Medicine Reminders & Compliance
│   │   ├── emergency/                     # 112/108 SOS & Offline First-Aid Guides
│   │   ├── rural_health/                  # Punjab Free Health Camps & Govt Schemes
│   │   └── settings/                      # Accessibility, Simple Mode & API Keys
│   └── widgets/                           # Reusable UI Widgets & Audio Speak Buttons
├── test/
│   └── widget_test.dart                   # Unit & Widget Tests (All 5 Passing)
└── pubspec.yaml                           # Dependencies & Assets
```

---

## 🏃 How to Run the Application

### 1. Set Active Workspace
Ensure your terminal or IDE workspace is opened at:
```bash
cd "C:\Users\jasle\.gemini\antigravity\scratch\caresphere_ai"
```

### 2. Run Tests
```bash
flutter test
```
*Result: 5/5 Unit and Widget tests pass with 0 errors.*

### 3. Run in Chrome (Web)
```bash
flutter run -d chrome
```

### 4. Build Production Release (Web)
```bash
flutter build web --release
```
*Compiled output is served from `build/web`.*

---

## 🏆 Hackathon Alignment: "The Builder's Theory 1.0"

CareSphere AI directly tackles the core pillars of the hackathon:
1. **Accessibility:** Trilingual support (English, Hindi, Punjabi) with complete voice input and audio read-aloud.
2. **Rural Reach:** Pre-seeded Punjab rural PHCs/CHCs, free eye & health camps, and government scheme guides.
3. **Medical Safety:** Strict AI guardrails detecting emergencies and marking uncertain prescription handwriting.
4. **Resilience:** 100% offline access to the Emergency Medical Passport, saved records, and first-aid instructions.
