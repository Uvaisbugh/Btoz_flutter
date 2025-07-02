import 'package:hive/hive.dart';
import 'package:btoz/models/payment.dart';

class PaymentService {
  static const String _boxName = 'payments';

  static Box<Payment> get _box => Hive.box<Payment>(_boxName);

  // Create - Add a new payment
  static Future<void> addPayment(Payment payment) async {
    await _box.put(payment.id, payment);
  }

  // Read - Get all payments
  static List<Payment> getAllPayments() {
    return _box.values.toList();
  }

  // Read - Get payment by ID
  static Payment? getPaymentById(String id) {
    return _box.get(id);
  }

  // Update - Update existing payment
  static Future<void> updatePayment(Payment payment) async {
    await _box.put(payment.id, payment);
  }

  // Delete - Delete payment by ID
  static Future<void> deletePayment(String id) async {
    await _box.delete(id);
  }

  // Get payments for a specific student
  static List<Payment> getPaymentsByStudent(String studentId) {
    return _box.values
        .where((payment) => payment.studentId == studentId)
        .toList();
  }

  // Get payments for a specific course
  static List<Payment> getPaymentsByCourse(String courseId) {
    return _box.values
        .where((payment) => payment.courseId == courseId)
        .toList();
  }

  // Get payments by status
  static List<Payment> getPaymentsByStatus(String status) {
    return _box.values.where((payment) => payment.status == status).toList();
  }

  // Get payments by payment method
  static List<Payment> getPaymentsByMethod(String method) {
    return _box.values
        .where((payment) => payment.paymentMethod == method)
        .toList();
  }

  // Get payments within date range
  static List<Payment> getPaymentsByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where(
          (payment) =>
              payment.paymentDate.isAfter(start) &&
              payment.paymentDate.isBefore(end),
        )
        .toList();
  }

  // Get payment statistics for a student
  static Map<String, dynamic> getStudentPaymentStats(String studentId) {
    final studentPayments = getPaymentsByStudent(studentId);
    final totalAmount = studentPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final completedPayments = studentPayments
        .where((payment) => payment.status == 'completed')
        .toList();
    final completedAmount = completedPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final pendingPayments = studentPayments
        .where((payment) => payment.status == 'pending')
        .toList();
    final pendingAmount = pendingPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    return {
      'totalPayments': studentPayments.length,
      'totalAmount': totalAmount,
      'completedPayments': completedPayments.length,
      'completedAmount': completedAmount,
      'pendingPayments': pendingPayments.length,
      'pendingAmount': pendingAmount,
      'paymentHistory': studentPayments,
    };
  }

  // Get payment statistics for a course
  static Map<String, dynamic> getCoursePaymentStats(String courseId) {
    final coursePayments = getPaymentsByCourse(courseId);
    final totalAmount = coursePayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final completedPayments = coursePayments
        .where((payment) => payment.status == 'completed')
        .toList();
    final completedAmount = completedPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final pendingPayments = coursePayments
        .where((payment) => payment.status == 'pending')
        .toList();
    final pendingAmount = pendingPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    return {
      'totalPayments': coursePayments.length,
      'totalAmount': totalAmount,
      'completedPayments': completedPayments.length,
      'completedAmount': completedAmount,
      'pendingPayments': pendingPayments.length,
      'pendingAmount': pendingAmount,
      'paymentHistory': coursePayments,
    };
  }

  // Get overall payment statistics
  static Map<String, dynamic> getOverallPaymentStats() {
    final allPayments = getAllPayments();
    final totalAmount = allPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final completedPayments = allPayments
        .where((payment) => payment.status == 'completed')
        .toList();
    final completedAmount = completedPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final pendingPayments = allPayments
        .where((payment) => payment.status == 'pending')
        .toList();
    final pendingAmount = pendingPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    // Group by payment method
    final methodStats = <String, double>{};
    for (var payment in allPayments) {
      methodStats[payment.paymentMethod] =
          (methodStats[payment.paymentMethod] ?? 0) + payment.amount;
    }

    return {
      'totalPayments': allPayments.length,
      'totalAmount': totalAmount,
      'completedPayments': completedPayments.length,
      'completedAmount': completedAmount,
      'pendingPayments': pendingPayments.length,
      'pendingAmount': pendingAmount,
      'methodStats': methodStats,
    };
  }

  // Get monthly payment report
  static Map<String, dynamic> getMonthlyPaymentReport(int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    final monthlyPayments = getPaymentsByDateRange(startDate, endDate);

    final totalAmount = monthlyPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final completedPayments = monthlyPayments
        .where((payment) => payment.status == 'completed')
        .toList();
    final completedAmount = completedPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    return {
      'year': year,
      'month': month,
      'totalPayments': monthlyPayments.length,
      'totalAmount': totalAmount,
      'completedPayments': completedPayments.length,
      'completedAmount': completedAmount,
      'paymentData': monthlyPayments,
    };
  }

  // Search payments by transaction ID
  static List<Payment> searchPaymentsByTransactionId(String transactionId) {
    return _box.values
        .where(
          (payment) =>
              payment.transactionId?.toLowerCase().contains(
                transactionId.toLowerCase(),
              ) ??
              false,
        )
        .toList();
  }

  // Clear all payments
  static Future<void> clearAllPayments() async {
    await _box.clear();
  }
}
