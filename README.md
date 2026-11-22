# CareSphere AI 🏥
### Your AI Health Companion for Rural India

[![Project](https://img.shields.io/badge/Project-CareSphere%20AI-0D9488)]()
[![Domain](https://img.shields.io/badge/Domain-Digital%20Healthcare-blue)]()
[![AI](https://img.shields.io/badge/AI-Powered-purple)]()
[![Status](https://img.shields.io/badge/Status-In%20Development-orange)]()

**CareSphere AI** is an AI-powered digital healthcare platform designed to make healthcare information, assistance, and essential medical services more accessible, understandable, and manageable, especially for people living in rural and underserved communities.

The platform aims to bring multiple healthcare services together in one place, including AI-powered health assistance, prescription management, digital health records, medicine reminders, hospital and doctor discovery, online consultations, emergency support, and healthcare community engagement.

Our vision is to use technology and artificial intelligence to reduce healthcare accessibility barriers and create a more connected and user-friendly healthcare experience.

---

## 📑 Table of Contents

1. [Project Overview](#-project-overview)
2. [Problem Statement](#-problem-statement)
3. [Our Solution](#-our-solution)
4. [Project Objectives](#-project-objectives)
5. [Key Features](#-key-features)
6. [AI Medicine Scanner](#-ai-medicine-scanner)
7. [Technology Stack](#-technology-stack)
8. [System Architecture](#-system-architecture)
9. [API Integration](#-api-integration)
10. [Data Flow](#-data-flow)
11. [Scalability and Performance](#-scalability-and-performance)
12. [Security and Privacy](#-security-and-privacy)
13. [Installation and Setup](#-installation-and-setup)
14. [Project Structure](#-project-structure)
15. [Testing and Quality Assurance](#-testing-and-quality-assurance)
16. [Challenges and Solutions](#-challenges-and-solutions)
17. [Future Enhancements](#-future-enhancements)
18. [Limitations](#-limitations)
19. [Contributing](#-contributing)
20. [Disclaimer](#-medical-disclaimer)

---

## 🌍 Project Overview

Healthcare accessibility remains a major challenge for people in rural and underserved regions. Patients may experience difficulties understanding medical prescriptions, finding appropriate healthcare services, managing medical records, and remembering medicine schedules.

CareSphere AI aims to address these challenges through a unified digital healthcare platform.

Instead of requiring users to depend on multiple disconnected applications, CareSphere AI brings essential healthcare-related services into a single, accessible environment.

### Our Vision

To make healthcare more accessible, understandable, and digitally connected for everyone.

### Our Mission

- Simplify access to healthcare information.
- Improve the management of personal health records.
- Reduce difficulties associated with understanding medical information.
- Support patients in managing their medicine schedules.
- Improve discoverability of hospitals and healthcare professionals.
- Use AI responsibly to assist users with general healthcare information.

### Target Audience

- People living in rural and underserved communities.
- Patients managing recurring medical conditions.
- Elderly individuals who need help organizing medicine schedules.
- Users who face language barriers when understanding healthcare information.
- Individuals looking for accessible healthcare services.

### Supported Languages

The platform is designed with multilingual accessibility in mind:

- English
- Hindi
- Punjabi

---

## 🚨 Problem Statement

Access to healthcare information and services is not equally convenient for everyone.

Many people, particularly in rural communities, encounter challenges such as:

**1. Difficulty Understanding Prescriptions**

Medical terminology, handwritten prescriptions, and unfamiliar instructions can make it difficult for patients to understand their prescribed medicines.

**2. Limited Healthcare Accessibility**

Finding suitable doctors, specialists, and hospitals can be challenging, particularly in areas with limited healthcare infrastructure.

**3. Poor Medical Record Management**

Patients often maintain medical reports, prescriptions, and previous health information in different physical and digital locations.

**4. Medicine Schedule Management**

Patients may forget medicine timings or struggle to maintain consistent medication schedules.

**5. Language Barriers**

Healthcare information is frequently presented using complex medical terminology or languages that users may not understand comfortably.

**6. Fragmented Healthcare Services**

Users often need multiple applications or platforms for different healthcare-related activities.

### Core Problem

There is a need for a unified, accessible, and user-friendly digital healthcare platform that simplifies healthcare information management and connects users with essential healthcare services.

---

## 💡 Our Solution

CareSphere AI proposes a centralized healthcare platform that combines AI assistance, health information management, medicine reminders, and healthcare service discovery.

The platform focuses on:

- Providing understandable healthcare information.
- Organizing personal medical information.
- Helping users manage medicine reminders.
- Supporting prescription and medicine information reading.
- Connecting users with healthcare resources.
- Making the experience accessible through multilingual support.

Our approach combines an accessible user interface with AI-assisted capabilities and backend services.

---

## 🎯 Project Objectives

1. Build a centralized digital healthcare platform.
2. Improve accessibility to general healthcare information.
3. Simplify the organization of prescriptions and medical records.
4. Support medicine schedule management.
5. Make healthcare information easier to understand.
6. Introduce camera-based medicine information extraction.
7. Provide an architecture that can support increasing users and data.
8. Maintain appropriate privacy and security practices for sensitive health information.

---

## ✨ Key Features

### 1. AI Health Assistant

An AI-assisted healthcare information interface that aims to help users understand general health-related topics.

**Intended capabilities:**
- Ask general health-related questions.
- Receive easy-to-understand explanations.
- Support multilingual interactions.
- Simplify complex medical terminology.
- Provide general health awareness information.

**Example:**

A user asks:

"What are the common symptoms of dehydration?"

The assistant can provide general educational information in understandable language.

**Important:** AI-generated information should not be treated as a medical diagnosis or a replacement for professional consultation.

### 2. Prescription Management

A dedicated module for managing prescription-related information.

**Intended capabilities:**
- Upload prescription documents or images.
- Organize prescription information.
- Access previously saved prescriptions.
- Support digital prescription management.

### 3. Digital Health Records

A centralized space for organizing personal medical information.

**Intended capabilities:**
- Maintain health-related records.
- Organize prescription information.
- Access previously saved medical documents.
- Maintain a structured history of saved information.

### 4. Medicine Reminders

A feature designed to help users remember their medicine schedules.

**Intended capabilities:**
- Set medicine reminders.
- Maintain reminder schedules.
- Display upcoming reminders.
- Help users maintain medication routines.

### 5. Hospitals & Doctors

A healthcare discovery module designed to help users find healthcare providers.

**Intended capabilities:**
- Discover hospitals.
- Search for doctors.
- Explore healthcare services.
- Improve access to relevant medical resources.

### 6. Online Consultation

A module intended to support digital communication between patients and healthcare professionals.

**Potential capabilities:**
- Online appointment discovery.
- Doctor consultation access.
- Digital healthcare communication.

### 7. Emergency Support

A dedicated section for quick access to emergency-related information and resources.

**Potential capabilities:**
- Emergency contact information.
- Access to emergency resources.
- Quick navigation to relevant healthcare services.

### 8. Healthcare Community

A space intended to encourage healthcare awareness and user engagement.

**Potential capabilities:**
- Health-related discussions.
- Information sharing.
- Community engagement.
- Health awareness initiatives.

### 9. Admin Dashboard

An administrative interface intended to support platform management.

Potential responsibilities include:
- User management.
- Content management.
- Healthcare service administration.
- Monitoring platform activities.

Actual administrative permissions and operations depend on the implemented backend.

---

## 📸 AI Medicine Scanner

**Selected Feature – Track 2: Superpowers in Your Pocket**

The AI Medicine Scanner is a planned camera-based feature designed to extract readable information from medicine packaging.

It uses smartphone camera capabilities and Optical Character Recognition (OCR) to convert printed medicine-label information into digital text.

### Problem

Patients may find it difficult to read small medicine labels, unfamiliar medical terms, and expiry information.

Manual entry of medicine information can also be time-consuming.

### Proposed Solution

The AI Medicine Scanner allows users to capture a medicine package or label and extract relevant printed information for review.

### How It Works

1. User opens the AI Medicine Scanner.
2. Application requests camera permission.
3. User captures an image of the medicine package.
4. OCR processes the captured image.
5. Extracted text is organized into relevant fields.
6. User reviews and corrects the extracted details.
7. Confirmed information can be saved to Health Records.

### Information to Extract

| Field | Description |
|---|---|
| Medicine Name | Name printed on the packaging |
| Strength | Printed medicine strength |
| Expiry Date | Expiry information, if readable |
| Manufacturer | Manufacturer information, if visible |
| Batch Number | Batch details, if readable |

### Proposed Technologies

- Flutter Camera – Camera access and image capture.
- Google ML Kit Text Recognition or another suitable OCR engine – Text extraction.
- Dart – Application logic.
- Riverpod – State management.
- Serverpod – Backend endpoints and data processing.
- PostgreSQL – Structured storage of scan records.

### Feature Safety

The scanner is intended to read visible packaging information.

It will not independently determine whether a medicine is appropriate for a patient, recommend dosages, diagnose medical conditions, or guarantee medicine identification.

Unclear or uncertain information must be manually verified before saving.

**Implementation status:** Planned / Under Development. These technologies are proposed implementation choices, not confirmation that the scanner is already integrated.

---

## 🛠️ Technology Stack

The project documentation distinguishes between the technologies observed in the existing website snapshot and the stack required for the hackathon implementation.

### Existing Website – Observed Technologies

| Technology | Purpose |
|---|---|
| React | Component-based frontend UI |
| TypeScript / TSX | Typed application development |
| TanStack Start | Application framework and routing infrastructure |
| Tailwind CSS | Styling and responsive UI |
| Lucide Icons | Interface icons |

### Hackathon Backend and Mobile Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language for Flutter |
| Riverpod | State management |
| Serverpod 4 | Backend development and API endpoints |
| PostgreSQL | Relational database |
| Serverpod Cloud | Backend hosting and deployment |

**Architecture note:** The complete repository must be inspected to determine whether these two technology groups are already integrated. The hackathon stack should not be represented as an existing implementation until verified.

---

## 🏗️ System Architecture

CareSphere AI follows a modular architecture approach, allowing different healthcare features to communicate with the appropriate application services.

### Conceptual Architecture

```text
                  USER
                    |
                    v
          CARESPHERE AI INTERFACE
                    |
          +---------+---------+
          |                   |
          v                   v
     AI Assistant       Healthcare Modules
                              |
                    +---------+---------+
                    |         |         |
                    v         v         v
                Health    Prescriptions Reminders
                Records
                    |
                    v
              BACKEND SERVICES
                    |
          +---------+---------+
          |                   |
          v                   v
     External APIs        Database
          |                   |
          v                   v
      AI / OCR /         PostgreSQL
      Other Services
```

This diagram represents the proposed logical architecture. Actual integrations and connections must be confirmed from the source code.

### Architectural Components

**Frontend Layer**

Responsible for:
- User interaction.
- Navigation.
- Form inputs.
- Displaying API responses.
- Managing interface states.

**Backend Layer**

Responsible for:
- Processing application requests.
- Validating input.
- Managing business logic.
- Handling authorization.
- Communicating with the database.

**Database Layer**

Responsible for:
- Structured information storage.
- User-related records.
- Medicine scan history.
- Prescription and reminder data.

**External Services Layer**

May provide:
- AI-generated responses.
- OCR processing.
- Maps and location information.
- Notification delivery.

---

## 🔌 API Integration

APIs allow different software components to communicate and exchange information.

CareSphere AI may use internal backend APIs and external service APIs depending on the feature.

### API Categories

| API Category | Purpose |
|---|---|
| AI API | Generate general healthcare information |
| OCR API / Engine | Extract text from prescription and medicine images |
| Camera API | Access smartphone camera |
| Maps / Places API | Discover hospitals and healthcare providers |
| Notification API | Deliver medicine reminders |
| Serverpod Endpoints | Communicate between frontend and backend |

### API Communication Flow

```text
User Action
    |
    v
Frontend Request
    |
    v
Backend Endpoint
    |
    v
Validation and Processing
    |
    v
Database / External API
    |
    v
Backend Response
    |
    v
Frontend Update
```

### API Accuracy and Reliability

API performance and AI response quality are different measurements.

We intend to evaluate:

- Response correctness.
- API availability.
- Average response time.
- Failed request percentage.
- Invalid input handling.
- Timeout handling.
- Hindi and English response quality.

No numerical API accuracy percentage is claimed without actual test results.

---

## 🔄 Data Flow

CareSphere AI is designed to support a structured request-and-response process.

### Example: AI Assistant

1. User enters a healthcare-related question.
2. Frontend collects the input.
3. Application sends the request to the appropriate backend or AI service.
4. The service processes the request.
5. A response is returned.
6. Frontend displays the response.

### Example: AI Medicine Scanner

1. User captures a medicine image.
2. Image is passed to the OCR processing component.
3. OCR extracts readable text.
4. Application organizes the extracted fields.
5. User verifies the information.
6. Verified data is sent to the backend.
7. Backend stores the record in PostgreSQL.
8. Saved information becomes available in the Health Records module.

---

## 📈 Scalability and Performance

Scalability refers to the ability of an application to handle increasing users, requests, and data without significant performance degradation.

For a healthcare platform like CareSphere AI, scalability is important because different users may simultaneously access AI assistance, upload records, search hospitals, and manage reminders.

### Scalability Metrics

| Metric | Meaning |
|---|---|
| Concurrent Users | Number of users active at the same time |
| Response Time | Time taken to process a request |
| Throughput | Number of requests handled per second |
| Error Rate | Percentage of failed requests |
| Resource Utilization | CPU, memory and other resource consumption |

### Important Formulas

**Throughput**

```text
Throughput = Total Successful Requests / Total Time
```

**Error Rate**

```text
Error Rate = (Failed Requests / Total Requests) × 100
```

**Average Response Time**

```text
Average Response Time =
Sum of Response Times / Total Requests
```

### Proposed Scalability Improvements

1. **Horizontal Scaling:** Add backend instances as workload increases.
2. **Load Balancing:** Distribute incoming requests across available instances.
3. **Database Optimization:** Improve query performance and indexing.
4. **Caching:** Cache suitable frequently accessed information.
5. **Rate Limiting:** Control excessive API requests.
6. **Asynchronous Processing:** Handle suitable time-consuming operations without blocking user interactions.

### Load Testing

The application can be evaluated using tools such as:

- Apache JMeter
- k6
- Postman

A gradual load test can be performed using different concurrent-user levels, such as 100, 500 and 1,000 users.

These values are proposed test levels, not verified capacity claims.

---

## 🔐 Security and Privacy

Healthcare applications may process sensitive personal information. Therefore, privacy and security must be considered throughout the application lifecycle.

### Proposed Security Practices

**1. Authentication**

Verify the identity of users before allowing access to protected services.

**2. Authorization**

Ensure that users can access only the resources permitted by their roles and permissions.

**3. Secure Communication**

Use HTTPS for communication between clients and backend services.

**4. Data Protection**

Protect sensitive health information during storage and transmission.

**5. API Key Management**

Store API credentials securely on the server side. Never expose private API keys in frontend code or public repositories.

**6. Input Validation**

Validate user input and uploaded files before processing.

**7. Access Control**

Restrict access to patient records according to appropriate authorization policies.

**8. Error Handling**

Avoid exposing internal system details, database credentials, or sensitive information through error messages.

---

## 💻 Installation and Setup

The following instructions are intended for the existing React/TanStack-based website. Exact package manager and scripts should be checked in the project's `package.json`.

### Prerequisites

- Node.js (compatible with the project's dependencies).
- npm or the package manager specified by the repository.
- Git.
- Antigravity or another code editor.

### Step 1: Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

### Step 2: Navigate to the Project

```bash
cd CareSphere-AI
```

Replace the folder name with the actual repository directory if different.

### Step 3: Install Dependencies

For an npm-based project:

```bash
npm install
```

### Step 4: Configure Environment Variables

Create a `.env` file only after checking the project's existing environment-variable requirements.

Example placeholders:

```env
# Add actual variables required by the application.

AI_API_KEY=your_api_key
DATABASE_URL=your_database_url
```

Do not commit real API keys, database passwords, or other secrets.

### Step 5: Start the Development Server

Check the scripts in `package.json`.

If the project defines a `dev` script, run:

```bash
npm run dev
```

### Step 6: Open the Application

Open the local URL printed in the terminal.

---

## 📁 Project Structure

The following is an illustrative structure for organizing the application. It is not a verified listing of the existing repository.

```text
CareSphere-AI/
│
├── public/
│   ├── images/
│   └── assets/
│
├── src/
│   ├── components/
│   │   ├── common/
│   │   ├── navigation/
│   │   └── dashboard/
│   │
│   ├── features/
│   │   ├── ai-assistant/
│   │   ├── prescriptions/
│   │   ├── health-records/
│   │   ├── reminders/
│   │   ├── hospitals/
│   │   ├── consultation/
│   │   ├── emergency/
│   │   ├── community/
│   │   └── medicine-scanner/
│   │
│   ├── services/
│   │   ├── api/
│   │   └── integrations/
│   │
│   ├── routes/
│   ├── hooks/
│   ├── types/
│   └── styles/
│
├── serverpod/
│   ├
