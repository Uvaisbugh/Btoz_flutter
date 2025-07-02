import 'package:hive/hive.dart';
part 'attendance.g.dart';

@HiveType(typeId: 2)
class Attendance {
  @HiveField(0)
  String id;

  @HiveField(1)
  String studentId;

  @HiveField(2)
  String courseId;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  bool isPresent;

  @HiveField(5)
  String? remarks;

  @HiveField(6)
  DateTime createdAt;

  Attendance({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.date,
    required this.isPresent,
    this.remarks,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'remarks': remarks,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['studentId'],
      courseId: map['courseId'],
      date: DateTime.parse(map['date']),
      isPresent: map['isPresent'],
      remarks: map['remarks'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
