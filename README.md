# BTOZ Academy - Educational Management System

A comprehensive Flutter application for managing educational institutions with modern Material Design UI and robust data management capabilities.

## 🎓 Features

### Core Functionality
- **Student Management**: Add, edit, delete, and search students with detailed profiles
- **Course Management**: Create and manage courses with duration, fees, and instructor information
- **Attendance Tracking**: Mark and track student attendance with date-based filtering
- **Payment Management**: Record and track payments with multiple payment methods
- **Analytics & Reports**: Comprehensive dashboard with charts and statistics

### UI/UX Features
- **Material Design 3**: Modern, responsive UI following Material Design guidelines
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Layout**: Optimized for various screen sizes
- **Smooth Animations**: Engaging user experience with fluid transitions
- **Intuitive Navigation**: Bottom navigation with 7 main sections

### Technical Features
- **Local Database**: Hive for fast, lightweight data storage
- **Real-time Updates**: Live data synchronization across all screens
- **Search & Filter**: Advanced search and filtering capabilities
- **Data Visualization**: Charts and graphs for analytics
- **Form Validation**: Comprehensive input validation and error handling

## 📱 Screenshots

### Dashboard
- Overview statistics with key metrics
- Revenue trend charts
- Recent students and courses
- Quick action buttons

### Students
- Student list with search functionality
- Add new students with form validation
- View detailed student information
- Delete students with confirmation

### Courses
- Course management with full CRUD operations
- Course details with instructor and schedule information
- Revenue tracking per course
- Active/inactive course status

### Attendance
- Take attendance for specific courses and dates
- Filter attendance records by course and date
- Visual indicators for present/absent students
- Bulk attendance marking

### Reports
- Overall statistics dashboard
- Revenue trend analysis (12-month view)
- Attendance charts by course
- Top performing courses
- Recent activity feed

## 🛠️ Technology Stack

### Core Dependencies
- **Flutter**: 3.8.1+ (Latest stable)
- **Dart**: 3.8.1+

### State Management & Database
- **Hive**: Lightweight, fast NoSQL database
- **Hive Flutter**: Flutter integration for Hive
- **UUID**: Unique identifier generation

### UI & Design
- **Material Design Icons**: Extended icon set
- **Fl Chart**: Beautiful charts and graphs
- **Flutter Spinkit**: Loading animations
- **Intl**: Internationalization and date formatting

### Additional Features
- **Shared Preferences**: Simple key-value storage
- **Flutter Local Notifications**: Local notification system
- **Connectivity Plus**: Network connectivity checking
- **URL Launcher**: External link handling
- **File Picker**: Document upload functionality
- **PDF**: PDF generation capabilities
- **QR Flutter**: QR code generation
- **Mobile Scanner**: Barcode scanning

### Development Tools
- **Build Runner**: Code generation
- **Hive Generator**: Hive adapter generation
- **Flutter Lints**: Code quality and style enforcement

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/btoz-academy.git
   cd btoz-academy
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android (API 21+)
- ✅ iOS (iOS 11.0+)
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Windows (Windows 10+)
- ✅ macOS (macOS 10.14+)
- ✅ Linux (Ubuntu 18.04+)

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
├── models/                   # Data models with Hive annotations
│   ├── student.dart         # Student model
│   ├── course.dart          # Course model
│   ├── attendance.dart      # Attendance model
│   └── payment.dart         # Payment model
├── screens/                  # UI screens
│   ├── splash.dart          # Splash screen with animations
│   ├── home.dart            # Main dashboard
│   ├── students.dart        # Student management
│   ├── courses.dart         # Course management
│   ├── attendance.dart      # Attendance tracking
│   ├── reports.dart         # Analytics and reports
│   ├── login.dart           # Authentication screen
│   └── option.dart          # Options/settings screen
├── services/                 # Business logic and data services
│   ├── data_initializer.dart # Sample data initialization
│   ├── student_service.dart  # Student operations
│   ├── course_service.dart   # Course operations
│   ├── attendance_service.dart # Attendance operations
│   └── payment_service.dart  # Payment operations
└── assets/                   # Static assets
    └── images/              # App icons and images
```

## 🎨 Design System

### Color Palette
- **Primary**: Blue (#1976D2)
- **Primary Light**: Light Blue (#42A5F5)
- **Primary Dark**: Dark Blue (#1565C0)
- **Secondary**: Green (#4CAF50)
- **Accent**: Orange (#FF9800)
- **Success**: Green (#4CAF50)
- **Error**: Red (#F44336)
- **Warning**: Orange (#FF9800)

### Typography
- **Headline Large**: 32px, Bold
- **Headline Medium**: 24px, Semi-bold
- **Title Large**: 20px, Semi-bold
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Body Small**: 12px, Regular

### Components
- **Cards**: Elevated with rounded corners (12px radius)
- **Buttons**: Material Design with consistent styling
- **Input Fields**: Outlined with focus states
- **Navigation**: Bottom navigation bar with icons and labels

## 📊 Data Models

### Student
```dart
class Student {
  String id;
  String name;
  String email;
  String phone;
  String course;
  int age;
  DateTime createdAt;
}
```

### Course
```dart
class Course {
  String id;
  String name;
  String description;
  int duration; // months
  double fee;
  String instructor;
  DateTime startDate;
  DateTime endDate;
  bool isActive;
  DateTime createdAt;
}
```

### Attendance
```dart
class Attendance {
  String id;
  String studentId;
  String courseId;
  DateTime date;
  bool isPresent;
  String? remarks;
  DateTime createdAt;
}
```

### Payment
```dart
class Payment {
  String id;
  String studentId;
  String courseId;
  double amount;
  String paymentMethod;
  String status; // pending, completed, failed, refunded
  DateTime paymentDate;
  String? transactionId;
  String? notes;
  DateTime createdAt;
}
```

## 🔧 Configuration

### pubspec.yaml
The project includes comprehensive dependencies with detailed comments explaining each package's purpose:

- **Core Flutter dependencies**
- **State Management & Data Persistence**
- **UI & Design Dependencies**
- **Charts and data visualization**
- **Date and time handling**
- **Image handling and caching**
- **Form validation**
- **Loading animations**
- **Toast notifications**
- **Permission handling**
- **File operations**
- **PDF generation**
- **QR code functionality**
- **Local notifications**
- **HTTP requests**
- **JSON serialization**
- **URL launching**
- **Connectivity checking**
- **Device information**
- **Secure storage**
- **Biometric authentication**
- **Google Sign-In**
- **Firebase services** (optional)

### Analysis Options
- Flutter Lints for code quality
- Customizable lint rules
- Comprehensive error checking

## 🚀 Deployment

### Android
1. Update `android/app/build.gradle.kts` with your app details
2. Generate signed APK/Bundle
3. Upload to Google Play Store

### iOS
1. Update `ios/Runner/Info.plist` with your app details
2. Configure signing in Xcode
3. Archive and upload to App Store Connect

### Web
1. Build for web: `flutter build web`
2. Deploy to your preferred hosting service

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive team for the lightweight database solution
- Fl Chart team for beautiful charts
- Material Design team for design guidelines
- All contributors and supporters

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Email: support@btozacademy.com
- Documentation: [docs.btozacademy.com](https://docs.btozacademy.com)

## 🔄 Version History

### v1.0.0 (Current)
- Initial release
- Complete CRUD operations for all entities
- Material Design 3 UI
- Comprehensive analytics and reporting
- Local database with Hive
- Multi-platform support

---

**BTOZ Academy** - Empowering Education Management
