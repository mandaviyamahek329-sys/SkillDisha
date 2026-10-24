import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminResultsScreen extends StatefulWidget {
  const AdminResultsScreen({super.key});

  @override
  State<AdminResultsScreen> createState() =>
      _AdminResultsScreenState();
}

class _AdminResultsScreenState
    extends State<AdminResultsScreen> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    appData.addListener(handleDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(handleDataChanged);
    searchController.dispose();
    super.dispose();
  }

  void handleDataChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<ResultData> get filteredResults {
    final String query =
    searchQuery.trim().toLowerCase();

    final List<ResultData> result =
    List<ResultData>.from(appData.results);

    result.sort(
          (a, b) {
        final ExamData? examA =
        appData.findExamById(a.examId);

        final ExamData? examB =
        appData.findExamById(b.examId);

        final String dateA =
            examA?.examDate ?? '';

        final String dateB =
            examB?.examDate ?? '';

        return dateB.compareTo(dateA);
      },
    );

    if (query.isEmpty) {
      return result;
    }

    return result.where(
          (resultItem) {
        final StudentData? student =
        appData.findStudentById(
          resultItem.studentId,
        );

        final ExamData? exam =
        appData.findExamById(
          resultItem.examId,
        );

        final String studentName =
            student?.fullName ?? '';

        final String examTitle =
            exam?.title ?? '';

        final String courseName =
        appData.getCourseName(
          resultItem.courseId,
        );

        final String batchName =
        appData.getBatchName(
          resultItem.batchId,
        );

        return resultItem.id
            .toLowerCase()
            .contains(query) ||
            studentName
                .toLowerCase()
                .contains(query) ||
            examTitle
                .toLowerCase()
                .contains(query) ||
            courseName
                .toLowerCase()
                .contains(query) ||
            batchName
                .toLowerCase()
                .contains(query) ||
            resultItem.resultStatus
                .toLowerCase()
                .contains(query) ||
            resultItem.grade
                .toLowerCase()
                .contains(query);
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<ResultData> results =
        filteredResults;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Results',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: openAddResult,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Result',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildSearchSection(),
            Expanded(
              child: results.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  100,
                ),
                itemCount: results.length,
                separatorBuilder:
                    (_, __) {
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        14,
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search results',
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon:
          searchQuery.trim().isEmpty
              ? null
              : IconButton(
            onPressed: () {
              searchController.clear();

              setState(() {
                searchQuery = '';
              });
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
          filled: true,
          fillColor:
          const Color(0xFFF7F8FA),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    final bool isSearching =
        searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color:
                const Color(0xFFEAF4F7),
                borderRadius:
                BorderRadius.circular(24),
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_outlined
                    : Icons
                    .bar_chart_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'No Results Found'
                  : 'No Results Available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              isSearching
                  ? 'Try searching with another keyword.'
                  : 'Create the first student result.',
              textAlign: TextAlign.center,
              style: const TextStyle(
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

  Widget buildResultCard(
      ResultData result,
      ) {
    final StudentData? student =
    appData.findStudentById(
      result.studentId,
    );

    final ExamData? exam =
    appData.findExamById(
      result.examId,
    );

    final bool isPass =
        result.resultStatus == 'Pass';

    return Container(
      padding: const EdgeInsets.all(16),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFEAF4F7),
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons
                      .assessment_outlined,
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
                      student?.fullName ??
                          'Student Not Found',
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
                      exam?.title ??
                          'Exam Not Found',
                      style:
                      const TextStyle(
                        fontSize: 12,
                        color:
                        Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        buildStatusBadge(
                          result
                              .resultStatus,
                          isPass
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        buildStatusBadge(
                          'Grade ${result.grade}',
                          darkBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditResult(
                      result,
                    );
                  }

                  if (value ==
                      'delete') {
                    confirmDelete(
                      result,
                    );
                  }
                },
                itemBuilder: (_) {
                  return const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .edit_outlined,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .delete_outline,
                            size: 20,
                            color:
                            Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Delete',
                            style:
                            TextStyle(
                              color:
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.badge_outlined,
            'Result ID',
            result.id,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.quiz_outlined,
            'Exam',
            exam?.title ??
                'Not Available',
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons
                .calendar_today_outlined,
            'Exam Date',
            exam?.examDate ??
                'Not Available',
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons
                .menu_book_outlined,
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
            Icons.numbers_outlined,
            'Marks',
            '${result.obtainedMarks} / ${result.totalMarks}',
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.percent_outlined,
            'Percentage',
            '${result.percentage}%',
          ),
          if (result
              .remarks
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'Remarks',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w600,
                color: Colors.black54,
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
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  result.isPublished
                      ? 'Published'
                      : 'Unpublished',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    result.isPublished
                        ? Colors.green
                        .shade700
                        : Colors.orange
                        .shade800,
                  ),
                ),
              ),
              Switch(
                value:
                result.isPublished,
                activeThumbColor:
                darkBlue,
                onChanged: (value) {
                  appData
                      .updateResultPublishStatus(
                    resultId:
                    result.id,
                    isPublished:
                    value,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatusBadge(
      String text,
      Color color,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight:
          FontWeight.w600,
          color: color,
        ),
      ),
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
          width: 92,
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

  Future<void> openAddResult() async {
    final bool? saved =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const ResultFormDialog();
      },
    );

    if (!mounted ||
        saved != true) {
      return;
    }

    showMessage(
      'Result added successfully',
    );
  }

  Future<void> openEditResult(
      ResultData result,
      ) async {
    final bool? saved =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ResultFormDialog(
          result: result,
        );
      },
    );

    if (!mounted ||
        saved != true) {
      return;
    }

    showMessage(
      'Result updated successfully',
    );
  }

  Future<void> confirmDelete(
      ResultData result,
      ) async {
    final bool? confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),
          title: const Text(
            'Delete Result',
            style: TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this result?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
              const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
              ElevatedButton
                  .styleFrom(
                backgroundColor:
                Colors.red,
                foregroundColor:
                Colors.white,
              ),
              child:
              const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted ||
        confirmed != true) {
      return;
    }

    final bool deleted =
    appData.deleteResult(
      result.id,
    );

    showMessage(
      deleted
          ? 'Result deleted successfully'
          : 'Unable to delete result',
    );
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
          content: Text(message),
        ),
      );
  }
}

class ResultFormDialog
    extends StatefulWidget {
  final ResultData? result;

  const ResultFormDialog({
    super.key,
    this.result,
  });

  @override
  State<ResultFormDialog>
  createState() =>
      _ResultFormDialogState();
}

class _ResultFormDialogState
    extends State<ResultFormDialog> {
  static const Color darkBlue =
  Color(0xFF075273);

  final AppData appData =
      AppData.instance;

  late final TextEditingController
  obtainedMarksController;

  late final TextEditingController
  remarksController;

  String? selectedExamId;
  String? selectedStudentId;

  bool isPublished = false;

  bool get isEditing =>
      widget.result != null;

  List<ExamData> get availableExams {
    final List<ExamData> result =
    appData.exams
        .where(
          (exam) =>
      exam.isActive,
    )
        .toList();

    result.sort(
          (a, b) =>
          b.examDate.compareTo(
            a.examDate,
          ),
    );

    return result;
  }

  List<StudentData>
  get availableStudents {
    if (selectedExamId == null) {
      return <StudentData>[];
    }

    return appData
        .getEligibleStudentsForExam(
      selectedExamId!,
    );
  }

  ExamData? get selectedExam {
    if (selectedExamId == null) {
      return null;
    }

    return appData.findExamById(
      selectedExamId!,
    );
  }

  @override
  void initState() {
    super.initState();

    final ResultData? result =
        widget.result;

    selectedExamId =
        result?.examId;

    selectedStudentId =
        result?.studentId;

    obtainedMarksController =
        TextEditingController(
          text:
          result?.obtainedMarks ?? '',
        );

    remarksController =
        TextEditingController(
          text: result?.remarks ?? '',
        );

    isPublished =
        result?.isPublished ?? false;

    if (selectedExamId == null &&
        availableExams.isNotEmpty) {
      selectedExamId =
          availableExams.first.id;
    }
  }

  @override
  void dispose() {
    obtainedMarksController
        .dispose();

    remarksController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Dialog(
      insetPadding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),
      child: ConstrainedBox(
        constraints:
        const BoxConstraints(
          maxWidth: 560,
          maxHeight: 720,
        ),
        child: Column(
          children: [
            buildHeader(),
            const Divider(height: 1),
            Expanded(
              child:
              SingleChildScrollView(
                padding:
                const EdgeInsets.all(
                  18,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    buildLabel('Exam'),
                    const SizedBox(
                      height: 7,
                    ),
                    buildExamDropdown(),
                    const SizedBox(
                      height: 16,
                    ),
                    buildLabel(
                      'Student',
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    buildStudentDropdown(),
                    const SizedBox(
                      height: 16,
                    ),
                    buildExamDetails(),
                    const SizedBox(
                      height: 16,
                    ),
                    buildLabel(
                      'Obtained Marks',
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller:
                      obtainedMarksController,
                      keyboardType:
                      const TextInputType
                          .numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration:
                      inputDecoration(
                        'Enter obtained marks',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    buildCalculatedResult(),
                    const SizedBox(
                      height: 16,
                    ),
                    buildLabel(
                      'Remarks',
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextField(
                      controller:
                      remarksController,
                      maxLines: 4,
                      decoration:
                      inputDecoration(
                        'Enter remarks',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFFF8FAFC,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                        border:
                        Border.all(
                          color:
                          const Color(
                            0xFFE5E7EB,
                          ),
                        ),
                      ),
                      child: SwitchListTile(
                        value:
                        isPublished,
                        contentPadding:
                        EdgeInsets.zero,
                        activeThumbColor:
                        darkBlue,
                        title: const Text(
                          'Publish Result',
                          style:
                          TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                        subtitle:
                        const Text(
                          'Published results are visible to students.',
                          style:
                          TextStyle(
                            fontSize: 11.5,
                          ),
                        ),
                        onChanged:
                            (value) {
                          setState(() {
                            isPublished =
                                value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            buildActions(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        18,
        16,
        10,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
              const Color(
                0xFFEAF4F7,
              ),
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
            child: const Icon(
              Icons.assessment_outlined,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Result'
                  : 'Add Result',
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                Color(0xFF1F2937),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            icon:
            const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabel(
      String text,
      ) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight:
        FontWeight.w600,
        color:
        Color(0xFF374151),
      ),
    );
  }

  Widget buildExamDropdown() {
    final bool selectedExists =
        selectedExamId == null ||
            availableExams.any(
                  (exam) =>
              exam.id ==
                  selectedExamId,
            );

    final String? value =
    selectedExists
        ? selectedExamId
        : null;

    return DropdownButtonFormField<
        String>(
      value: value,
      isExpanded: true,
      decoration:
      inputDecoration(
        'Select exam',
      ),
      items:
      availableExams.map(
            (exam) {
          return DropdownMenuItem<
              String>(
            value: exam.id,
            child: Text(
              '${exam.title} - ${exam.examDate}',
              overflow:
              TextOverflow
                  .ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged: isEditing
          ? null
          : (value) {
        setState(() {
          selectedExamId =
              value;

          selectedStudentId =
          null;

          obtainedMarksController
              .clear();
        });
      },
    );
  }

  Widget buildStudentDropdown() {
    final bool selectedExists =
        selectedStudentId == null ||
            availableStudents.any(
                  (student) =>
              student.id ==
                  selectedStudentId,
            );

    final String? value =
    selectedExists
        ? selectedStudentId
        : null;

    return DropdownButtonFormField<
        String>(
      value: value,
      isExpanded: true,
      decoration:
      inputDecoration(
        'Select student',
      ),
      items:
      availableStudents.map(
            (student) {
          return DropdownMenuItem<
              String>(
            value: student.id,
            child: Text(
              student.rollNumber
                  .trim()
                  .isEmpty
                  ? student.fullName
                  : '${student.fullName} - ${student.rollNumber}',
              overflow:
              TextOverflow
                  .ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged: isEditing
          ? null
          : selectedExamId ==
          null
          ? null
          : (value) {
        setState(() {
          selectedStudentId =
              value;
        });
      },
    );
  }

  Widget buildExamDetails() {
    final ExamData? exam =
        selectedExam;

    if (exam == null) {
      return Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(
          14,
        ),
        decoration:
        BoxDecoration(
          color:
          const Color(
            0xFFF8FAFC,
          ),
          borderRadius:
          BorderRadius.circular(
            12,
          ),
          border: Border.all(
            color:
            const Color(
              0xFFE5E7EB,
            ),
          ),
        ),
        child: const Text(
          'Select an exam to view details.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(
        14,
      ),
      decoration:
      BoxDecoration(
        color:
        const Color(
          0xFFEAF4F7,
        ),
        borderRadius:
        BorderRadius.circular(
          12,
        ),
      ),
      child: Column(
        children: [
          buildSmallDetailRow(
            'Course',
            appData.getCourseName(
              exam.courseId,
            ),
          ),
          const SizedBox(height: 7),
          buildSmallDetailRow(
            'Batch',
            exam.batchId.isEmpty
                ? 'All Batches'
                : appData
                .getBatchName(
              exam.batchId,
            ),
          ),
          const SizedBox(height: 7),
          buildSmallDetailRow(
            'Total Marks',
            exam.totalMarks,
          ),
          const SizedBox(height: 7),
          buildSmallDetailRow(
            'Passing Marks',
            exam.passingMarks,
          ),
        ],
      ),
    );
  }

  Widget buildSmallDetailRow(
      String label,
      String value,
      ) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style:
            const TextStyle(
              fontSize: 12,
              color:
              Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style:
            const TextStyle(
              fontSize: 12.5,
              fontWeight:
              FontWeight.w600,
              color:
              Color(
                0xFF374151,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCalculatedResult() {
    final ExamData? exam =
        selectedExam;

    final double? total =
    double.tryParse(
      exam?.totalMarks ?? '',
    );

    final double? passing =
    double.tryParse(
      exam?.passingMarks ?? '',
    );

    final double? obtained =
    double.tryParse(
      obtainedMarksController.text
          .trim(),
    );

    if (exam == null ||
        total == null ||
        passing == null ||
        obtained == null ||
        total <= 0 ||
        obtained < 0 ||
        obtained > total) {
      return Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(
          14,
        ),
        decoration:
        BoxDecoration(
          color:
          const Color(
            0xFFF8FAFC,
          ),
          borderRadius:
          BorderRadius.circular(
            12,
          ),
          border: Border.all(
            color:
            const Color(
              0xFFE5E7EB,
            ),
          ),
        ),
        child: const Text(
          'Percentage, result and grade will be calculated automatically.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      );
    }

    final double percentage =
        obtained / total * 100;

    final String status =
    obtained >= passing
        ? 'Pass'
        : 'Fail';

    final String grade =
    appData
        .calculateResultGrade(
      percentage,
    );

    final Color statusColor =
    status == 'Pass'
        ? Colors.green
        : Colors.red;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(
        14,
      ),
      decoration:
      BoxDecoration(
        color:
        statusColor.withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        border: Border.all(
          color:
          statusColor.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Column(
        children: [
          buildSmallDetailRow(
            'Percentage',
            '${percentage.toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 7),
          buildSmallDetailRow(
            'Result',
            status,
          ),
          const SizedBox(height: 7),
          buildSmallDetailRow(
            'Grade',
            grade,
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(
      String hintText,
      ) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor:
      const Color(0xFFF8FAFC),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        borderSide:
        const BorderSide(
          color:
          Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        borderSide:
        const BorderSide(
          color:
          Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        borderSide:
        const BorderSide(
          color: darkBlue,
          width: 1.4,
        ),
      ),
    );
  }

  Widget buildActions() {
    return Padding(
      padding:
      const EdgeInsets.all(
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              style:
              OutlinedButton
                  .styleFrom(
                foregroundColor:
                darkBlue,
                padding:
                const EdgeInsets
                    .symmetric(
                  vertical: 13,
                ),
              ),
              child:
              const Text(
                'Cancel',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: saveResult,
              style:
              ElevatedButton
                  .styleFrom(
                backgroundColor:
                darkBlue,
                foregroundColor:
                Colors.white,
                padding:
                const EdgeInsets
                    .symmetric(
                  vertical: 13,
                ),
              ),
              child: Text(
                isEditing
                    ? 'Update'
                    : 'Save',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveResult() {
    if (selectedExamId ==
        null ||
        selectedExamId!.isEmpty) {
      showDialogMessage(
        'Please select an exam',
      );
      return;
    }

    if (selectedStudentId ==
        null ||
        selectedStudentId!
            .isEmpty) {
      showDialogMessage(
        'Please select a student',
      );
      return;
    }

    final ExamData? exam =
    appData.findExamById(
      selectedExamId!,
    );

    if (exam == null) {
      showDialogMessage(
        'Selected exam was not found',
      );
      return;
    }

    final double? total =
    double.tryParse(
      exam.totalMarks.trim(),
    );

    final double? obtained =
    double.tryParse(
      obtainedMarksController.text
          .trim(),
    );

    if (obtained == null) {
      showDialogMessage(
        'Please enter valid obtained marks',
      );
      return;
    }

    if (total == null ||
        total <= 0) {
      showDialogMessage(
        'Exam total marks are invalid',
      );
      return;
    }

    if (obtained < 0 ||
        obtained > total) {
      showDialogMessage(
        'Obtained marks must be between 0 and total marks',
      );
      return;
    }

    if (isEditing) {
      final bool updated =
      appData.updateResult(
        resultId:
        widget.result!.id,
        examId:
        selectedExamId!,
        studentId:
        selectedStudentId!,
        obtainedMarks:
        obtainedMarksController
            .text,
        remarks:
        remarksController.text,
      );

      if (!updated) {
        showDialogMessage(
          'Unable to update result',
        );
        return;
      }

      appData
          .updateResultPublishStatus(
        resultId:
        widget.result!.id,
        isPublished:
        isPublished,
      );

      Navigator.pop(
        context,
        true,
      );

      return;
    }

    final ResultData? result =
    appData.addResult(
      examId:
      selectedExamId!,
      studentId:
      selectedStudentId!,
      obtainedMarks:
      obtainedMarksController
          .text,
      remarks:
      remarksController.text,
      isPublished:
      isPublished,
    );

    if (result == null) {
      showDialogMessage(
        'Unable to add result. A result may already exist for this student and exam.',
      );
      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  void showDialogMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}