import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminExamsScreen extends StatefulWidget {
  const AdminExamsScreen({super.key});

  @override
  State<AdminExamsScreen> createState() =>
      _AdminExamsScreenState();
}

class _AdminExamsScreenState extends State<AdminExamsScreen> {
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

  List<ExamData> get filteredExams {
    final String query = searchQuery.trim().toLowerCase();

    final List<ExamData> result =
    List<ExamData>.from(appData.exams);

    result.sort(
          (a, b) => b.examDate.compareTo(a.examDate),
    );

    if (query.isEmpty) {
      return result;
    }

    return result.where((exam) {
      final String courseName =
      appData.getCourseName(exam.courseId);

      final String batchName = exam.batchId.isEmpty
          ? 'All Batches'
          : appData.getBatchName(exam.batchId);

      return exam.title.toLowerCase().contains(query) ||
          exam.examType.toLowerCase().contains(query) ||
          courseName.toLowerCase().contains(query) ||
          batchName.toLowerCase().contains(query) ||
          exam.examDate.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<ExamData> exams = filteredExams;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddExam,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Exam',
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
              child: exams.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  100,
                ),
                itemCount: exams.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return buildExamCard(exams[index]);
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
          hintText: 'Search exams or tests',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
            onPressed: () {
              searchController.clear();

              setState(() {
                searchQuery = '';
              });
            },
            icon: const Icon(Icons.close),
          ),
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
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
                color: const Color(0xFFEAF4F7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_outlined
                    : Icons.quiz_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'No Exams Found'
                  : 'No Exams Available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              isSearching
                  ? 'Try searching with another keyword.'
                  : 'Create your first exam or test.',
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

  Widget buildExamCard(ExamData exam) {
    final String courseName =
    appData.getCourseName(exam.courseId);

    final String batchName = exam.batchId.isEmpty
        ? 'All Batches'
        : appData.getBatchName(exam.batchId);

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F7),
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
                      exam.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${exam.id} • ${exam.examType}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditExam(exam);
                  }

                  if (value == 'delete') {
                    confirmDelete(exam);
                  }
                },
                itemBuilder: (_) {
                  return const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
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
          const SizedBox(height: 15),
          buildInfoRow(
            Icons.menu_book_outlined,
            'Course',
            courseName,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.groups_outlined,
            'Batch',
            batchName,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.calendar_today_outlined,
            'Date',
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
            'Passing',
            exam.passingMarks,
          ),
          if (exam.instructions.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              exam.instructions,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF374151),
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
                  exam.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: exam.isActive
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
              Switch(
                value: exam.isActive,
                activeThumbColor: darkBlue,
                onChanged: (value) {
                  appData.updateExamStatus(
                    examId: exam.id,
                    isActive: value,
                  );
                },
              ),
            ],
          ),
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
          width: 88,
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

  Future<void> openAddExam() async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const ExamFormDialog();
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage('Exam added successfully');
  }

  Future<void> openEditExam(ExamData exam) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ExamFormDialog(
          exam: exam,
        );
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage('Exam updated successfully');
  }

  Future<void> confirmDelete(ExamData exam) async {
    final bool? confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Exam',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${exam.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    final bool deleted =
    appData.deleteExam(exam.id);

    showMessage(
      deleted
          ? 'Exam deleted successfully'
          : 'Unable to delete exam',
    );
  }

  void showMessage(String message) {
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

class ExamFormDialog extends StatefulWidget {
  final ExamData? exam;

  const ExamFormDialog({
    super.key,
    this.exam,
  });

  @override
  State<ExamFormDialog> createState() =>
      _ExamFormDialogState();
}

class _ExamFormDialogState
    extends State<ExamFormDialog> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  late final TextEditingController titleController;
  late final TextEditingController examDateController;
  late final TextEditingController startTimeController;
  late final TextEditingController durationController;
  late final TextEditingController totalMarksController;
  late final TextEditingController passingMarksController;
  late final TextEditingController instructionsController;

  final List<String> examTypes = const [
    'Test',
    'Quiz',
    'Midterm Exam',
    'Final Exam',
    'Practical Exam',
    'Mock Test',
    'Other',
  ];

  String? selectedCourseId;
  String selectedBatchId = '';
  String selectedExamType = 'Test';

  bool get isEditing => widget.exam != null;

  List<CourseData> get activeCourses {
    return appData.courses
        .where((course) => course.isActive)
        .toList();
  }

  List<BatchData> get availableBatches {
    if (selectedCourseId == null) {
      return <BatchData>[];
    }

    return appData.batches
        .where(
          (batch) =>
      batch.courseId == selectedCourseId &&
          batch.isActive,
    )
        .toList();
  }

  @override
  void initState() {
    super.initState();

    final ExamData? exam = widget.exam;

    titleController = TextEditingController(
      text: exam?.title ?? '',
    );

    examDateController = TextEditingController(
      text: exam?.examDate ?? '',
    );

    startTimeController = TextEditingController(
      text: exam?.startTime ?? '',
    );

    durationController = TextEditingController(
      text: exam?.duration ?? '',
    );

    totalMarksController = TextEditingController(
      text: exam?.totalMarks ?? '',
    );

    passingMarksController = TextEditingController(
      text: exam?.passingMarks ?? '',
    );

    instructionsController = TextEditingController(
      text: exam?.instructions ?? '',
    );

    selectedCourseId = exam?.courseId;
    selectedBatchId = exam?.batchId ?? '';

    if (exam != null &&
        examTypes.contains(exam.examType)) {
      selectedExamType = exam.examType;
    }

    if (selectedCourseId == null &&
        activeCourses.isNotEmpty) {
      selectedCourseId = activeCourses.first.id;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    examDateController.dispose();
    startTimeController.dispose();
    durationController.dispose();
    totalMarksController.dispose();
    passingMarksController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          maxHeight: 740,
        ),
        child: Column(
          children: [
            buildHeader(),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    buildLabel('Exam Title'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: titleController,
                      hintText: 'Enter exam title',
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Exam Type'),
                    const SizedBox(height: 7),
                    buildExamTypeDropdown(),
                    const SizedBox(height: 16),
                    buildLabel('Course'),
                    const SizedBox(height: 7),
                    buildCourseDropdown(),
                    const SizedBox(height: 16),
                    buildLabel('Batch'),
                    const SizedBox(height: 7),
                    buildBatchDropdown(),
                    const SizedBox(height: 16),
                    buildLabel('Exam Date'),
                    const SizedBox(height: 7),
                    buildDateField(),
                    const SizedBox(height: 16),
                    buildLabel('Start Time'),
                    const SizedBox(height: 7),
                    buildTimeField(),
                    const SizedBox(height: 16),
                    buildLabel('Duration'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: durationController,
                      hintText: 'Example: 2 Hours',
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Total Marks'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: totalMarksController,
                      hintText: 'Enter total marks',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Passing Marks'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: passingMarksController,
                      hintText: 'Enter passing marks',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Instructions'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: instructionsController,
                      hintText: 'Enter exam instructions',
                      maxLines: 5,
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
      padding: const EdgeInsets.fromLTRB(
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
              color: const Color(0xFFEAF4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.quiz_outlined,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Exam'
                  : 'Add Exam',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: inputDecoration(hintText),
    );
  }

  Widget buildExamTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedExamType,
      isExpanded: true,
      decoration: inputDecoration(
        'Select exam type',
      ),
      items: examTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }

        setState(() {
          selectedExamType = value;
        });
      },
    );
  }

  Widget buildCourseDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCourseId,
      isExpanded: true,
      decoration: inputDecoration(
        'Select course',
      ),
      items: activeCourses.map((course) {
        return DropdownMenuItem<String>(
          value: course.id,
          child: Text(
            course.name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCourseId = value;
          selectedBatchId = '';
        });
      },
    );
  }

  Widget buildBatchDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBatchId,
      isExpanded: true,
      decoration: inputDecoration(
        'Select batch',
      ),
      items: [
        const DropdownMenuItem<String>(
          value: '',
          child: Text('All Batches'),
        ),
        ...availableBatches.map(
              (batch) {
            return DropdownMenuItem<String>(
              value: batch.id,
              child: Text(
                batch.name,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ],
      onChanged: selectedCourseId == null
          ? null
          : (value) {
        setState(() {
          selectedBatchId = value ?? '';
        });
      },
    );
  }

  Widget buildDateField() {
    return TextField(
      controller: examDateController,
      readOnly: true,
      decoration: inputDecoration(
        'Select exam date',
      ).copyWith(
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          size: 20,
        ),
      ),
      onTap: () async {
        DateTime initialDate = DateTime.now();

        final DateTime? existingDate =
        DateTime.tryParse(
          examDateController.text.trim(),
        );

        if (existingDate != null) {
          initialDate = existingDate;
        }

        final DateTime? selectedDate =
        await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (!mounted || selectedDate == null) {
          return;
        }

        examDateController.text =
            formatDate(selectedDate);
      },
    );
  }

  Widget buildTimeField() {
    return TextField(
      controller: startTimeController,
      readOnly: true,
      decoration: inputDecoration(
        'Select start time',
      ).copyWith(
        suffixIcon: const Icon(
          Icons.schedule_outlined,
          size: 20,
        ),
      ),
      onTap: () async {
        TimeOfDay initialTime = TimeOfDay.now();

        final TimeOfDay? selectedTime =
        await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (!mounted || selectedTime == null) {
          return;
        }

        startTimeController.text =
            formatTime(selectedTime);
      },
    );
  }

  InputDecoration inputDecoration(
      String hintText,
      ) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
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
          color: darkBlue,
          width: 1.4,
        ),
      ),
    );
  }

  Widget buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: darkBlue,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: saveExam,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
              ),
              child: Text(
                isEditing ? 'Update' : 'Save',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveExam() {
    final String title =
    titleController.text.trim();

    final String examDate =
    examDateController.text.trim();

    final String startTime =
    startTimeController.text.trim();

    final String duration =
    durationController.text.trim();

    final String totalMarks =
    totalMarksController.text.trim();

    final String passingMarks =
    passingMarksController.text.trim();

    if (title.isEmpty) {
      showDialogMessage(
        'Please enter exam title',
      );
      return;
    }

    if (selectedCourseId == null ||
        selectedCourseId!.isEmpty) {
      showDialogMessage(
        'Please select a course',
      );
      return;
    }

    if (examDate.isEmpty) {
      showDialogMessage(
        'Please select exam date',
      );
      return;
    }

    if (startTime.isEmpty) {
      showDialogMessage(
        'Please select start time',
      );
      return;
    }

    if (duration.isEmpty) {
      showDialogMessage(
        'Please enter exam duration',
      );
      return;
    }

    final double? total =
    double.tryParse(totalMarks);

    final double? passing =
    double.tryParse(passingMarks);

    if (total == null || total <= 0) {
      showDialogMessage(
        'Please enter valid total marks',
      );
      return;
    }

    if (passing == null || passing < 0) {
      showDialogMessage(
        'Please enter valid passing marks',
      );
      return;
    }

    if (passing > total) {
      showDialogMessage(
        'Passing marks cannot be greater than total marks',
      );
      return;
    }

    if (isEditing) {
      appData.updateExam(
        examId: widget.exam!.id,
        title: title,
        courseId: selectedCourseId!,
        batchId: selectedBatchId,
        examType: selectedExamType,
        examDate: examDate,
        startTime: startTime,
        duration: duration,
        totalMarks: totalMarks,
        passingMarks: passingMarks,
        instructions:
        instructionsController.text,
      );

      Navigator.pop(context, true);
      return;
    }

    final ExamData? exam = appData.addExam(
      title: title,
      courseId: selectedCourseId!,
      batchId: selectedBatchId,
      examType: selectedExamType,
      examDate: examDate,
      startTime: startTime,
      duration: duration,
      totalMarks: totalMarks,
      passingMarks: passingMarks,
      instructions: instructionsController.text,
    );

    if (exam == null) {
      showDialogMessage(
        'Unable to add exam',
      );
      return;
    }

    Navigator.pop(context, true);
  }

  void showDialogMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  String formatDate(DateTime date) {
    final String month =
    date.month.toString().padLeft(2, '0');

    final String day =
    date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String formatTime(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final String minute =
    time.minute.toString().padLeft(2, '0');

    final String period =
    time.period == DayPeriod.am
        ? 'AM'
        : 'PM';

    return '$hour:$minute $period';
  }
}