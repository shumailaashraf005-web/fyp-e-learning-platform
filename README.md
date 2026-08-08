📘 FYP E-Learning Platform
📖 Overview
A modern e-learning platform designed for academic subjects, developed as a Final Year Project.
An e-learning app for academic subjects is a digital learning platform designed to help students study school, college, or university subjects through online resources. E-learning can include video lectures, digital notes, interactive lessons, quizzes, assignments, live classes, and progress tracking.

A typical academic e-learning app allows students to select subjects, access lessons, watch lectures, practice questions, complete assignments, and take online tests. Teachers can upload learning materials, communicate with students, assess their performance, and monitor progress. These functions are commonly provided through learning management systems (LMS).


🚀 Features
📚 Subject-wise courses and study materials
🎥 Recorded and live video lectures
📝 Notes, assignments, and quizzes
🧠 Practice tests and examinations
📊 Student performance and progress reports
💬 Teacher–student communication
🔔 Notifications for classes and assignments
📱 Access through smartphones, tablets, or computers
🔐 User authentication (students & instructors)
📊 Progress tracking dashboard
👩‍🏫 Admin panel for content management
🌐 Responsive design for web and mobile

🛠️ Tech Stack 🛠️ Tech Stack

📱 Frontend & Mobile Development

   Flutter — Cross-platform UI and application development
   Dart — Primary programming language
   Material Design — Responsive and modern Android UI components
   Android SDK — Android application development, testing, and deployment
   Android Studio — Development, debugging, and emulator suppor
   
🔐Authentication & Security

   Firebase Authentication — Secure user registration and login
   JWT Authentication — Token-based authentication for custom backend APIs, if required
   Role-Based Access Control — Separate access for students, teachers, and administrators
  
☁️ Backend & APIs

   RESTful API — Communication between the Flutter application and backend services
   Node.js — Backend runtime environment, if a custom backend is required
   Express.js — API and server framework
   
🗄️ Database & Storage

   MongoDB Atlas — Cloud database for users, courses, subjects, lessons, quizzes, and academic progress
   Firebase Firestore — Optional real-time database for application data
   Firebase Storage — Storage for course materials, images, documents, and other learning resources

🚀 Deployment & Distribution

   Google Play Store — Android application distribution
   Firebase — Backend services, authentication, analytics, and cloud features
   GitHub — Source-code management and version control
   GitHub Actions — Optional CI/CD for automated testing and Android builds
   
🧪 Testing & Development Tools

   Flutter Test — Unit and widget testing
   Android Emulator — Android device testing
   Flutter DevTools — Performance analysis and debugging
   Postman — REST API development and testing


📂 Project Structure
🏗️ Application Architecture

The e-learning application follows a **feature-based, layered architecture** designed for scalability, maintainability, and clean separation of responsibilities.

The architecture separates the application into four main layers:

1. Presentation Layer — Screens, widgets, UI state, and user interaction.
2. Domain Layer — Business logic and core application entities.
3. Data Layer — API communication, Firebase/database access, models, and repositories.
4. Core Layer — Shared utilities, constants, themes, routing, error handling, and common services.
   
Architecture Flow

```text
User
  │
  ▼
Presentation Layer
  │
  ├── Screens
  ├── Widgets
  └── State Management
  │
  ▼
Domain Layer
  │
  ├── Entities
  ├── Use Cases
  └── Repository Contracts
  │
  ▼
Data Layer
  │
  ├── Models
  ├── Repository Implementations
  ├── API Services
  └── Firebase / Database
  │
  ▼
Backend / Cloud Services
```

This structure allows individual features such as authentication, courses, subjects, lessons, quizzes, assignments, and student progress to be developed and maintained independently.

📂 Project Structure

```text
lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── routes/
│   │   └── app_routes.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       └── app_text_styles.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_constants.dart
│   │
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   │
│   ├── services/
│   │   ├── storage_service.dart
│   │   └── notification_service.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── date_utils.dart
│   │   └── helpers.dart
│   │
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── loading_widget.dart
│       └── error_widget.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── state/
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── courses/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── subjects/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── lessons/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── quizzes/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── assignments/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── progress/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── notifications/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── l10n/
    └── app_localizations.dart
```

🎓 Core E-Learning Features
 Authentication 
    Student registration
    Login and logout
    Password recovery
    User profiles
    Authentication state
    Student/teacher/admin roles
Courses & Subjects
    Course listing
    Academic subjects
    Subject details
    Course enrollment
    Course categories
    Teacher/course information
Lessons
   Video lessons
   Text-based lessons
   PDF and learning resources
   Lesson completion
   Next/previous lesson navigation
Quizzes & Assessments
   Multiple-choice questions
   Online quizzes
   Automatic scoring
   Exam submission
   Results and feedback
Assignments
  Assignment creation
  Assignment submission
  Deadlines
  Teacher evaluation
  Student feedback
Progress Tracking
  Course completion percentage
  Lesson progress
  Quiz scores
  Assignment results
  Learning activity history
  
🔄 Data Flow

```text
Flutter UI
    │
    ▼
State Management
    │
    ▼
Use Case
    │
    ▼
Repository
    │
    ▼
Data Source
    │
    ├── REST API
    ├── Firebase
    └── Local Storage
    │
    ▼
Database / Cloud Services
```
📦 Suggested Flutter Packages

   Depending on the final implementation, the project can use:

```yaml
dependencies:
  flutter:
    sdk: flutter

State Management
  flutter_riverpod: ^2.0.0
Navigation
  go_router: ^16.0.0
Network
  dio: ^5.0.0
Firebase
  firebase_core: ^4.0.0
  firebase_auth: ^6.0.0
  cloud_firestore: ^6.0.0
Local Storage
  shared_preferences: ^2.0.0
Media
  video_player: ^2.0.0
File/PDF Support
  path_provider: ^2.0.0
```

> Package versions should be updated to the versions compatible with the Flutter/Dart SDK used by the project.

📱 Android Project Structure

The Android-specific configuration remains inside the Flutter project's `android/` directory:

```text
android/
├── app/
│   ├── build.gradle.kts
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml
│       │   ├── kotlin/
│       │   └── res/
│       ├── debug/
│       └── profile/
│
├── gradle/
├── build.gradle.kts
├── settings.gradle.kts
└── gradle.properties
```

Flutter is responsible for the cross-platform application layer, while the Android directory contains Android-specific configuration such as the application ID, permissions, Gradle configuration, icons, native integrations, and release settings.

🔐 Security & Data Management

The application should protect user data through:
  Secure authentication
  Role-based authorization
  HTTPS communication
  Secure token/session handling
  Firebase Security Rules when Firebase is used
  Input validation
  Protected API endpoints
  Minimal storage of sensitive information
  
🚀 Scalability

The feature-based structure makes it easier to add future modules such as:

```text
Live Classes
Discussion Forums
Chat
Certificates
Attendance
Payment
Teacher Dashboard
Admin Dashboard
AI Learning Assistant
Offline Learning
Push Notifications
```

This architecture keeps the Flutter application modular and makes it easier for multiple developers to work on different academic modules without creating unnecessary dependencies between features.

⚙️ Installation & Setup

Follow the steps below to set up and run the Flutter e-learning application locally.

1. Prerequisites

Make sure the following tools are installed on your system:

 [Flutter SDK](https://docs.flutter.dev/get-started/install)
 [Dart SDK](https://dart.dev/get-dart)
 [Android Studio](https://developer.android.com/studio)
 Android SDK and Android Emulator, or a physical Android device
 [Git](https://git-scm.com/)

Verify the Flutter installation:

```bash
flutter doctor
```

Resolve any issues reported by `flutter doctor` before proceeding.
2. Clone the Repository

Clone the project from GitHub:

```bash
git clone https://github.com/shumailaashraf005-web/fyp-e-learning-platform.git
```

Navigate to the Flutter project directory:

```bash
cd fyp-e-learning-platform
```

> If the Flutter project is located inside a subdirectory such as `finalproject`, use:
>
> ```bash
> cd fyp-e-learning-platform/finalproject
> ```

3. Install Flutter Dependencies

Download all required Flutter packages:

```bash
flutter pub get
```
4. Configure the Android Device

Connect an Android smartphone using USB debugging, or start an Android Emulator through Android Studio.

Check whether Flutter detects your device:

```bash
flutter devices
```
5. Run the Application

Start the application using:

```bash
flutter run
```

Flutter will build and launch the application on the connected Android device or emulator.
6. Build Android APK

To generate a release APK for Android:

```bash
flutter build apk --release
```

The generated APK can be found at:

```text
build/app/outputs/flutter-apk/app-release.apk
```
7. Troubleshooting

If you encounter dependency or build issues, try:

```bash
flutter clean
flutter pub get
flutter run
```

You can also check the project configuration with:

```bash
flutter doctor
```
📌 Project Setup Summary

```text
Clone Repository
       ↓
Open Flutter Project
       ↓
flutter pub get
       ↓
Connect Android Device / Start Emulator
       ↓
flutter run
       ↓
Application Running
```

📌 Usage

The e-learning application provides dedicated functionality for students, instructors, and administrators.

 👨‍🎓 Students
   Register and securely log in to the application.
   Browse available academic courses and subjects.
   Enroll in courses and access learning materials.
   View lessons, educational content, and course resources.
   Attempt quizzes and assessments.
   View quiz results and monitor learning progress.
👨‍🏫 Instructors
   Manage assigned courses and academic subjects.
   Add and update lessons and learning materials.
   Create and manage quizzes and assessments.
   Monitor student participation and academic performance.
   Review student progress and assessment results.
👨‍💼 Administrators
   Manage student and instructor accounts.
   Add, update, and remove courses and academic subjects.
   Manage application content and user access.
   Monitor overall platform activity and system data.

🧪 Testing

The application is tested to ensure reliability, functionality, usability, and compatibility across supported Android devices.

🔬 Unit Testing

Flutter's built-in testing framework is used to test individual functions, services, and business logic.

```bash
flutter test
```
🧩 Widget Testing

Flutter widget tests are used to verify the behavior and UI of individual widgets and screens.

```bash
flutter test test/
```
📱 Android Device Testing

The application is tested on Android devices and/or emulators to verify:
  User authentication and navigation
  Course and subject functionality
  Lesson and learning-material access
  Quiz and assessment functionality
  Progress tracking
  Responsive UI behavior
  Application performance


✅ Testing Goals
The testing process aims to ensure that the application is:
  Reliable and stable
  Functionally correct
  User-friendly
  Secure
  Compatible with Android devices
  Ready for production deployment

📈 Roadmap

The following features are planned for future development to further enhance the functionality and learning experience of the platform.

🎥 Video-Based Learning

 [ ] Integrate video lectures and educational content.
 [ ] Support video playback within individual lessons.
 [ ] Track video-based learning progress.
 
🏆 Gamification

 [ ] Introduce achievement badges and rewards.
 [ ] Implement student leaderboards.
 [ ] Add learning milestones and achievement tracking.
 
🤖 AI-Powered Learning

 [ ] Implement personalized learning recommendations.
 [ ] Analyze student learning activity and performance.
 [ ] Recommend relevant courses, subjects, and learning materials.
 
📱 Application Enhancements

 [ ] Improve Android application performance and responsiveness.
 [ ] Add push notifications for courses, assignments, and assessments.
 [ ] Introduce offline access to selected learning materials.
 [ ] Enhance accessibility and user experience.

📸 Screenshots
(Add screenshots of your dashboard, course pages, and quiz module here)

📜 License
This project is licensed under the MIT License – see the [Looks like the result wasn't safe to show. Let's switch things up and try something else!] file for details.
