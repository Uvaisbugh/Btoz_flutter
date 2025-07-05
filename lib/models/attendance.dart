import 'package:hive/hive.dart';
part 'attendance.g.dart';

@HiveType(typeId: 2)
class Attendance extends HiveObject {
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

  Attendance({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.date,
    required this.isPresent,
  });
}
