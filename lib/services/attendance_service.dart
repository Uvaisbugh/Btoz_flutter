import 'package:hive/hive.dart';
import 'package:btoz/models/attendance.dart';

class AttendanceService {
  static const String _boxName = 'attendance';

  static Box<Attendance> get _box => Hive.box<Attendance>(_boxName);

  // Create - Add attendance record
  static Future<void> addAttendance(Attendance attendance) async {
    await _box.put(attendance.id, attendance);
  }

  // Read - Get all attendance records
  static List<Attendance> getAllAttendance() {
    return _box.values.toList();
  }

  // Read - Get attendance by ID
  static Attendance? getAttendanceById(String id) {
    return _box.get(id);
  }

  // Update - Update attendance record
  static Future<void> updateAttendance(Attendance attendance) async {
    await _box.put(attendance.id, attendance);
  }

  // Delete - Delete attendance record
  static Future<void> deleteAttendance(String id) async {
    await _box.delete(id);
  }

  // Get attendance for a specific student
  static List<Attendance> getAttendanceByStudent(String studentId) {
    return _box.values
        .where((attendance) => attendance.studentId == studentId)
        .toList();
  }

  // Get attendance for a specific course
  static List<Attendance> getAttendanceByCourse(String courseId) {
    return _box.values
        .where((attendance) => attendance.courseId == courseId)
        .toList();
  }

  // Get attendance for a specific date
  static List<Attendance> getAttendanceByDate(DateTime date) {
    return _box.values
        .where(
          (attendance) =>
              attendance.date.year == date.year &&
              attendance.date.month == date.month &&
              attendance.date.day == date.day,
        )
        .toList();
  }

  // Get attendance for a date range
  static List<Attendance> getAttendanceByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _box.values
        .where(
          (attendance) =>
              attendance.date.isAfter(start) && attendance.date.isBefore(end),
        )
        .toList();
  }

  // Get attendance statistics for a student
  static Map<String, dynamic> getStudentAttendanceStats(String studentId) {
    final studentAttendance = getAttendanceByStudent(studentId);
    final totalDays = studentAttendance.length;
    final presentDays = studentAttendance
        .where((attendance) => attendance.isPresent)
        .length;
    final absentDays = totalDays - presentDays;
    final attendancePercentage = totalDays > 0
        ? (presentDays / totalDays) * 100
        : 0;

    return {
      'totalDays': totalDays,
      'presentDays': presentDays,
      'absentDays': absentDays,
      'attendancePercentage': attendancePercentage,
    };
  }

  // Get attendance statistics for a course
  static Map<String, dynamic> getCourseAttendanceStats(String courseId) {
    final courseAttendance = getAttendanceByCourse(courseId);
    final totalDays = courseAttendance.length;
    final presentDays = courseAttendance
        .where((attendance) => attendance.isPresent)
        .length;
    final absentDays = totalDays - presentDays;
    final attendancePercentage = totalDays > 0
        ? (presentDays / totalDays) * 100
        : 0;

    return {
      'totalDays': totalDays,
      'presentDays': presentDays,
      'absentDays': absentDays,
      'attendancePercentage': attendancePercentage,
    };
  }

  // Mark attendance for multiple students
  static Future<void> markBulkAttendance(
    String courseId,
    DateTime date,
    Map<String, bool> studentAttendance,
    String? remarks,
  ) async {
    for (var entry in studentAttendance.entries) {
      final attendance = Attendance(
        id: '${entry.key}_${date.toIso8601String()}',
        studentId: entry.key,
        courseId: courseId,
        date: date,
        isPresent: entry.value,
        remarks: remarks,
        createdAt: DateTime.now(),
      );
      await addAttendance(attendance);
    }
  }

  // Get monthly attendance report
  static Map<String, dynamic> getMonthlyAttendanceReport(int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    final monthlyAttendance = getAttendanceByDateRange(startDate, endDate);

    final totalRecords = monthlyAttendance.length;
    final presentRecords = monthlyAttendance
        .where((attendance) => attendance.isPresent)
        .length;
    final absentRecords = totalRecords - presentRecords;
    final attendancePercentage = totalRecords > 0
        ? (presentRecords / totalRecords) * 100
        : 0;

    return {
      'year': year,
      'month': month,
      'totalRecords': totalRecords,
      'presentRecords': presentRecords,
      'absentRecords': absentRecords,
      'attendancePercentage': attendancePercentage,
      'attendanceData': monthlyAttendance,
    };
  }

  // Clear all attendance records
  static Future<void> clearAllAttendance() async {
    await _box.clear();
  }
}
