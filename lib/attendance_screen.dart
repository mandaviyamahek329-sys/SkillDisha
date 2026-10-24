import 'package:flutter/material.dart';

import 'app_data.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor = Color(0xFFF6F8FA);

  final AppData appData = AppData.instance;

  @override
  void initState() {
    super.initState();
    appData.addListener(refreshScreen);
  }

  @override
  void dispose() {
    appData.removeListener(refreshScreen);
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
    final StudentData? student = appData.currentStudentOrNull;

    if (student == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: buildAppBar(),
        body: buildNoStudentState(),
      );
    }

    final List<AttendanceRecordData> records =
    appData.getAttendanceByStudent(
      student.id,
    );

    final int totalClasses = records.length;

    final int presentClasses = records.where(
          (record) {
        final String status = record.status.toLowerCase();

        return status == 'present' || status == 'late';
      },
    ).length;

    final int absentClasses = records.where(
          (record) {
        return record.status.toLowerCase() == 'absent';
      },
    ).length;

    final int lateClasses = records.where(
          (record) {
        return record.status.toLowerCase() == 'late';
      },
    ).length;

    final double attendancePercentage = totalClasses == 0
        ? 0
        : (presentClasses / totalClasses) * 100;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(),
      body: RefreshIndicator(
        color: darkBlue,
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAttendanceHeader(
                percentage: attendancePercentage,
                totalClasses: totalClasses,
              ),
              const SizedBox(height: 16),
              buildSummarySection(
                totalClasses: totalClasses,
                presentClasses: presentClasses,
                absentClasses: absentClasses,
                lateClasses: lateClasses,
              ),
              const SizedBox(height: 18),
              const Text(
                'Attendance History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              if (records.isEmpty)
                buildNoAttendanceState()
              else
                ...records.map(
                      (record) => buildAttendanceCard(record),
                ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: darkBlue,
      elevation: 0,
      title: const Text(
        'Attendance',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildNoStudentState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 34,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline,
                size: 62,
                color: darkBlue,
              ),
              SizedBox(height: 16),
              Text(
                'Student Not Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please log in again to view your attendance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAttendanceHeader({
    required double percentage,
    required int totalClasses,
  }) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 82,
                  height: 82,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(
                      alpha: 0.18,
                    ),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      teal,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  totalClasses == 0
                      ? 'No attendance has been recorded yet.'
                      : 'Your current attendance percentage is ${percentage.toStringAsFixed(0)}%.',
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
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

  Widget buildSummarySection({
    required int totalClasses,
    required int presentClasses,
    required int absentClasses,
    required int lateClasses,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildSummaryCard(
                icon: Icons.calendar_month_outlined,
                title: 'Total',
                value: totalClasses.toString(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildSummaryCard(
                icon: Icons.check_circle_outline,
                title: 'Present',
                value: presentClasses.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: buildSummaryCard(
                icon: Icons.cancel_outlined,
                title: 'Absent',
                value: absentClasses.toString(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildSummaryCard(
                icon: Icons.access_time_outlined,
                title: 'Late',
                value: lateClasses.toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: darkBlue,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
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
    );
  }

  Widget buildNoAttendanceState() {
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
            Icons.fact_check_outlined,
            size: 54,
            color: Color(0xFF075273),
          ),
          SizedBox(height: 14),
          Text(
            'No Attendance Recorded',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Your attendance records will appear here after they are marked by the admin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAttendanceCard(
      AttendanceRecordData record,
      ) {
    final String normalizedStatus =
    record.status.trim().toLowerCase();

    IconData statusIcon = Icons.help_outline;
    String statusText = record.status;

    if (normalizedStatus == 'present') {
      statusIcon = Icons.check_circle_outline;
      statusText = 'Present';
    } else if (normalizedStatus == 'absent') {
      statusIcon = Icons.cancel_outlined;
      statusText = 'Absent';
    } else if (normalizedStatus == 'late') {
      statusIcon = Icons.access_time_outlined;
      statusText = 'Late';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusIcon,
              color: darkBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDate(record.date),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    buildStatusBadge(
                      statusText,
                    ),
                  ],
                ),
                if (record.remarks.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    record.remarks,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusBadge(
      String status,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
    );
  }

  String formatDate(
      String value,
      ) {
    if (value.trim().isEmpty) {
      return 'Date Not Available';
    }

    try {
      final DateTime date = DateTime.parse(
        value.trim(),
      );

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

      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return value;
    }
  }
}