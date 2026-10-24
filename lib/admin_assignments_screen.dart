import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminAssignmentsScreen extends StatefulWidget {
  const AdminAssignmentsScreen({super.key});

  @override
  State<AdminAssignmentsScreen> createState() =>
      _AdminAssignmentsScreenState();
}

class _AdminAssignmentsScreenState
    extends State<AdminAssignmentsScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

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

  List<AssignmentData> get filteredAssignments {
    final String query = searchQuery.trim().toLowerCase();

    final List<AssignmentData> items =
    List<AssignmentData>.from(
      appData.assignments,
    );

    items.sort(
          (a, b) => b.assignedDate.compareTo(a.assignedDate),
    );

    if (query.isEmpty) {
      return items;
    }

    return items.where((assignment) {
      final String courseName =
      appData.getCourseName(
        assignment.courseId,
      );

      final String batchName =
      assignment.batchId.isEmpty
          ? 'All Batches'
          : appData.getBatchName(
        assignment.batchId,
      );

      return assignment.title
          .toLowerCase()
          .contains(query) ||
          assignment.description
              .toLowerCase()
              .contains(query) ||
          courseName.toLowerCase().contains(query) ||
          batchName.toLowerCase().contains(query) ||
          assignment.assignedDate
              .toLowerCase()
              .contains(query) ||
          assignment.dueDate
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<AssignmentData> assignments =
        filteredAssignments;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddAssignment,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Assignment',
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
              child: assignments.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  100,
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
          hintText: 'Search assignments',
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: searchQuery.isEmpty
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
          fillColor: const Color(0xFFF7F8FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
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
                    : Icons.assignment_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'No Assignments Found'
                  : 'No Assignments Available',
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
                  : 'Create your first assignment for a course or batch.',
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

  Widget buildAssignmentCard(
      AssignmentData assignment,
      ) {
    final String courseName =
    appData.getCourseName(
      assignment.courseId,
    );

    final String batchName =
    assignment.batchId.isEmpty
        ? 'All Batches'
        : appData.getBatchName(
      assignment.batchId,
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
                      assignment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      assignment.id,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'More',
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditAssignment(
                      assignment,
                    );
                  } else if (value == 'delete') {
                    confirmDelete(
                      assignment,
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
          if (assignment.description.trim().isNotEmpty) ...[
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
            'Assigned',
            assignment.assignedDate,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.event_outlined,
            'Due Date',
            assignment.dueDate,
          ),
          if (assignment.attachmentUrl
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 9),
            buildInfoRow(
              Icons.link,
              'Attachment',
              assignment.attachmentUrl,
            ),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  assignment.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: assignment.isActive
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
              Switch(
                value: assignment.isActive,
                activeThumbColor: darkBlue,
                onChanged: (value) {
                  appData.updateAssignmentStatus(
                    assignmentId: assignment.id,
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
          width: 82,
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

  Future<void> openAddAssignment() async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const AssignmentFormDialog();
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage('Assignment added successfully');
  }

  Future<void> openEditAssignment(
      AssignmentData assignment,
      ) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AssignmentFormDialog(
          assignment: assignment,
        );
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage('Assignment updated successfully');
  }

  Future<void> confirmDelete(
      AssignmentData assignment,
      ) async {
    final bool? confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Assignment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${assignment.title}"?',
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
    appData.deleteAssignment(
      assignment.id,
    );

    if (!mounted) {
      return;
    }

    showMessage(
      deleted
          ? 'Assignment deleted successfully'
          : 'Unable to delete assignment',
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

class AssignmentFormDialog extends StatefulWidget {
  final AssignmentData? assignment;

  const AssignmentFormDialog({
    super.key,
    this.assignment,
  });

  @override
  State<AssignmentFormDialog> createState() =>
      _AssignmentFormDialogState();
}

class _AssignmentFormDialogState
    extends State<AssignmentFormDialog> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController assignedDateController;
  late final TextEditingController dueDateController;
  late final TextEditingController attachmentController;

  String? selectedCourseId;
  String selectedBatchId = '';

  bool get isEditing => widget.assignment != null;

  List<CourseData> get activeCourses {
    return appData.courses
        .where(
          (course) => course.isActive,
    )
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

    final AssignmentData? assignment =
        widget.assignment;

    titleController = TextEditingController(
      text: assignment?.title ?? '',
    );

    descriptionController =
        TextEditingController(
          text: assignment?.description ?? '',
        );

    assignedDateController =
        TextEditingController(
          text: assignment?.assignedDate ??
              formatDate(DateTime.now()),
        );

    dueDateController = TextEditingController(
      text: assignment?.dueDate ?? '',
    );

    attachmentController =
        TextEditingController(
          text: assignment?.attachmentUrl ?? '',
        );

    selectedCourseId = assignment?.courseId;

    selectedBatchId =
        assignment?.batchId ?? '';

    if (selectedCourseId == null &&
        activeCourses.isNotEmpty) {
      selectedCourseId = activeCourses.first.id;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    assignedDateController.dispose();
    dueDateController.dispose();
    attachmentController.dispose();
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
          maxHeight: 720,
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
                    buildLabel('Assignment Title'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: titleController,
                      hintText: 'Enter assignment title',
                    ),
                    const SizedBox(height: 16),

                    buildLabel('Course'),
                    const SizedBox(height: 7),
                    buildCourseDropdown(),
                    const SizedBox(height: 16),

                    buildLabel('Batch'),
                    const SizedBox(height: 7),
                    buildBatchDropdown(),
                    const SizedBox(height: 16),

                    buildLabel('Assigned Date'),
                    const SizedBox(height: 7),
                    buildDateField(
                      controller:
                      assignedDateController,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    ),
                    const SizedBox(height: 16),

                    buildLabel('Due Date'),
                    const SizedBox(height: 7),
                    buildDateField(
                      controller: dueDateController,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    ),
                    const SizedBox(height: 16),

                    buildLabel(
                      'Attachment / Reference Link',
                    ),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller: attachmentController,
                      hintText:
                      'Enter attachment or reference link',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),

                    buildLabel('Description'),
                    const SizedBox(height: 7),
                    buildTextField(
                      controller:
                      descriptionController,
                      hintText:
                      'Enter assignment description',
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
              Icons.assignment_outlined,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Assignment'
                  : 'Add Assignment',
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
      decoration: inputDecoration(
        hintText,
      ),
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
    final List<BatchData> batches =
        availableBatches;

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
        ...batches.map(
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
          selectedBatchId =
              value ?? '';
        });
      },
    );
  }

  Widget buildDateField({
    required TextEditingController controller,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: inputDecoration(
        'Select date',
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
          controller.text.trim(),
        );

        if (existingDate != null) {
          initialDate = existingDate;
        }

        final DateTime? selectedDate =
        await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (selectedDate == null ||
            !mounted) {
          return;
        }

        controller.text =
            formatDate(selectedDate);
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
                Navigator.pop(
                  context,
                  false,
                );
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
              onPressed: saveAssignment,
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

  void saveAssignment() {
    final String title =
    titleController.text.trim();

    final String assignedDate =
    assignedDateController.text.trim();

    final String dueDate =
    dueDateController.text.trim();

    if (title.isEmpty) {
      showDialogMessage(
        'Please enter assignment title',
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

    if (assignedDate.isEmpty) {
      showDialogMessage(
        'Please select assigned date',
      );
      return;
    }

    if (dueDate.isEmpty) {
      showDialogMessage(
        'Please select due date',
      );
      return;
    }

    final DateTime? assigned =
    DateTime.tryParse(assignedDate);

    final DateTime? due =
    DateTime.tryParse(dueDate);

    if (assigned != null &&
        due != null &&
        due.isBefore(assigned)) {
      showDialogMessage(
        'Due date cannot be before assigned date',
      );
      return;
    }

    if (isEditing) {
      appData.updateAssignment(
        assignmentId: widget.assignment!.id,
        title: title,
        description:
        descriptionController.text,
        courseId: selectedCourseId!,
        batchId: selectedBatchId,
        assignedDate: assignedDate,
        dueDate: dueDate,
        attachmentUrl:
        attachmentController.text,
      );

      Navigator.pop(context, true);
      return;
    }

    final AssignmentData? assignment =
    appData.addAssignment(
      title: title,
      description:
      descriptionController.text,
      courseId: selectedCourseId!,
      batchId: selectedBatchId,
      assignedDate: assignedDate,
      dueDate: dueDate,
      attachmentUrl:
      attachmentController.text,
    );

    if (assignment == null) {
      showDialogMessage(
        'Unable to add assignment',
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
}