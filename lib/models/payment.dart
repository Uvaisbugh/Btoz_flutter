import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 3)
class Payment {
  @HiveField(0)
  String id;

  @HiveField(1)
  String studentId;

  @HiveField(2)
  String courseId;

  @HiveField(3)
  double amount;

  @HiveField(4)
  String paymentMethod; // cash, card, bank_transfer, etc.

  @HiveField(5)
  String status; // pending, completed, failed, refunded

  @HiveField(6)
  DateTime paymentDate;

  @HiveField(7)
  String? transactionId;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  DateTime createdAt;

  Payment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.paymentDate,
    this.transactionId,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'paymentDate': paymentDate.toIso8601String(),
      'transactionId': transactionId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      studentId: map['studentId'],
      courseId: map['courseId'],
      amount: map['amount'].toDouble(),
      paymentMethod: map['paymentMethod'],
      status: map['status'],
      paymentDate: DateTime.parse(map['paymentDate']),
      transactionId: map['transactionId'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
