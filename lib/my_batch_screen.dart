import 'package:flutter/material.dart';

import 'app_data.dart';

class MyBatchScreen extends StatefulWidget {
  const MyBatchScreen({super.key});

  @override
  State<MyBatchScreen> createState() => _MyBatchScreenState();
}

class _MyBatchScreenState extends State<MyBatchScreen> {
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
      return buildPage(
        body: buildNoStudentState(),
      );
    }

    if (student.batchId.trim().isEmpty) {
      return buildPage(
        body: buildNoBatchState(),
      );
    }

    final BatchData? batch = appData.findBatchById(
      student.batchId,
    );

    if (batch == null) {
      return buildPage(
        body: buildNoBatchState(),
      );
    }

    final CourseData? course = appData.findCourseById(
      batch.courseId,
    );

    final TrainerData? trainer = appData.findTrainerById(
      batch.trainerId,
    );

    return buildPage(
      body: buildBatchContent(
        student: student,
        batch: batch,
        course: course,
        trainer: trainer,
      ),
    );
  }

  Widget buildPage({
    required Widget body,
  }) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'My Batch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: body,
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
                'Please log in again to view your batch.',
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

  Widget buildNoBatchState() {
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
                Icons.groups_outlined,
                size: 62,
                color: darkBlue,
              ),
              SizedBox(height: 16),
              Text(
                'No Batch Assigned',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your assigned batch will appear here after the admin assigns it.',
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

  Widget buildBatchContent({
    required StudentData student,
    required BatchData batch,
    required CourseData? course,
    required TrainerData? trainer,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBatchHeader(
            batch: batch,
          ),
          const SizedBox(height: 16),
          buildSectionCard(
            title: 'Batch Information',
            icon: Icons.info_outline,
            child: Column(
              children: [
                buildInformationRow(
                  icon: Icons.groups_outlined,
                  title: 'Batch Name',
                  value: batch.name,
                ),
                buildDivider(),
                buildInformationRow(
                  icon: Icons.menu_book_outlined,
                  title: 'Course',
                  value: course?.name ?? 'Not Assigned',
                ),
                buildDivider(),
                buildInformationRow(
                  icon: Icons.person_outline,
                  title: 'Trainer',
                  value: trainer?.name ?? 'Not Assigned',
                ),
                buildDivider(),
                buildInformationRow(
                  icon: Icons.access_time_outlined,
                  title: 'Batch Timing',
                  value: batch.timing,
                ),
                buildDivider(),
                buildInformationRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'Days',
                  value: batch.days,
                ),
                buildDivider(),
                buildInformationRow(
                  icon: Icons.meeting_room_outlined,
                  title: 'Room',
                  value: batch.room,
                ),
                buildDivider(),
                buildInformationRow(
                  icon: batch.isActive
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                  title: 'Status',
                  value: batch.isActive
                      ? 'Active'
                      : 'Inactive',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          buildSectionCard(
            title: 'Student Information',
            icon: Icons.badge_outlined,
            child: Column(
              children: [
                buildInformationRow(
                  icon: Icons.person_outline,
                  title: 'Student Name',
                  value: student.fullName,
                ),
                buildDivider(),
                buildInformationRow(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Student ID',
                  value: student.id,
                ),
                if (student.rollNumber.trim().isNotEmpty) ...[
                  buildDivider(),
                  buildInformationRow(
                    icon: Icons.badge_outlined,
                    title: 'Roll Number',
                    value: student.rollNumber,
                  ),
                ],
                if (student.joiningDate.trim().isNotEmpty) ...[
                  buildDivider(),
                  buildInformationRow(
                    icon: Icons.event_available_outlined,
                    title: 'Joining Date',
                    value: student.joiningDate,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBatchHeader({
    required BatchData batch,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.16,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.groups_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'YOUR BATCH',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFFBFE5E8),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            batch.name,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              buildHeaderChip(
                icon: Icons.access_time_outlined,
                text: batch.timing.trim().isEmpty
                    ? 'Timing Not Available'
                    : batch.timing,
              ),
              buildHeaderChip(
                icon: Icons.calendar_today_outlined,
                text: batch.days.trim().isEmpty
                    ? 'Days Not Available'
                    : batch.days,
              ),
              buildHeaderChip(
                icon: batch.isActive
                    ? Icons.check_circle_outline
                    : Icons.pause_circle_outline,
                text: batch.isActive
                    ? 'Active Batch'
                    : 'Inactive Batch',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.14,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget buildInformationRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final String displayValue = value.trim().isEmpty
        ? 'Not Assigned'
        : value;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Divider(
        height: 1,
        color: Color(0xFFEEF0F2),
      ),
    );
  }
}