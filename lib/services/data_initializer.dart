import 'package:hive/hive.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/attendance.dart';
import '../models/payment.dart';

class DataInitializer {
  static const String _initializedKey = 'data_initialized';

  static Future<void> initializeSampleData() async {
    final prefs = Hive.box('preferences');
    final isInitialized = prefs.get(_initializedKey, defaultValue: false);

    if (!isInitialized) {
      await _addSampleStudents();
      await _addSampleCourses();
      await _addSampleAttendance();
      await _addSamplePayments();

      await prefs.put(_initializedKey, true);
    }
  }

  static Future<void> _addSampleStudents() async {
    final studentBox = Hive.box<Student>('students');

    final sampleStudents = [
      Student(
        id: '1',
        name: 'John Smith',
        email: 'john.smith@email.com',
        phone: '+1-555-0101',
        course: 'Computer Science',
        age: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Student(
        id: '2',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@email.com',
        phone: '+1-555-0102',
        course: 'Mathematics',
        age: 19,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Student(
        id: '3',
        name: 'Michael Brown',
        email: 'michael.brown@email.com',
        phone: '+1-555-0103',
        course: 'Physics',
        age: 21,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Student(
        id: '4',
        name: 'Emily Davis',
        email: 'emily.davis@email.com',
        phone: '+1-555-0104',
        course: 'Computer Science',
        age: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Student(
        id: '5',
        name: 'David Wilson',
        email: 'david.wilson@email.com',
        phone: '+1-555-0105',
        course: 'Chemistry',
        age: 22,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    for (final student in sampleStudents) {
      await studentBox.add(student);
    }
  }

  static Future<void> _addSampleCourses() async {
    final courseBox = Hive.box<Course>('courses');

    final sampleCourses = [
      Course(
        id: '1',
        name: 'Computer Science Fundamentals',
        description:
            'Introduction to programming and computer science concepts',
        duration: 4,
        fee: 1200.0,
        instructor: 'Dr. Alice Johnson',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 127)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Course(
        id: '2',
        name: 'Advanced Mathematics',
        description:
            'Advanced calculus, linear algebra, and mathematical analysis',
        duration: 6,
        fee: 1500.0,
        instructor: 'Prof. Robert Chen',
        startDate: DateTime.now().add(const Duration(days: 14)),
        endDate: DateTime.now().add(const Duration(days: 194)),
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Course(
        id: '3',
        name: 'Physics for Engineers',
        description:
            'Classical mechanics, thermodynamics, and electromagnetism',
        duration: 5,
        fee: 1400.0,
        instructor: 'Dr. Maria Garcia',
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 160)),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Course(
        id: '4',
        name: 'Organic Chemistry',
        description: 'Study of organic compounds and chemical reactions',
        duration: 4,
        fee: 1300.0,
        instructor: 'Prof. David Kim',
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 125)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Course(
        id: '5',
        name: 'Data Science',
        description: 'Machine learning, statistics, and data analysis',
        duration: 6,
        fee: 1800.0,
        instructor: 'Dr. Sarah Williams',
        startDate: DateTime.now().add(const Duration(days: 20)),
        endDate: DateTime.now().add(const Duration(days: 200)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    for (final course in sampleCourses) {
      await courseBox.add(course);
    }
  }

  static Future<void> _addSampleAttendance() async {
    final attendanceBox = Hive.box<Attendance>('attendance');
    final studentBox = Hive.box<Student>('students');
    final courseBox = Hive.box<Course>('courses');

    final students = studentBox.values.toList();
    final courses = courseBox.values.toList();

    if (students.isNotEmpty && courses.isNotEmpty) {
      final today = DateTime.now();

      for (int i = 0; i < 20; i++) {
        final randomStudent = students[i % students.length];
        final randomCourse = courses[i % courses.length];
        final randomDate = today.subtract(Duration(days: i % 7));

        final attendance = Attendance(
          id: 'att_$i',
          studentId: randomStudent.id,
          courseId: randomCourse.id,
          date: randomDate,
          isPresent: i % 3 != 0,
          remarks: i % 3 == 0 ? 'Absent due to illness' : null,
          createdAt: randomDate,
        );

        await attendanceBox.add(attendance);
      }
    }
  }

  static Future<void> _addSamplePayments() async {
    final paymentBox = Hive.box<Payment>('payments');
    final studentBox = Hive.box<Student>('students');
    final courseBox = Hive.box<Course>('courses');

    final students = studentBox.values.toList();
    final courses = courseBox.values.toList();

    if (students.isNotEmpty && courses.isNotEmpty) {
      final today = DateTime.now();

      for (int i = 0; i < 15; i++) {
        final randomStudent = students[i % students.length];
        final randomCourse = courses[i % courses.length];
        final randomDate = today.subtract(Duration(days: i * 2));
        final randomAmount = 500.0 + (i * 100);

        final payment = Payment(
          id: 'pay_$i',
          studentId: randomStudent.id,
          courseId: randomCourse.id,
          amount: randomAmount,
          paymentMethod: i % 2 == 0 ? 'Credit Card' : 'Bank Transfer',
          status: i % 4 == 0 ? 'Pending' : 'Completed',
          paymentDate: randomDate,
          transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}_$i',
          notes: i % 3 == 0 ? 'Monthly payment' : null,
          createdAt: randomDate,
        );

        await paymentBox.add(payment);
      }
    }
  }

  static Future<void> resetData() async {
    final prefs = Hive.box('preferences');
    await prefs.delete(_initializedKey);

    await Hive.box<Student>('students').clear();
    await Hive.box<Course>('courses').clear();
    await Hive.box<Attendance>('attendance').clear();
    await Hive.box<Payment>('payments').clear();

    await initializeSampleData();
  }
}
