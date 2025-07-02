import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String course;

  @HiveField(5)
  int age;

  @HiveField(6)
  DateTime createdAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.age,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'course': course,
      'age': age,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      course: map['course'],
      age: map['age'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
