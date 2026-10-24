import 'package:flutter/material.dart';

import 'app_data.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() =>
      _ResultsScreenState();
}

class _ResultsScreenState
    extends State<ResultsScreen> {
  static const Color darkBlue =
  Color(0xFF075273);

  static const Color teal =
  Color(0xFF55B2B8);

  final AppData appData =
      AppData.instance;

  @override
  void initState() {
    super.initState();
    appData.addListener(
      handleDataChanged,
    );
  }

  @override
  void dispose() {
    appData.removeListener(
      handleDataChanged,
    );
    super.dispose();
  }

  void handleDataChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final StudentData? student =
        appData.currentStudentOrNull;

    if (student == null) {
      return Scaffold(
        backgroundColor:
        const Color(0xFFF7F8FA),
        appBar: buildAppBar(),
        body: buildStudentNotFound(),
      );
    }

    final List<ResultData> results =
    appData
        .getPublishedResultsForStudent(
      student.id,
    );

    final String courseName =
    appData.getCourseName(
      student.courseId,
    );

    final String batchName =
    appData.getBatchName(
      student.batchId,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F8FA),
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildStudentHeader(
              student: student,
              courseName: courseName,
              batchName: batchName,
            ),
            Expanded(
              child: results.isEmpty
                  ? buildEmptyState()
                  : buildResultsList(
                results,
              ),
            ),
          ],
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
        'Results',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildStudentHeader({
    required StudentData student,
    required String courseName,
    required String batchName,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            darkBlue,
            Color(0xFF0B708F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius:
              BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons
                  .assessment_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  courseName,
                  style: const TextStyle(
                    color:
                    Colors.white70,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  batchName,
                  style: const TextStyle(
                    color:
                    Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultsList(
      List<ResultData> results,
      ) {
    return ListView.separated(
      padding:
      const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        24,
      ),
      itemCount: results.length,
      separatorBuilder: (_, __) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder:
          (context, index) {
        return buildResultCard(
          results[index],
        );
      },
    );
  }

  Widget buildResultCard(
      ResultData result,
      ) {
    final ExamData? exam =
    appData.findExamById(
      result.examId,
    );

    final bool isPass =
        result.resultStatus == 'Pass';

    final Color statusColor =
    isPass
        ? Colors.green
        : Colors.red;

    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                  const Color(
                    0xFFEAF4F7,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
                child: const Icon(
                  Icons
                      .workspace_premium_outlined,
                  color: darkBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      exam?.title ??
                          'Exam Result',
                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(
                          0xFF1F2937,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      exam?.examType ??
                          'Exam',
                      style:
                      const TextStyle(
                        fontSize: 12,
                        color:
                        Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration:
                BoxDecoration(
                  color:
                  statusColor
                      .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius
                      .circular(
                    20,
                  ),
                ),
                child: Text(
                  result.resultStatus,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildMarksSection(
            result,
          ),
          const SizedBox(height: 15),
          buildInfoRow(
            Icons
                .calendar_today_outlined,
            'Exam Date',
            exam?.examDate ??
                'Not Available',
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.menu_book_outlined,
            'Course',
            appData.getCourseName(
              result.courseId,
            ),
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.groups_outlined,
            'Batch',
            appData.getBatchName(
              result.batchId,
            ),
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.grade_outlined,
            'Grade',
            result.grade,
          ),
          if (result
              .remarks
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Remarks',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w600,
                color:
                Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              result.remarks,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                Color(0xFF374151),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildMarksSection(
      ResultData result,
      ) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color:
        const Color(0xFFF8FAFC),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: buildMarkItem(
              title: 'Marks',
              value:
              '${result.obtainedMarks}/${result.totalMarks}',
            ),
          ),
          Container(
            width: 1,
            height: 44,
            color:
            const Color(
              0xFFE5E7EB,
            ),
          ),
          Expanded(
            child: buildMarkItem(
              title: 'Percentage',
              value:
              '${result.percentage}%',
            ),
          ),
          Container(
            width: 1,
            height: 44,
            color:
            const Color(
              0xFFE5E7EB,
            ),
          ),
          Expanded(
            child: buildMarkItem(
              title: 'Grade',
              value: result.grade,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMarkItem({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color:
            Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget buildInfoRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: darkBlue,
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color:
              Colors.black54,
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
              fontWeight:
              FontWeight.w600,
              color:
              Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color:
                const Color(
                  0xFFEAF4F7,
                ),
                borderRadius:
                BorderRadius.circular(
                  24,
                ),
              ),
              child: const Icon(
                Icons
                    .assessment_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Results Available',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Published exam results will appear here.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStudentNotFound() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Student information was not found.',
          textAlign:
          TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color:
            Colors.black54,
          ),
        ),
      ),
    );
  }
}