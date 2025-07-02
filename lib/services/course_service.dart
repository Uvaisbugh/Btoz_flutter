import 'package:hive/hive.dart';
import 'package:btoz/models/course.dart';

class CourseService {
  static const String _boxName = 'courses';

  static Box<Course> get _box => Hive.box<Course>(_boxName);

  // Create - Add a new course
  static Future<void> addCourse(Course course) async {
    await _box.put(course.id, course);
  }

  // Read - Get all courses
  static List<Course> getAllCourses() {
    return _box.values.toList();
  }

  // Read - Get active courses only
  static List<Course> getActiveCourses() {
    return _box.values.where((course) => course.isActive).toList();
  }

  // Read - Get course by ID
  static Course? getCourseById(String id) {
    return _box.get(id);
  }

  // Update - Update existing course
  static Future<void> updateCourse(Course course) async {
    await _box.put(course.id, course);
  }

  // Delete - Delete course by ID
  static Future<void> deleteCourse(String id) async {
    await _box.delete(id);
  }

  // Search courses by name
  static List<Course> searchCoursesByName(String query) {
    final allCourses = getAllCourses();
    return allCourses
        .where(
          (course) => course.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Get courses by instructor
  static List<Course> getCoursesByInstructor(String instructor) {
    final allCourses = getAllCourses();
    return allCourses
        .where(
          (course) => course.instructor.toLowerCase().contains(
            instructor.toLowerCase(),
          ),
        )
        .toList();
  }

  // Get courses within date range
  static List<Course> getCoursesInDateRange(DateTime start, DateTime end) {
    final allCourses = getAllCourses();
    return allCourses
        .where(
          (course) =>
              course.startDate.isAfter(start) && course.endDate.isBefore(end),
        )
        .toList();
  }

  // Get upcoming courses
  static List<Course> getUpcomingCourses() {
    final now = DateTime.now();
    final allCourses = getAllCourses();
    return allCourses
        .where((course) => course.startDate.isAfter(now) && course.isActive)
        .toList();
  }

  // Get ongoing courses
  static List<Course> getOngoingCourses() {
    final now = DateTime.now();
    final allCourses = getAllCourses();
    return allCourses
        .where(
          (course) =>
              course.startDate.isBefore(now) &&
              course.endDate.isAfter(now) &&
              course.isActive,
        )
        .toList();
  }

  // Clear all courses
  static Future<void> clearAllCourses() async {
    await _box.clear();
  }
}
