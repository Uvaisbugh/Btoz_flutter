import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'models/student.dart';
import 'models/course.dart';
import 'models/attendance.dart';
import 'models/payment.dart';
import 'services/data_initializer.dart';
import 'screens/splash.dart';

// Global variables for app-wide access
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late ConnectivityResult connectivityResult;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive database
    await Hive.initFlutter();
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(CourseAdapter());
    Hive.registerAdapter(AttendanceAdapter());
    Hive.registerAdapter(PaymentAdapter());

    // Open Hive boxes
    await Hive.openBox('preferences');
    await Hive.openBox<Student>('students');
    await Hive.openBox<Course>('courses');
    await Hive.openBox<Attendance>('attendance');
    await Hive.openBox<Payment>('payments');

    // Initialize local notifications
    await _initializeNotifications();

    // Check connectivity
    connectivityResult = await Connectivity().checkConnectivity();

    // Initialize sample data
    await DataInitializer.initializeSampleData();

    runApp(const BtozApp());
  } catch (e) {
    print('Error initializing app: $e');
    // Fallback to basic app without Hive
    runApp(const BtozApp());
  }
}

// Initialize local notifications
Future<void> _initializeNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class BtozApp extends StatelessWidget {
  const BtozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTOZ Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary color scheme
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1976D2),
        primaryColorLight: const Color(0xFF42A5F5),
        primaryColorDark: const Color(0xFF1565C0),

        // Secondary color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),

        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Card theme
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),

        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 6,
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),

        // Bottom navigation bar theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1976D2),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Text theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),

        // Use Material 3 design
        useMaterial3: true,
      ),

      // Dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF42A5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF42A5F5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Theme mode (can be changed based on user preference)
      themeMode: ThemeMode.system,

      home: const SplashScreen(),
    );
  }
}
