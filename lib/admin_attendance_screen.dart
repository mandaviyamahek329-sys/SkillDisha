import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  State<AdminAttendanceScreen> createState() =>
      _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState
    extends State<AdminAttendanceScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor = Color(0xFFF6F8FA);

  final AppData appData = AppData.instance;

  String? selectedCourseId;
  String? selectedBatchId;

  DateTime selectedDate = DateTime.now();

  final Map<String, String> attendanceStatus = {};
  final Map<String, TextEditingController> remarksControllers = {};

  @override
  void initState() {
    super.initState();
    appData.addListener(refreshScreen);
  }

  @override
  void dispose() {
    appData.removeListener(refreshScreen);

    for (final TextEditingController controller
    in remarksControllers.values) {
      controller.dispose();
    }

    remarksControllers.clear();

    super.dispose();
  }

  void refreshScreen() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<CourseData> activeCourses = appData.courses
        .where(
          (CourseData course) => course.isActive,
    )
        .toList();

    final List<BatchData> availableBatches =
    selectedCourseId == null
        ? <BatchData>[]
        : appData.getBatchesByCourse(
      selectedCourseId!,
    );

    final List<StudentData> batchStudents =
    getSelectedBatchStudents();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Manage Attendance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            const SizedBox(height: 16),
            buildSelectionCard(
              activeCourses: activeCourses,
              availableBatches: availableBatches,
            ),
            const SizedBox(height: 18),
            if (selectedBatchId != null)
              buildStudentSection(
                batchStudents,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            darkBlue,
            Color(0xFF0A6A8F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x22FFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Icon(
                Icons.fact_check_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Attendance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Select a batch and mark attendance for each student.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFFE5F4F5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectionCard({
    required List<CourseData> activeCourses,
    required List<BatchData> availableBatches,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(
            icon: Icons.tune_outlined,
            title: 'Attendance Details',
          ),
          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            initialValue: selectedCourseId,
            isExpanded: true,
            decoration: buildInputDecoration(
              label: 'Course',
              icon: Icons.menu_book_outlined,
            ),
            hint: const Text(
              'Select Course',
            ),
            items: activeCourses.map(
                  (CourseData course) {
                return DropdownMenuItem<String>(
                  value: course.id,
                  child: Text(
                    course.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
            onChanged: (String? value) {
              clearStudentControllers();

              setState(() {
                selectedCourseId = value;
                selectedBatchId = null;
                attendanceStatus.clear();
              });
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: selectedBatchId,
            isExpanded: true,
            decoration: buildInputDecoration(
              label: 'Batch',
              icon: Icons.groups_outlined,
            ),
            hint: const Text(
              'Select Batch',
            ),
            items: availableBatches.map(
                  (BatchData batch) {
                return DropdownMenuItem<String>(
                  value: batch.id,
                  child: Text(
                    batch.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
            onChanged: selectedCourseId == null
                ? null
                : (String? value) {
              clearStudentControllers();

              setState(() {
                selectedBatchId = value;
                attendanceStatus.clear();
              });

              loadExistingAttendance();
            },
          ),

          const SizedBox(height: 14),

          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: selectAttendanceDate,
            child: InputDecorator(
              decoration: buildInputDecoration(
                label: 'Attendance Date',
                icon: Icons.calendar_today_outlined,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatDisplayDate(
                        selectedDate,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentSection(
      List<StudentData> students,
      ) {
    if (students.isEmpty) {
      return buildEmptyStudentsCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Students',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${students.length} Students',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        buildQuickActions(
          students,
        ),

        const SizedBox(height: 12),

        ...students.map(
              (StudentData student) {
            return buildStudentCard(
              student,
            );
          },
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              saveAttendance(
                students,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(
              Icons.save_outlined,
            ),
            label: const Text(
              'Save Attendance',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildQuickActions(
      List<StudentData> students,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Quick Mark',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setAllAttendance(
                students,
                'Present',
              );
            },
            child: const Text(
              'All Present',
            ),
          ),
          TextButton(
            onPressed: () {
              setAllAttendance(
                students,
                'Absent',
              );
            },
            child: const Text(
              'All Absent',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentCard(
      StudentData student,
      ) {
    final String selectedStatus =
        attendanceStatus[student.id] ?? '';

    final TextEditingController remarksController =
    getRemarksController(
      student.id,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getStudentInitials(
                    student.fullName,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      student.rollNumber.trim().isEmpty
                          ? student.id
                          : '${student.id} • ${student.rollNumber}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Text(
            'Attendance Status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              Expanded(
                child: buildStatusButton(
                  studentId: student.id,
                  title: 'Present',
                  icon: Icons.check_circle_outline,
                  selectedStatus: selectedStatus,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: buildStatusButton(
                  studentId: student.id,
                  title: 'Absent',
                  icon: Icons.cancel_outlined,
                  selectedStatus: selectedStatus,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: buildStatusButton(
                  studentId: student.id,
                  title: 'Late',
                  icon: Icons.access_time_outlined,
                  selectedStatus: selectedStatus,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          TextField(
            controller: remarksController,
            maxLines: 2,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Remarks',
              hintText: 'Optional remarks',
              prefixIcon: const Icon(
                Icons.notes_outlined,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFD1D5DB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: teal,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusButton({
    required String studentId,
    required String title,
    required IconData icon,
    required String selectedStatus,
  }) {
    final bool isSelected = selectedStatus == title;

    return InkWell(
      borderRadius: BorderRadius.circular(11),
      onTap: () {
        setState(() {
          attendanceStatus[studentId] = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 160,
        ),
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? darkBlue
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isSelected
                ? darkBlue
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected
                  ? Colors.white
                  : darkBlue,
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF374151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyStudentsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 55,
            color: darkBlue,
          ),
          SizedBox(height: 14),
          Text(
            'No Students Found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 7),
          Text(
            'No students are assigned to this batch.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F5),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 20,
            color: darkBlue,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD1D5DB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
    );
  }

  List<StudentData> getSelectedBatchStudents() {
    if (selectedBatchId == null) {
      return <StudentData>[];
    }

    final List<StudentData> students = appData.students
        .where(
          (StudentData student) =>
      student.batchId == selectedBatchId &&
          student.isActive,
    )
        .toList();

    students.sort(
          (StudentData a, StudentData b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return students;
  }

  TextEditingController getRemarksController(
      String studentId,
      ) {
    return remarksControllers.putIfAbsent(
      studentId,
          () => TextEditingController(),
    );
  }

  void clearStudentControllers() {
    for (final TextEditingController controller
    in remarksControllers.values) {
      controller.dispose();
    }

    remarksControllers.clear();
  }

  Future<void> selectAttendanceDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) {
      return;
    }

    clearStudentControllers();

    setState(() {
      selectedDate = date;
      attendanceStatus.clear();
    });

    loadExistingAttendance();
  }

  void loadExistingAttendance() {
    if (selectedBatchId == null) {
      return;
    }

    final List<StudentData> students =
    getSelectedBatchStudents();

    final String date = formatStorageDate(
      selectedDate,
    );

    for (final StudentData student in students) {
      final AttendanceRecordData? record =
      appData.findAttendanceRecord(
        studentId: student.id,
        date: date,
      );

      if (record != null) {
        attendanceStatus[student.id] =
            record.status;

        getRemarksController(
          student.id,
        ).text = record.remarks;
      } else {
        attendanceStatus.remove(
          student.id,
        );

        getRemarksController(
          student.id,
        ).clear();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void setAllAttendance(
      List<StudentData> students,
      String status,
      ) {
    setState(() {
      for (final StudentData student in students) {
        attendanceStatus[student.id] = status;
      }
    });
  }

  void saveAttendance(
      List<StudentData> students,
      ) {
    if (selectedCourseId == null) {
      showMessage(
        'Please select a course.',
      );
      return;
    }

    if (selectedBatchId == null) {
      showMessage(
        'Please select a batch.',
      );
      return;
    }

    if (students.isEmpty) {
      showMessage(
        'No students are assigned to this batch.',
      );
      return;
    }

    final bool hasUnmarkedStudent = students.any(
          (StudentData student) {
        final String status =
            attendanceStatus[student.id] ?? '';

        return status.trim().isEmpty;
      },
    );

    if (hasUnmarkedStudent) {
      showMessage(
        'Please mark attendance for every student.',
      );
      return;
    }

    final String date = formatStorageDate(
      selectedDate,
    );

    for (final StudentData student in students) {
      final String status =
      attendanceStatus[student.id]!;

      final String remarks =
      getRemarksController(
        student.id,
      ).text.trim();

      appData.addAttendanceRecord(
        studentId: student.id,
        date: date,
        status: status,
        remarks: remarks,
      );
    }

    showMessage(
      'Attendance saved successfully.',
    );
  }

  String formatStorageDate(
      DateTime date,
      ) {
    final String month =
    date.month.toString().padLeft(2, '0');

    final String day =
    date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String formatDisplayDate(
      DateTime date,
      ) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  String getStudentInitials(
      String name,
      ) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where(
          (String part) => part.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return 'S';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
        '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  void showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}