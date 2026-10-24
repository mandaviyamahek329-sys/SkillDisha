import 'package:flutter/material.dart';

import 'app_data.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final AppData appData = AppData.instance;

  @override
  void initState() {
    super.initState();
    appData.addListener(handleDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(handleDataChanged);
    super.dispose();
  }

  void handleDataChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final StudentData? student = appData.currentStudentOrNull;

    if (student == null) {
      return buildStudentNotFoundScreen();
    }

    final List<ExamData> exams =
    appData.getExamsForStudent(student.id);

    final CourseData? course =
    appData.findCourseById(student.courseId);

    final BatchData? batch =
    appData.findBatchById(student.batchId);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildCourseHeader(
              course: course,
              batch: batch,
            ),
            Expanded(
              child: exams.isEmpty
                  ? buildEmptyState()
                  : buildExamList(exams),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold buildStudentNotFoundScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: buildAppBar(),
      body: const Center(
        child: Text(
          'Student Not Found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      foregroundColor: darkBlue,
      title: const Text(
        'Exams / Tests',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCourseHeader({
    required CourseData? course,
    required BatchData? batch,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.quiz_outlined,
                color: darkBlue,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course?.name ?? 'No Course Assigned',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    batch?.name ?? 'No Batch Assigned',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExamList(List<ExamData> exams) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ),
      itemCount: exams.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        return buildExamCard(exams[index]);
      },
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Exams Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Exams and tests scheduled for your course or batch will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExamCard(ExamData exam) {
    final ExamStatusInfo status = getExamStatus(exam.examDate);

    return Container(
      padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.quiz_outlined,
                  color: darkBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      exam.examType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: status.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.calendar_today_outlined,
            'Exam Date',
            exam.examDate,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.schedule_outlined,
            'Start Time',
            exam.startTime,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.timer_outlined,
            'Duration',
            exam.duration,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.grade_outlined,
            'Total Marks',
            exam.totalMarks,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.check_circle_outline,
            'Passing Marks',
            exam.passingMarks,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.groups_outlined,
            'Available For',
            exam.batchId.isEmpty
                ? 'All Batches'
                : appData.getBatchName(exam.batchId),
          ),
          if (exam.instructions.trim().isNotEmpty) ...[
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: darkBlue,
                ),
                SizedBox(width: 7),
                Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exam.instructions,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildInfoRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: darkBlue,
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.trim().isEmpty
                ? 'Not Available'
                : value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  ExamStatusInfo getExamStatus(String examDate) {
    final DateTime? date =
    DateTime.tryParse(examDate.trim());

    if (date == null) {
      return ExamStatusInfo(
        label: 'Scheduled',
        backgroundColor: teal.withValues(
          alpha: 0.12,
        ),
        textColor: darkBlue,
      );
    }

    final DateTime now = DateTime.now();

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime normalizedExamDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (normalizedExamDate.isBefore(today)) {
      return ExamStatusInfo(
        label: 'Completed',
        backgroundColor: Colors.grey.withValues(
          alpha: 0.12,
        ),
        textColor: Colors.grey.shade700,
      );
    }

    if (normalizedExamDate == today) {
      return ExamStatusInfo(
        label: 'Today',
        backgroundColor: Colors.orange.withValues(
          alpha: 0.12,
        ),
        textColor: Colors.orange.shade800,
      );
    }

    return ExamStatusInfo(
      label: 'Upcoming',
      backgroundColor: teal.withValues(
        alpha: 0.12,
      ),
      textColor: darkBlue,
    );
  }
}

class ExamStatusInfo {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  ExamStatusInfo({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
}