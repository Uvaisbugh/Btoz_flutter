# Flutter Academy - Modern Educational Management System

A modern Flutter application built with best practices for managing educational institutions. Features a clean Material Design 3 UI, dark/light theme support, and robust state management.

## ✨ Features

### 🎯 Core Features
- **Authentication**: Secure login system with admin access
- **Student Management**: Add, view, edit, and delete students
- **Course Management**: Create and manage courses with instructor details
- **Attendance Tracking**: Mark and track student attendance
- **Admin Dashboard**: Comprehensive admin interface
- **Settings**: App configuration and theme preferences

### 🎨 UI/UX Features
- **Material Design 3**: Modern, responsive UI
- **Dark/Light Theme**: Toggle between light and dark themes
- **Responsive Design**: Optimized for all screen sizes
- **Intuitive Navigation**: Drawer-based navigation system
- **Smooth Animations**: Fluid transitions and interactions

### 🛠️ Technical Features
- **State Management**: Provider for scalable state management
- **Local Storage**: Hive database for fast data persistence
- **Code Generation**: Build runner for Hive adapters
- **Modern Architecture**: Clean, maintainable code structure

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Btoz_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Login Credentials
- **Username**: `admin`
- **Password**: `admin123`

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point with Provider setup
├── core/                        # Core app configuration
│   ├── theme.dart              # Theme configuration and ThemeProvider
│   └── app_constants.dart      # App-wide constants
├── models/                      # Data models with Hive annotations
│   ├── student.dart            # Student model
│   ├── course.dart             # Course model
│   └── attendance.dart         # Attendance model
├── screens/                     # UI screens organized by feature
│   ├── home/                   # Home dashboard
│   │   └── home_screen.dart
│   ├── login/                  # Authentication
│   │   └── login_screen.dart
│   ├── students/               # Student management
│   │   └── students_screen.dart
│   ├── courses/                # Course management
│   │   └── courses_screen.dart
│   ├── attendance/             # Attendance tracking
│   │   └── attendance_screen.dart
│   ├── admin/                  # Admin dashboard
│   │   └── admin_screen.dart
│   └── settings/               # App settings
│       └── settings_screen.dart
├── services/                    # Business logic and data services
└── widgets/                     # Reusable UI components
```

## 🛠️ Technology Stack

### Core Dependencies
- **Flutter**: 3.8.1+
- **Dart**: 3.8.1+

### State Management & Storage
- **Provider**: State management
- **Hive**: Local NoSQL database
- **Hive Flutter**: Flutter integration for Hive
- **Shared Preferences**: Simple key-value storage

### Development Tools
- **Build Runner**: Code generation
- **Hive Generator**: Hive adapter generation
- **Flutter Lints**: Code quality enforcement

## 🎨 Design System

### Theme Support
- **Light Theme**: Clean, bright interface
- **Dark Theme**: Easy on the eyes
- **System Theme**: Automatic theme switching
- **Manual Toggle**: User-controlled theme switching

### Color Scheme
- **Primary**: Blue (#1976D2)
- **Secondary**: Light Blue (#42A5F5)
- **Surface**: Material Design 3 surface colors
- **On Surface**: Contrasting text colors

## 📱 Screenshots

### Login Screen
- Clean authentication interface
- Form validation
- Loading states

### Home Dashboard
- Welcome message
- Navigation drawer
- Quick access to all features

### Settings
- Dark mode toggle
- App configuration options

## 🔧 Development

### Code Generation
After modifying Hive models, regenerate adapters:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Adding New Features
1. Create models in `lib/models/`
2. Add screens in `lib/screens/[feature]/`
3. Update navigation in `lib/screens/home/home_screen.dart`
4. Add routes in `lib/main.dart` if needed

### State Management
- Use `Provider` for app-wide state
- Use `ChangeNotifier` for reactive state
- Keep state close to where it's used

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues or have questions:
1. Check the existing issues
2. Create a new issue with detailed information
3. Include error messages and steps to reproduce

---

**Built with ❤️ using Flutter**
