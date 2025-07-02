import 'package:hive/hive.dart';
import 'package:btoz/models/student.dart';

class StudentService {
  static const String _boxName = 'students';

  static Box<Student> get _box => Hive.box<Student>(_boxName);

  // Create - Add a new student
  static Future<void> addStudent(Student student) async {
    await _box.put(student.id, student);
  }

  // Read - Get all students
  static List<Student> getAllStudents() {
    return _box.values.toList();
  }

  // Read - Get student by ID
  static Student? getStudentById(String id) {
    return _box.get(id);
  }

  // Update - Update existing student
  static Future<void> updateStudent(Student student) async {
    await _box.put(student.id, student);
  }

  // Delete - Delete student by ID
  static Future<void> deleteStudent(String id) async {
    await _box.delete(id);
  }

  // Search students by name
  static List<Student> searchStudentsByName(String query) {
    final allStudents = getAllStudents();
    return allStudents
        .where(
          (student) => student.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Get students by course
  static List<Student> getStudentsByCourse(String course) {
    final allStudents = getAllStudents();
    return allStudents
        .where(
          (student) =>
              student.course.toLowerCase().contains(course.toLowerCase()),
        )
        .toList();
  }

  // Clear all students
  static Future<void> clearAllStudents() async {
    await _box.clear();
  }
}
