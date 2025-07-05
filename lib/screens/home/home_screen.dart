import 'package:flutter/material.dart';
import '../students/students_screen.dart';
import '../courses/courses_screen.dart';
import '../attendance/attendance_screen.dart';
import '../admin/admin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Flutter Academy', style: TextStyle(fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Students'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Courses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CoursesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Attendance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Welcome to the Home Dashboard!')),
    );
  }
}
