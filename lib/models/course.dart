import 'package:hive/hive.dart';
part 'course.g.dart';

@HiveType(typeId: 1)
class Course extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String instructor;
  @HiveField(4)
  int duration;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.instructor,
    required this.duration,
  });
}
