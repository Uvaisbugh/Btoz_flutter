import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/attendance.dart';
import '../models/payment.dart';
import 'students.dart';

class CupertinoHomeScreen extends StatelessWidget {
  const CupertinoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.check_mark_circled),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const _CupertinoHomeTab();
          case 1:
            return StudentsScreen();
          default:
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(_tabTitle(index)),
              ),
              child: Center(child: Text('${_tabTitle(index)} coming soon!')),
            );
        }
      },
    );
  }

  String _tabTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Students';
      case 2:
        return 'Courses';
      case 3:
        return 'Attendance';
      case 4:
        return 'Reports';
      case 5:
        return 'Profile';
      case 6:
        return 'Settings';
      default:
        return '';
    }
  }
}

class _CupertinoHomeTab extends StatefulWidget {
  const _CupertinoHomeTab();

  @override
  State<_CupertinoHomeTab> createState() => _CupertinoHomeTabState();
}

class _CupertinoHomeTabState extends State<_CupertinoHomeTab> {
  int totalStudents = 0;
  int totalCourses = 0;
  int totalAttendance = 0;
  double totalRevenue = 0.0;
  List<Student> recentStudents = [];
  List<Course> recentCourses = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final studentBox = Hive.box<Student>('students');
    final courseBox = Hive.box<Course>('courses');
    final attendanceBox = Hive.box<Attendance>('attendance');
    final paymentBox = Hive.box<Payment>('payments');

    setState(() {
      totalStudents = studentBox.length;
      totalCourses = courseBox.length;
      totalAttendance = attendanceBox.length;
      totalRevenue = paymentBox.values
          .where((p) => p.status == 'Completed')
          .fold(0.0, (sum, p) => sum + p.amount);

      recentStudents = studentBox.values.toList().take(3).toList();

      recentCourses = courseBox.values.toList().take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Dashboard')),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      CupertinoColors.systemBlue,
                      CupertinoColors.systemIndigo,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.book_fill,
                      color: CupertinoColors.white,
                      size: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to BTOZ Academy',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your educational institution',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistics Section
              const Text(
                'Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Statistics Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Students',
                      totalStudents.toString(),
                      CupertinoIcons.person_2,
                      CupertinoColors.systemBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Courses',
                      totalCourses.toString(),
                      CupertinoIcons.book,
                      CupertinoColors.systemGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Attendance',
                      totalAttendance.toString(),
                      CupertinoIcons.check_mark_circled,
                      CupertinoColors.systemOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Revenue',
                      '\$${totalRevenue.toStringAsFixed(0)}',
                      CupertinoIcons.money_dollar,
                      CupertinoColors.systemPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Students
              const Text(
                'Recent Students',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              if (recentStudents.isNotEmpty)
                CupertinoListSection.insetGrouped(
                  children: recentStudents
                      .map(
                        (student) => CupertinoListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: CupertinoColors.systemBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                student.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(student.name),
                          subtitle: Text(
                            '${student.course} • ${student.email}',
                          ),
                          trailing: const Icon(CupertinoIcons.chevron_right),
                        ),
                      )
                      .toList(),
                )
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No students yet',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Recent Courses
              const Text(
                'Recent Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              if (recentCourses.isNotEmpty)
                CupertinoListSection.insetGrouped(
                  children: recentCourses
                      .map(
                        (course) => CupertinoListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: CupertinoColors.systemGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.book,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          title: Text(course.name),
                          subtitle: Text(
                            '${course.duration} months • \$${course.fee}',
                          ),
                          trailing: const Icon(CupertinoIcons.chevron_right),
                        ),
                      )
                      .toList(),
                )
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No courses yet',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Add Student',
                      CupertinoIcons.person_add,
                      CupertinoColors.systemBlue,
                      () => _navigateToTab(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      'Add Course',
                      CupertinoIcons.book_fill,
                      CupertinoColors.systemGreen,
                      () => _navigateToTab(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Take Attendance',
                      CupertinoIcons.check_mark_circled_solid,
                      CupertinoColors.systemOrange,
                      () => _navigateToTab(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      'View Reports',
                      CupertinoIcons.chart_bar,
                      CupertinoColors.systemPurple,
                      () => _navigateToTab(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(int index) {
    // This would need to be implemented to switch tabs
    // For now, we'll just show a dialog
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Navigation'),
        content: const Text('This would navigate to the selected tab.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
