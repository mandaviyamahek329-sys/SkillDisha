import 'package:flutter/material.dart';

import 'app_data.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() =>
      _AssignmentsScreenState();
}

class _AssignmentsScreenState
    extends State<AssignmentsScreen> {
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
    final StudentData? student =
        appData.currentStudentOrNull;

    if (student == null) {
      return buildStudentNotFoundScreen();
    }

    final List<AssignmentData> assignments =
    appData.getAssignmentsForStudent(
      student.id,
    );

    final CourseData? course =
    appData.findCourseById(
      student.courseId,
    );

    final BatchData? batch =
    appData.findBatchById(
      student.batchId,
    );

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
              child: assignments.isEmpty
                  ? buildEmptyState()
                  : buildAssignmentList(
                assignments,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStudentNotFoundScreen() {
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
        'Assignments',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: darkBlue,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    course?.name ??
                        'No Course Assigned',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    batch?.name ??
                        'No Batch Assigned',
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

  Widget buildAssignmentList(
      List<AssignmentData> assignments,
      ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ),
      itemCount: assignments.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        return buildAssignmentCard(
          assignments[index],
        );
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
                Icons.assignment_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Assignments Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Assignments added for your course or batch will appear here.',
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

  Widget buildAssignmentCard(
      AssignmentData assignment,
      ) {
    final bool overdue =
    isAssignmentOverdue(
      assignment.dueDate,
    );

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
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: darkBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: overdue
                            ? Colors.red.withValues(
                          alpha: 0.08,
                        )
                            : teal.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Text(
                        overdue
                            ? 'Overdue'
                            : 'Active',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: overdue
                              ? Colors.red.shade700
                              : darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (assignment.description
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              assignment.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.black54,
              ),
            ),
          ],
          const SizedBox(height: 15),
          buildInfoRow(
            Icons.calendar_today_outlined,
            'Assigned Date',
            assignment.assignedDate,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.event_outlined,
            'Due Date',
            assignment.dueDate,
            valueColor: overdue
                ? Colors.red.shade700
                : null,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.groups_outlined,
            'Available For',
            assignment.batchId.isEmpty
                ? 'All Batches'
                : appData.getBatchName(
              assignment.batchId,
            ),
          ),
          if (assignment.attachmentUrl
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.link,
                    size: 19,
                    color: darkBlue,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: SelectableText(
                      assignment.attachmentUrl,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
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
      String value, {
        Color? valueColor,
      }) {
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
          width: 96,
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
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: valueColor ??
                  const Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  bool isAssignmentOverdue(
      String dueDate,
      ) {
    final DateTime? due =
    DateTime.tryParse(
      dueDate.trim(),
    );

    if (due == null) {
      return false;
    }

    final DateTime now = DateTime.now();

    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime normalizedDueDate =
    DateTime(
      due.year,
      due.month,
      due.day,
    );

    return normalizedDueDate.isBefore(today);
  }
}