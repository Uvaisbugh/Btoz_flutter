import 'package:hive/hive.dart';
part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String course;
  @HiveField(4)
  int age;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.course,
    required this.age,
  });
}
