import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({
    super.key,
  });

  @override
  State<AdminCoursesScreen> createState() =>
      _AdminCoursesScreenState();
}

class _AdminCoursesScreenState
    extends State<AdminCoursesScreen> {
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

  Future<void> openAddCourseDialog() async {
    final CourseFormResult? result =
    await showDialog<CourseFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CourseFormDialog(
          trainers: appData.trainers,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    final CourseData course = appData.addCourse(
      name: result.name,
      trainerId: result.trainerId,
      duration: result.duration,
      description: result.description,
      about: result.about,
      whatYouWillLearn: result.whatYouWillLearn,
    );

    if (!mounted) {
      return;
    }

    showMessage(
      '${course.name} added successfully',
    );
  }

  Future<void> openEditCourseDialog(
      CourseData course,
      ) async {
    final CourseFormResult? result =
    await showDialog<CourseFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CourseFormDialog(
          trainers: appData.trainers,
          course: course,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    appData.updateCourse(
      courseId: course.id,
      name: result.name,
      trainerId: result.trainerId,
      duration: result.duration,
      description: result.description,
      about: result.about,
      whatYouWillLearn: result.whatYouWillLearn,
    );

    if (!mounted) {
      return;
    }

    showMessage(
      '${result.name} updated successfully',
    );
  }

  Future<void> openModulesDialog(
      CourseData course,
      ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CourseModulesDialog(
          courseId: course.id,
        );
      },
    );
  }

  Future<void> confirmDeleteCourse(
      CourseData course,
      ) async {
    final bool? shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Course',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${course.name}?',
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

    final bool deleted =
    appData.deleteCourse(course.id);

    if (!mounted) {
      return;
    }

    if (!deleted) {
      showMessage(
        'This course cannot be deleted because a student is assigned to it.',
      );
      return;
    }

    showMessage(
      '${course.name} deleted successfully',
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
    final List<CourseData> courses =
        appData.currentFacultyCourses;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Courses Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: courses.isEmpty
          ? buildEmptyState()
          : ListView.builder(
        padding:
        const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
        itemCount: courses.length,
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          return buildCourseCard(
            courses[index],
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: openAddCourseDialog,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(
          Icons.add_circle_outline,
        ),
        label: const Text(
          'Add Course',
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
                Icons.menu_book_outlined,
                size: 58,
                color: darkBlue,
              ),
              SizedBox(height: 14),
              Text(
                'No courses available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Add a course to start managing course details and modules.',
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

  Widget buildCourseCard(
      CourseData course,
      ) {
    final TrainerData? trainer =
    appData.findTrainerById(
      course.trainerId,
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
                  Icons.school_outlined,
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
                      course.name,
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
                      'ID: ${course.id}',
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
                value: course.isActive,
                activeThumbColor: darkBlue,
                activeTrackColor:
                teal.withValues(
                  alpha: 0.45,
                ),
                onChanged: (bool value) {
                  appData.updateCourseStatus(
                    courseId: course.id,
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
            title: 'Trainer',
            value: trainer?.name ??
                'Not Assigned',
          ),
          buildInfoRow(
            title: 'Duration',
            value: course.duration,
          ),
          buildInfoRow(
            title: 'Status',
            value: course.isActive
                ? 'Active'
                : 'Inactive',
          ),
          buildInfoRow(
            title: 'Modules',
            value:
            '${course.modules.length}',
          ),
          buildInfoRow(
            title: 'Learning Points',
            value:
            '${course.whatYouWillLearn.length}',
          ),
          if (course.description
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              course.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF374151),
              ),
            ),
          ],
          if (course.about
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'About Course',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              course.about,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF374151),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      openModulesDialog(
                        course,
                      );
                    },
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor: darkBlue,
                      side: const BorderSide(
                        color: darkBlue,
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.view_list_outlined,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Modules',
                            maxLines: 1,
                            softWrap: false,
                            overflow:
                            TextOverflow.ellipsis,
                            textAlign:
                            TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    openEditCourseDialog(
                      course,
                    );
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    minimumSize:
                    const Size(0, 45),
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
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  confirmDeleteCourse(
                    course,
                  );
                },
                tooltip: 'Delete Course',
                style: IconButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor:
                  const Color(0xFFFFF1F2),
                ),
                icon: const Icon(
                  Icons.delete_outline,
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
            width: 110,
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
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseFormDialog extends StatefulWidget {
  final List<TrainerData> trainers;
  final CourseData? course;

  const CourseFormDialog({
    super.key,
    required this.trainers,
    this.course,
  });

  @override
  State<CourseFormDialog> createState() =>
      _CourseFormDialogState();
}

class _CourseFormDialogState
    extends State<CourseFormDialog> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  late final TextEditingController
  nameController;
  late final TextEditingController
  durationController;
  late final TextEditingController
  descriptionController;
  late final TextEditingController
  aboutController;
  late final TextEditingController
  learningController;

  String? selectedTrainerId;

  bool get isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();

    final CourseData? course =
        widget.course;

    nameController = TextEditingController(
      text: course?.name ?? '',
    );

    durationController =
        TextEditingController(
          text: course?.duration ?? '',
        );

    descriptionController =
        TextEditingController(
          text: course?.description ?? '',
        );

    aboutController = TextEditingController(
      text: course?.about ?? '',
    );

    learningController =
        TextEditingController(
          text: course == null
              ? ''
              : course.whatYouWillLearn.join(
            '\n',
          ),
        );

    selectedTrainerId =
    course?.trainerId.isNotEmpty == true
        ? course!.trainerId
        : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    aboutController.dispose();
    learningController.dispose();
    super.dispose();
  }

  void submit() {
    final String name =
    nameController.text.trim();

    final String duration =
    durationController.text.trim();

    final String description =
    descriptionController.text.trim();

    final String about =
    aboutController.text.trim();

    if (name.isEmpty) {
      showMessage(
        'Please enter course name',
      );
      return;
    }

    if (selectedTrainerId == null) {
      showMessage(
        'Please select a trainer',
      );
      return;
    }

    if (duration.isEmpty) {
      showMessage(
        'Please enter course duration',
      );
      return;
    }

    final List<String> learningPoints =
    learningController.text
        .split('\n')
        .map(
          (String item) =>
          item.trim(),
    )
        .where(
          (String item) =>
      item.isNotEmpty,
    )
        .toList();

    Navigator.pop(
      context,
      CourseFormResult(
        name: name,
        trainerId: selectedTrainerId!,
        duration: duration,
        description: description,
        about: about,
        whatYouWillLearn:
        learningPoints,
      ),
    );
  }

  void showMessage(String message) {
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
    final List<TrainerData> activeTrainers =
    widget.trainers
        .where(
          (TrainerData trainer) =>
      trainer.isActive,
    )
        .toList();

    final bool selectedTrainerExists =
        selectedTrainerId == null ||
            activeTrainers.any(
                  (TrainerData trainer) =>
              trainer.id ==
                  selectedTrainerId,
            );

    if (!selectedTrainerExists) {
      selectedTrainerId = null;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),
      title: Text(
        isEditing
            ? 'Edit Course'
            : 'Add Course',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildField(
                controller: nameController,
                label: 'Course Name',
              ),
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
              buildField(
                controller:
                durationController,
                label: 'Duration',
                hintText:
                'Example: 6 Months',
              ),
              buildField(
                controller:
                descriptionController,
                label: 'Short Description',
                maxLines: 2,
              ),
              buildField(
                controller: aboutController,
                label: 'About Course',
                maxLines: 5,
              ),
              buildField(
                controller:
                learningController,
                label:
                'What You Will Learn',
                hintText:
                'Enter one learning point per line',
                maxLines: 6,
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor: Colors.white,
          ),
          child: Text(
            isEditing
                ? 'Save Changes'
                : 'Add Course',
          ),
        ),
      ],
    );
  }

  Widget buildField({
    required TextEditingController
    controller,
    required String label,
    String? hintText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: buildDecoration(
          label,
        ).copyWith(
          hintText: hintText,
          alignLabelWithHint:
          maxLines > 1,
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
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
    );
  }
}

class CourseModulesDialog
    extends StatefulWidget {
  final String courseId;

  const CourseModulesDialog({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseModulesDialog>
  createState() =>
      _CourseModulesDialogState();
}

class _CourseModulesDialogState
    extends State<CourseModulesDialog> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final AppData appData = AppData.instance;

  @override
  void initState() {
    super.initState();
    appData.addListener(refreshDialog);
  }

  @override
  void dispose() {
    appData.removeListener(refreshDialog);
    super.dispose();
  }

  void refreshDialog() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> openAddModuleDialog() async {
    final ModuleFormResult? result =
    await showDialog<ModuleFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const ModuleFormDialog();
      },
    );

    if (!mounted || result == null) {
      return;
    }

    appData.addCourseModule(
      courseId: widget.courseId,
      title: result.title,
      description: result.description,
    );
  }

  Future<void> openEditModuleDialog(
      CourseModuleData module,
      ) async {
    final ModuleFormResult? result =
    await showDialog<ModuleFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ModuleFormDialog(
          module: module,
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    appData.updateCourseModule(
      courseId: widget.courseId,
      moduleId: module.id,
      title: result.title,
      description: result.description,
    );
  }

  Future<void> confirmDeleteModule(
      CourseModuleData module,
      ) async {
    final bool? shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (
          BuildContext dialogContext,
          ) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Module',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${module.title}?',
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
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
                foregroundColor:
                Colors.white,
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

    appData.deleteCourseModule(
      courseId: widget.courseId,
      moduleId: module.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final CourseData? course =
    appData.findCourseById(
      widget.courseId,
    );

    if (course == null) {
      return AlertDialog(
        title: const Text('Course Not Found'),
        content: const Text(
          'This course is no longer available.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),
      titlePadding:
      const EdgeInsets.fromLTRB(
        20,
        18,
        12,
        10,
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Modules',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  course.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: openAddModuleDialog,
            tooltip: 'Add Module',
            icon: const Icon(
              Icons.add_circle_outline,
              color: darkBlue,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height:
        MediaQuery.sizeOf(context)
            .height *
            0.58,
        child: course.modules.isEmpty
            ? const Center(
          child: Text(
            'No modules added yet',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        )
            : ReorderableListView.builder(
          itemCount:
          course.modules.length,
          onReorder: (
              int oldIndex,
              int newIndex,
              ) {
            appData.reorderCourseModules(
              courseId:
              course.id,
              oldIndex: oldIndex,
              newIndex: newIndex,
            );
          },
          itemBuilder: (
              BuildContext context,
              int index,
              ) {
            final CourseModuleData
            module =
            course.modules[index];

            return Container(
              key: ValueKey(
                module.id,
              ),
              margin:
              const EdgeInsets.only(
                bottom: 10,
              ),
              padding:
              const EdgeInsets.all(
                12,
              ),
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFF8FAFC,
                ),
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                border: Border.all(
                  color: const Color(
                    0xFFE5E7EB,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  const Padding(
                    padding:
                    EdgeInsets.only(
                      top: 10,
                      right: 8,
                    ),
                    child: Icon(
                      Icons.drag_handle,
                      color:
                      Colors.black38,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          '${index + 1}. ${module.title}',
                          style:
                          const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight
                                .w600,
                            color: Color(
                              0xFF1F2937,
                            ),
                          ),
                        ),
                        if (module
                            .description
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            module
                                .description,
                            style:
                            const TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Switch(
                    value:
                    module.isActive,
                    activeThumbColor:
                    darkBlue,
                    activeTrackColor:
                    teal.withValues(
                      alpha: 0.45,
                    ),
                    onChanged: (
                        bool value,
                        ) {
                      appData
                          .updateCourseModuleStatus(
                        courseId:
                        course.id,
                        moduleId:
                        module.id,
                        isActive:
                        value,
                      );
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (
                        String value,
                        ) {
                      if (value ==
                          'edit') {
                        openEditModuleDialog(
                          module,
                        );
                        return;
                      }

                      if (value ==
                          'delete') {
                        confirmDeleteModule(
                          module,
                        );
                      }
                    },
                    itemBuilder: (
                        BuildContext
                        context,
                        ) {
                      return const [
                        PopupMenuItem<
                            String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .edit_outlined,
                                size: 18,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<
                            String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .delete_outline,
                                size: 18,
                                color:
                                Colors.red,
                              ),
                              SizedBox(
                                width: 8,
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
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class ModuleFormDialog
    extends StatefulWidget {
  final CourseModuleData? module;

  const ModuleFormDialog({
    super.key,
    this.module,
  });

  @override
  State<ModuleFormDialog> createState() =>
      _ModuleFormDialogState();
}

class _ModuleFormDialogState
    extends State<ModuleFormDialog> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  late final TextEditingController
  titleController;
  late final TextEditingController
  descriptionController;

  bool get isEditing => widget.module != null;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.module?.title ?? '',
    );

    descriptionController =
        TextEditingController(
          text:
          widget.module?.description ?? '',
        );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void submit() {
    final String title =
    titleController.text.trim();

    final String description =
    descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter module title',
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
      return;
    }

    Navigator.pop(
      context,
      ModuleFormResult(
        title: title,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),
      title: Text(
        isEditing
            ? 'Edit Module'
            : 'Add Module',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration:
                buildDecoration(
                  'Module Title',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller:
                descriptionController,
                maxLines: 4,
                decoration:
                buildDecoration(
                  'Module Description',
                ).copyWith(
                  alignLabelWithHint: true,
                ),
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor: Colors.white,
          ),
          child: Text(
            isEditing
                ? 'Save Changes'
                : 'Add Module',
          ),
        ),
      ],
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
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
    );
  }
}

class CourseFormResult {
  final String name;
  final String trainerId;
  final String duration;
  final String description;
  final String about;
  final List<String> whatYouWillLearn;

  const CourseFormResult({
    required this.name,
    required this.trainerId,
    required this.duration,
    required this.description,
    required this.about,
    required this.whatYouWillLearn,
  });
}

class ModuleFormResult {
  final String title;
  final String description;

  const ModuleFormResult({
    required this.title,
    required this.description,
  });
}

