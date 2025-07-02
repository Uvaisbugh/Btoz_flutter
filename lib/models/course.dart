import 'package:hive/hive.dart';

part 'course.g.dart';

@HiveType(typeId: 1)
class Course {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  int duration; // in months

  @HiveField(4)
  double fee;

  @HiveField(5)
  String instructor;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime endDate;

  @HiveField(8)
  bool isActive;

  @HiveField(9)
  DateTime createdAt;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.fee,
    required this.instructor,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'fee': fee,
      'instructor': instructor,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      duration: map['duration'],
      fee: map['fee'].toDouble(),
      instructor: map['instructor'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
