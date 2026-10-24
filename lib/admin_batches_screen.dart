import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminBatchesScreen extends StatefulWidget {
  const AdminBatchesScreen({super.key});

  @override
  State<AdminBatchesScreen> createState() => _AdminBatchesScreenState();
}

class _AdminBatchesScreenState extends State<AdminBatchesScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

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

  Future<void> openAddBatchDialog() async {
    final BatchFormResult? result = await showDialog<BatchFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BatchFormDialog(
          courses: appData.courses,
          trainers: appData.trainers,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    appData.addBatch(
      name: result.name,
      courseId: result.courseId,
      trainerId: result.trainerId,
      timing: result.timing,
      room: result.room,
      days: result.days,
    );

    if (!mounted) {
      return;
    }

    showMessage('Batch added successfully');
  }

  Future<void> openEditBatchDialog(
      BatchData batch,
      ) async {
    final BatchFormResult? result = await showDialog<BatchFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BatchFormDialog(
          courses: appData.courses,
          trainers: appData.trainers,
          batch: batch,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    appData.updateBatch(
      batchId: batch.id,
      name: result.name,
      courseId: result.courseId,
      trainerId: result.trainerId,
      timing: result.timing,
      room: result.room,
      days: result.days,
    );

    if (!mounted) {
      return;
    }

    showMessage('Batch updated successfully');
  }

  Future<void> confirmDeleteBatch(
      BatchData batch,
      ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Batch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${batch.name}?',
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

    if (!mounted || shouldDelete != true) {
      return;
    }

    final bool deleted = appData.deleteBatch(
      batch.id,
    );

    if (!mounted) {
      return;
    }

    if (!deleted) {
      showMessage(
        'This batch cannot be deleted because a student is assigned to it.',
      );
      return;
    }

    showMessage(
      '${batch.name} deleted successfully',
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
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<BatchData> batches =
        appData.batches;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Batches Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: batches.isEmpty
          ? buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
        itemCount: batches.length,
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          return buildBatchCard(
            batches[index],
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: openAddBatchDialog,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(
          Icons.add_circle_outline,
        ),
        label: const Text(
          'Add Batch',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.groups_outlined,
                size: 58,
                color: darkBlue,
              ),
              SizedBox(height: 14),
              Text(
                'No batches available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Add a batch to start managing batch details.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBatchCard(
      BatchData batch,
      ) {
    final CourseData? course =
    appData.findCourseById(
      batch.courseId,
    );

    final TrainerData? trainer =
    appData.findTrainerById(
      batch.trainerId,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEAF4F7,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.groups_outlined,
                  color: darkBlue,
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
                      batch.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${batch.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: batch.isActive,
                activeThumbColor: darkBlue,
                activeTrackColor:
                teal.withValues(
                  alpha: 0.45,
                ),
                onChanged: (bool value) {
                  appData.updateBatchStatus(
                    batchId: batch.id,
                    isActive: value,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 8),
          buildInfoRow(
            title: 'Course',
            value: course?.name ??
                'Not Assigned',
          ),
          buildInfoRow(
            title: 'Trainer',
            value: trainer?.name ??
                'Not Assigned',
          ),
          buildInfoRow(
            title: 'Timing',
            value: batch.timing,
          ),
          buildInfoRow(
            title: 'Room',
            value: batch.room,
          ),
          buildInfoRow(
            title: 'Days',
            value: batch.days,
          ),
          buildInfoRow(
            title: 'Status',
            value: batch.isActive
                ? 'Active'
                : 'Inactive',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    openEditBatchDialog(
                      batch,
                    );
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    minimumSize:
                    const Size(0, 46),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                  ),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 48,
                height: 46,
                child: IconButton(
                  onPressed: () {
                    confirmDeleteBatch(
                      batch,
                    );
                  },
                  tooltip: 'Delete Batch',
                  style: IconButton.styleFrom(
                    foregroundColor:
                    Colors.red,
                    backgroundColor:
                    const Color(
                      0xFFFFF1F2,
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required String title,
    required String value,
  }) {
    final String displayValue =
    value.trim().isEmpty
        ? 'Not Assigned'
        : value;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BatchFormDialog
    extends StatefulWidget {
  final List<CourseData> courses;
  final List<TrainerData> trainers;
  final BatchData? batch;

  const BatchFormDialog({
    super.key,
    required this.courses,
    required this.trainers,
    this.batch,
  });

  @override
  State<BatchFormDialog> createState() =>
      _BatchFormDialogState();
}

class _BatchFormDialogState
    extends State<BatchFormDialog> {
  static const Color darkBlue =
  Color(0xFF075273);
  static const Color teal =
  Color(0xFF55B2B8);

  late final TextEditingController
  nameController;
  late final TextEditingController
  timingController;
  late final TextEditingController
  roomController;
  late final TextEditingController
  daysController;

  String? selectedCourseId;
  String? selectedTrainerId;

  bool get isEditing =>
      widget.batch != null;

  @override
  void initState() {
    super.initState();

    final BatchData? batch =
        widget.batch;

    nameController =
        TextEditingController(
          text: batch?.name ?? '',
        );

    timingController =
        TextEditingController(
          text: batch?.timing ?? '',
        );

    roomController =
        TextEditingController(
          text: batch?.room ?? '',
        );

    daysController =
        TextEditingController(
          text: batch?.days ?? '',
        );

    selectedCourseId =
        batch?.courseId;

    selectedTrainerId =
        batch?.trainerId;
  }

  @override
  void dispose() {
    nameController.dispose();
    timingController.dispose();
    roomController.dispose();
    daysController.dispose();
    super.dispose();
  }

  void submit() {
    final String name =
    nameController.text.trim();

    final String timing =
    timingController.text.trim();

    final String room =
    roomController.text.trim();

    final String days =
    daysController.text.trim();

    if (name.isEmpty) {
      showMessage(
        'Please enter batch name',
      );
      return;
    }

    if (selectedCourseId == null) {
      showMessage(
        'Please select a course',
      );
      return;
    }

    if (selectedTrainerId == null) {
      showMessage(
        'Please select a trainer',
      );
      return;
    }

    if (timing.isEmpty) {
      showMessage(
        'Please enter batch timing',
      );
      return;
    }

    if (room.isEmpty) {
      showMessage(
        'Please enter room',
      );
      return;
    }

    if (days.isEmpty) {
      showMessage(
        'Please enter batch days',
      );
      return;
    }

    Navigator.pop(
      context,
      BatchFormResult(
        name: name,
        courseId: selectedCourseId!,
        trainerId:
        selectedTrainerId!,
        timing: timing,
        room: room,
        days: days,
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<CourseData>
    activeCourses = widget.courses
        .where(
          (CourseData course) =>
      course.isActive ||
          course.id ==
              selectedCourseId,
    )
        .toList();

    final List<TrainerData>
    activeTrainers = widget.trainers
        .where(
          (TrainerData trainer) =>
      trainer.isActive ||
          trainer.id ==
              selectedTrainerId,
    )
        .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),
      title: Text(
        isEditing
            ? 'Edit Batch'
            : 'Add Batch',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              buildTextField(
                controller:
                nameController,
                label: 'Batch Name',
              ),
              DropdownButtonFormField<
                  String>(
                initialValue:
                selectedCourseId,
                isExpanded: true,
                decoration:
                buildDecoration(
                  'Course',
                ),
                items: activeCourses
                    .map(
                      (
                      CourseData course,
                      ) {
                    return DropdownMenuItem<
                        String>(
                      value: course.id,
                      child: Text(
                        course.name,
                        overflow:
                        TextOverflow
                            .ellipsis,
                      ),
                    );
                  },
                )
                    .toList(),
                onChanged: (
                    String? value,
                    ) {
                  setState(() {
                    selectedCourseId =
                        value;

                    CourseData?
                    selectedCourse;

                    for (final CourseData
                    course
                    in widget.courses) {
                      if (course.id ==
                          value) {
                        selectedCourse =
                            course;
                        break;
                      }
                    }

                    if (selectedCourse !=
                        null) {
                      selectedTrainerId =
                          selectedCourse
                              .trainerId;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<
                  String>(
                initialValue:
                selectedTrainerId,
                isExpanded: true,
                decoration:
                buildDecoration(
                  'Trainer',
                ),
                items: activeTrainers
                    .map(
                      (
                      TrainerData trainer,
                      ) {
                    return DropdownMenuItem<
                        String>(
                      value: trainer.id,
                      child: Text(
                        trainer.name,
                        overflow:
                        TextOverflow
                            .ellipsis,
                      ),
                    );
                  },
                )
                    .toList(),
                onChanged: (
                    String? value,
                    ) {
                  setState(() {
                    selectedTrainerId =
                        value;
                  });
                },
              ),
              const SizedBox(height: 12),
              buildTextField(
                controller:
                timingController,
                label: 'Batch Timing',
                hintText:
                'Example: 10:00 AM - 12:00 PM',
              ),
              buildTextField(
                controller:
                roomController,
                label: 'Room',
                hintText:
                'Example: Lab 1',
              ),
              buildTextField(
                controller:
                daysController,
                label: 'Days',
                hintText:
                'Example: Monday, Wednesday, Friday',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:
          const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submit,
          style:
          ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor:
            Colors.white,
          ),
          child: Text(
            isEditing
                ? 'Save Changes'
                : 'Add Batch',
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController
    controller,
    required String label,
    String? hintText,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        decoration:
        buildDecoration(
          label,
        ).copyWith(
          hintText: hintText,
        ),
      ),
    );
  }

  InputDecoration buildDecoration(
      String label,
      ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
    );
  }
}

class BatchFormResult {
  final String name;
  final String courseId;
  final String trainerId;
  final String timing;
  final String room;
  final String days;

  const BatchFormResult({
    required this.name,
    required this.courseId,
    required this.trainerId,
    required this.timing,
    required this.room,
    required this.days,
  });
}
