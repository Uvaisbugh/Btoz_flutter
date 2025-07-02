import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/attendance.dart';
import '../models/payment.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Box<Student> _studentBox;
  late Box<Course> _courseBox;
  late Box<Attendance> _attendanceBox;
  late Box<Payment> _paymentBox;

  List<Student> _students = [];
  List<Course> _courses = [];
  List<Attendance> _attendanceRecords = [];
  List<Payment> _payments = [];

  final String _selectedPeriod = 'month';
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _studentBox = Hive.box<Student>('students');
    _courseBox = Hive.box<Course>('courses');
    _attendanceBox = Hive.box<Attendance>('attendance');
    _paymentBox = Hive.box<Payment>('payments');
    _loadData();
  }

  void _loadData() {
    setState(() {
      _students = _studentBox.values.toList();
      _courses = _courseBox.values.toList();
      _attendanceRecords = _attendanceBox.values.toList();
      _payments = _paymentBox.values.toList();
    });
  }

  Map<String, dynamic> _getOverallStats() {
    final totalStudents = _students.length;
    final totalCourses = _courses.length;
    final totalAttendance = _attendanceRecords.length;
    final totalRevenue = _payments
        .where((p) => p.status == 'Completed')
        .fold(0.0, (sum, p) => sum + p.amount);

    final activeStudents = _students.length;
    final activeCourses = _courses.where((c) => c.isActive).length;

    return {
      'totalStudents': totalStudents,
      'totalCourses': totalCourses,
      'totalAttendance': totalAttendance,
      'totalRevenue': totalRevenue,
      'activeStudents': activeStudents,
      'activeCourses': activeCourses,
    };
  }

  List<Map<String, dynamic>> _getRevenueData() {
    final now = DateTime.now();
    final months = <String, double>{};

    for (int i = 11; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthKey = DateFormat('MMM yyyy').format(date);
      months[monthKey] = 0.0;
    }

    for (var payment in _payments.where((p) => p.status == 'Completed')) {
      final monthKey = DateFormat('MMM yyyy').format(payment.paymentDate);
      if (months.containsKey(monthKey)) {
        months[monthKey] = months[monthKey]! + payment.amount;
      }
    }

    return months.entries
        .map((entry) => {'month': entry.key, 'revenue': entry.value})
        .toList();
  }

  List<Map<String, dynamic>> _getAttendanceData() {
    final courseAttendance = <String, int>{};

    for (var course in _courses) {
      final attendanceCount = _attendanceRecords
          .where((a) => a.courseId == course.id && a.isPresent)
          .length;
      courseAttendance[course.name] = attendanceCount;
    }

    return courseAttendance.entries
        .map((entry) => {'course': entry.key, 'attendance': entry.value})
        .toList();
  }

  List<Map<String, dynamic>> _getTopCourses() {
    final courseStats = <String, Map<String, dynamic>>{};

    for (var course in _courses) {
      final studentsInCourse = _students
          .where((s) => s.course == course.name)
          .length;
      final attendanceInCourse = _attendanceRecords
          .where((a) => a.courseId == course.id && a.isPresent)
          .length;

      courseStats[course.name] = {
        'name': course.name,
        'students': studentsInCourse,
        'attendance': attendanceInCourse,
        'revenue': _payments
            .where((p) => p.courseId == course.id && p.status == 'Completed')
            .fold(0.0, (sum, p) => sum + p.amount),
      };
    }

    final sortedCourses = courseStats.values.toList()
      ..sort(
        (a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double),
      );

    return sortedCourses.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getOverallStats();
    final revenueData = _getRevenueData();
    final attendanceData = _getAttendanceData();
    final topCourses = _getTopCourses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reports refreshed')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverallStatsCard(stats),
              const SizedBox(height: 24),
              _buildRevenueChart(revenueData),
              const SizedBox(height: 24),
              _buildAttendanceChart(attendanceData),
              const SizedBox(height: 24),
              _buildTopCoursesCard(topCourses),
              const SizedBox(height: 24),
              _buildRecentActivityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatsCard(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatItem(
                  'Total Students',
                  stats['totalStudents'].toString(),
                  Icons.people,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Total Courses',
                  stats['totalCourses'].toString(),
                  Icons.school,
                  Colors.green,
                ),
                _buildStatItem(
                  'Total Revenue',
                  '\$${NumberFormat('#,##0').format(stats['totalRevenue'])}',
                  Icons.attach_money,
                  Colors.purple,
                ),
                _buildStatItem(
                  'Attendance Records',
                  stats['totalAttendance'].toString(),
                  Icons.check_circle,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<Map<String, dynamic>> revenueData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend (Last 12 Months)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < revenueData.length) {
                            return Text(
                              revenueData[value.toInt()]['month'],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: revenueData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['revenue'],
                        );
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart(List<Map<String, dynamic>> attendanceData) {
    if (attendanceData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance by Course',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No attendance data available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance by Course',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: attendanceData.fold(
                    0.0,
                    (max, item) => item['attendance'] > max
                        ? item['attendance'].toDouble()
                        : max,
                  ),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < attendanceData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                attendanceData[value.toInt()]['course'],
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: attendanceData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value['attendance'].toDouble(),
                          color: Theme.of(context).primaryColor,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCoursesCard(List<Map<String, dynamic>> topCourses) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Performing Courses',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (topCourses.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No course data available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topCourses.length,
                itemBuilder: (context, index) {
                  final course = topCourses[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(course['name']),
                    subtitle: Text(
                      '${course['students']} students • ${course['attendance']} attendance records',
                    ),
                    trailing: Text(
                      '\$${NumberFormat('#,##0').format(course['revenue'])}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    final recentPayments =
        _payments.where((p) => p.status == 'Completed').toList()
          ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

    final recentAttendance = _attendanceRecords.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (recentPayments.isEmpty && recentAttendance.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No recent activity',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  if (recentPayments.isNotEmpty) ...[
                    const Text(
                      'Recent Payments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...recentPayments.take(3).map((payment) {
                      final student = _students.firstWhere(
                        (s) => s.id == payment.studentId,
                        orElse: () => Student(
                          id: '',
                          name: 'Unknown Student',
                          email: '',
                          phone: '',
                          course: '',
                          age: 0,
                          createdAt: DateTime.now(),
                        ),
                      );
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.payment, color: Colors.green),
                        title: Text(student.name),
                        subtitle: Text(
                          DateFormat(
                            'MMM dd, yyyy',
                          ).format(payment.paymentDate),
                        ),
                        trailing: Text(
                          '\$${payment.amount}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                  if (recentAttendance.isNotEmpty) ...[
                    const Text(
                      'Recent Attendance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...recentAttendance.take(3).map((attendance) {
                      final student = _students.firstWhere(
                        (s) => s.id == attendance.studentId,
                        orElse: () => Student(
                          id: '',
                          name: 'Unknown Student',
                          email: '',
                          phone: '',
                          course: '',
                          age: 0,
                          createdAt: DateTime.now(),
                        ),
                      );
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          attendance.isPresent
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: attendance.isPresent
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(student.name),
                        subtitle: Text(
                          DateFormat('MMM dd, yyyy').format(attendance.date),
                        ),
                        trailing: Text(
                          attendance.isPresent ? 'Present' : 'Absent',
                          style: TextStyle(
                            color: attendance.isPresent
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
