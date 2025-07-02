import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/attendance.dart';
import '../models/student.dart';
import '../models/course.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Box<Attendance> _attendanceBox;
  late Box<Student> _studentBox;
  late Box<Course> _courseBox;
  List<Attendance> _attendanceRecords = [];
  List<Student> _students = [];
  List<Course> _courses = [];
  String _search = '';
  String _selectedCourse = '';
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _attendanceBox = Hive.box<Attendance>('attendance');
    _studentBox = Hive.box<Student>('students');
    _courseBox = Hive.box<Course>('courses');
    _loadData();
  }

  void _loadData() {
    setState(() {
      _students = _studentBox.values.toList();
      _courses = _courseBox.values.toList();
      _loadAttendanceRecords();
    });
  }

  void _loadAttendanceRecords() {
    setState(() {
      _attendanceRecords = _attendanceBox.values.where((a) {
        final matchesSearch =
            _search.isEmpty ||
            _getStudentName(
              a.studentId,
            ).toLowerCase().contains(_search.toLowerCase()) ||
            _getCourseName(
              a.courseId,
            ).toLowerCase().contains(_search.toLowerCase());

        final matchesCourse =
            _selectedCourse.isEmpty || a.courseId == _selectedCourse;

        final matchesDate =
            DateFormat('yyyy-MM-dd').format(a.date) ==
            DateFormat('yyyy-MM-dd').format(_selectedDate);

        return matchesSearch && matchesCourse && matchesDate;
      }).toList();
    });
  }

  String _getStudentName(String studentId) {
    final student = _students.firstWhere(
      (s) => s.id == studentId,
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
    return student.name;
  }

  String _getCourseName(String courseId) {
    final course = _courses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => Course(
        id: '',
        name: 'Unknown Course',
        description: '',
        duration: 0,
        fee: 0,
        instructor: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
    return course.name;
  }

  void _showTakeAttendanceDialog() {
    if (_courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add courses first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    String selectedCourseId = _courses.first.id;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Take Attendance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCourseId,
                decoration: const InputDecoration(
                  labelText: 'Select Course',
                  prefixIcon: Icon(Icons.school),
                ),
                items: _courses.map((course) {
                  return DropdownMenuItem(
                    value: course.id,
                    child: Text(course.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedCourseId = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 30),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 7)),
                  );
                  if (date != null) {
                    setDialogState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAttendanceSheet(selectedCourseId, selectedDate);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceSheet(String courseId, DateTime date) {
    final courseStudents = _students
        .where((s) => s.course == _getCourseName(courseId))
        .toList();

    if (courseStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No students enrolled in this course'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Map<String, bool> attendanceMap = {};
    for (var student in courseStudents) {
      attendanceMap[student.id] = true; // Default to present
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Attendance for ${_getCourseName(courseId)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(date),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: courseStudents.length,
                  itemBuilder: (context, index) {
                    final student = courseStudents[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            student.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(student.name),
                        subtitle: Text(student.email),
                        trailing: Switch(
                          value: attendanceMap[student.id] ?? true,
                          onChanged: (value) {
                            setSheetState(() {
                              attendanceMap[student.id] = value;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveAttendance(courseId, date, attendanceMap);
                        Navigator.pop(context);
                      },
                      child: const Text('Save Attendance'),
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

  void _saveAttendance(
    String courseId,
    DateTime date,
    Map<String, bool> attendanceMap,
  ) {
    for (var entry in attendanceMap.entries) {
      final attendance = Attendance(
        id: _uuid.v4(),
        studentId: entry.key,
        courseId: courseId,
        date: date,
        isPresent: entry.value,
        remarks: entry.value ? 'Present' : 'Absent',
        createdAt: DateTime.now(),
      );
      _attendanceBox.add(attendance);
    }

    _loadAttendanceRecords();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved for ${attendanceMap.length} students'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteDialog(Attendance attendance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attendance Record'),
        content: Text(
          'Are you sure you want to delete this attendance record for ${_getStudentName(attendance.studentId)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final key = _attendanceBox.keys.firstWhere(
                (k) => _attendanceBox.get(k)?.id == attendance.id,
                orElse: () => null,
              );
              if (key != null) {
                _attendanceBox.delete(key);
              }
              _loadAttendanceRecords();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance record deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attendance refreshed')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search attendance...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _search.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _search = '';
                                  _loadAttendanceRecords();
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _search = value;
                        _loadAttendanceRecords();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Course Filter
                  DropdownButtonFormField<String>(
                    value: _selectedCourse.isEmpty ? null : _selectedCourse,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Course',
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('All Courses'),
                      ),
                      ..._courses.map((course) {
                        return DropdownMenuItem(
                          value: course.id,
                          child: Text(course.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value ?? '';
                        _loadAttendanceRecords();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date Filter
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(_selectedDate),
                    ),
                    leading: const Icon(Icons.calendar_today),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          _loadAttendanceRecords();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Attendance Records
          Expanded(
            child: _attendanceRecords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No attendance records found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take attendance for your students',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final attendance = _attendanceRecords[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: attendance.isPresent
                                ? Colors.green
                                : Colors.red,
                            child: Icon(
                              attendance.isPresent ? Icons.check : Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(_getStudentName(attendance.studentId)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_getCourseName(attendance.courseId)),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(attendance.date),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _showDeleteDialog(attendance);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTakeAttendanceDialog,
        icon: const Icon(Icons.add),
        label: const Text('Take Attendance'),
      ),
    );
  }
}
