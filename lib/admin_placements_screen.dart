import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminPlacementsScreen extends StatefulWidget {
  const AdminPlacementsScreen({super.key});

  @override
  State<AdminPlacementsScreen> createState() =>
      _AdminPlacementsScreenState();
}

class _AdminPlacementsScreenState
    extends State<AdminPlacementsScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color backgroundColor = Color(0xFFF7F8FA);

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

  List<PlacementData> get filteredPlacements {
    final List<PlacementData> placements =
    List<PlacementData>.from(appData.placements);

    placements.sort(
          (a, b) => b.lastDate.compareTo(a.lastDate),
    );

    final String query =
    searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return placements;
    }

    return placements.where((placement) {
      final String courseName =
      appData.getCourseName(placement.courseId);

      final String batchName =
      placement.batchId.isEmpty
          ? 'All Batches'
          : appData.getBatchName(placement.batchId);

      return placement.id.toLowerCase().contains(query) ||
          placement.companyName.toLowerCase().contains(query) ||
          placement.jobRole.toLowerCase().contains(query) ||
          placement.location.toLowerCase().contains(query) ||
          placement.jobType.toLowerCase().contains(query) ||
          placement.salary.toLowerCase().contains(query) ||
          placement.eligibility.toLowerCase().contains(query) ||
          courseName.toLowerCase().contains(query) ||
          batchName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<PlacementData> placements =
        filteredPlacements;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Placements',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddPlacement,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Placement',
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
              child: placements.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  100,
                ),
                itemCount: placements.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return buildPlacementCard(
                    placements[index],
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
          hintText: 'Search placements',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.trim().isEmpty
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
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildPlacementCard(
      PlacementData placement,
      ) {
    final String courseName =
    appData.getCourseName(placement.courseId);

    final String batchName =
    placement.batchId.isEmpty
        ? 'All Batches'
        : appData.getBatchName(placement.batchId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: darkBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      placement.companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      placement.jobRole,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditPlacement(placement);
                  } else if (value == 'delete') {
                    confirmDelete(placement);
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
            Icons.badge_outlined,
            'Placement ID',
            placement.id,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.location_on_outlined,
            'Location',
            placement.location,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.work_history_outlined,
            'Job Type',
            placement.jobType,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.currency_rupee,
            'Salary',
            placement.salary,
          ),
          const SizedBox(height: 9),
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
            Icons.event_outlined,
            'Last Date',
            placement.lastDate,
          ),
          if (placement.eligibility.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Eligibility',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              placement.eligibility,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF374151),
              ),
            ),
          ],
          if (placement.description.trim().isNotEmpty) ...[
            const SizedBox(height: 13),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              placement.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF374151),
              ),
            ),
          ],
          if (placement.applyUrl.trim().isNotEmpty) ...[
            const SizedBox(height: 13),
            buildInfoRow(
              Icons.link_outlined,
              'Apply URL',
              placement.applyUrl,
            ),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  placement.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: placement.isActive
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
              ),
              Switch(
                value: placement.isActive,
                activeThumbColor: darkBlue,
                onChanged: (value) {
                  appData.updatePlacementStatus(
                    placementId: placement.id,
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
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_outlined
                    : Icons.work_outline,
                color: darkBlue,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'No Placements Found'
                  : 'No Placements Available',
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
                  : 'Create the first placement opportunity.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openAddPlacement() async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PlacementFormDialog();
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage(
      'Placement added successfully',
    );
  }

  Future<void> openEditPlacement(
      PlacementData placement,
      ) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PlacementFormDialog(
          placement: placement,
        );
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage(
      'Placement updated successfully',
    );
  }

  Future<void> confirmDelete(
      PlacementData placement,
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
            'Delete Placement',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${placement.companyName} - ${placement.jobRole}?',
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
    appData.deletePlacement(
      placement.id,
    );

    showMessage(
      deleted
          ? 'Placement deleted successfully'
          : 'Unable to delete placement',
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

class PlacementFormDialog extends StatefulWidget {
  final PlacementData? placement;

  const PlacementFormDialog({
    super.key,
    this.placement,
  });

  @override
  State<PlacementFormDialog> createState() =>
      _PlacementFormDialogState();
}

class _PlacementFormDialogState
    extends State<PlacementFormDialog> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  late final TextEditingController
  companyNameController;
  late final TextEditingController
  jobRoleController;
  late final TextEditingController
  locationController;
  late final TextEditingController
  salaryController;
  late final TextEditingController
  eligibilityController;
  late final TextEditingController
  descriptionController;
  late final TextEditingController
  applyUrlController;
  late final TextEditingController
  lastDateController;

  String? selectedCourseId;
  String selectedBatchId = '';
  String selectedJobType = 'Full Time';

  final List<String> jobTypes = const [
    'Full Time',
    'Part Time',
    'Internship',
    'Contract',
  ];

  bool get isEditing =>
      widget.placement != null;

  @override
  void initState() {
    super.initState();

    final PlacementData? placement =
        widget.placement;

    selectedCourseId = placement?.courseId;
    selectedBatchId = placement?.batchId ?? '';

    final String existingJobType =
        placement?.jobType ?? '';

    selectedJobType =
    jobTypes.contains(existingJobType)
        ? existingJobType
        : 'Full Time';

    companyNameController =
        TextEditingController(
          text: placement?.companyName ?? '',
        );

    jobRoleController = TextEditingController(
      text: placement?.jobRole ?? '',
    );

    locationController = TextEditingController(
      text: placement?.location ?? '',
    );

    salaryController = TextEditingController(
      text: placement?.salary ?? '',
    );

    eligibilityController =
        TextEditingController(
          text: placement?.eligibility ?? '',
        );

    descriptionController =
        TextEditingController(
          text: placement?.description ?? '',
        );

    applyUrlController = TextEditingController(
      text: placement?.applyUrl ?? '',
    );

    lastDateController = TextEditingController(
      text: placement?.lastDate ?? '',
    );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    jobRoleController.dispose();
    locationController.dispose();
    salaryController.dispose();
    eligibilityController.dispose();
    descriptionController.dispose();
    applyUrlController.dispose();
    lastDateController.dispose();
    super.dispose();
  }

  List<CourseData> get availableCourses {
    final List<CourseData> courses =
    appData.courses
        .where((course) => course.isActive)
        .toList();

    if (isEditing) {
      final CourseData? currentCourse =
      appData.findCourseById(
        widget.placement!.courseId,
      );

      if (currentCourse != null &&
          !courses.any(
                (course) =>
            course.id == currentCourse.id,
          )) {
        courses.add(currentCourse);
      }
    }

    courses.sort(
          (a, b) => a.name.compareTo(b.name),
    );

    return courses;
  }

  List<BatchData> get availableBatches {
    if (selectedCourseId == null) {
      return <BatchData>[];
    }

    final List<BatchData> batches =
    appData.batches
        .where(
          (batch) =>
      batch.courseId ==
          selectedCourseId &&
          batch.isActive,
    )
        .toList();

    if (isEditing &&
        widget.placement!.batchId.isNotEmpty) {
      final BatchData? currentBatch =
      appData.findBatchById(
        widget.placement!.batchId,
      );

      if (currentBatch != null &&
          currentBatch.courseId ==
              selectedCourseId &&
          !batches.any(
                (batch) =>
            batch.id == currentBatch.id,
          )) {
        batches.add(currentBatch);
      }
    }

    batches.sort(
          (a, b) => a.name.compareTo(b.name),
    );

    return batches;
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
          maxHeight: 780,
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
                    buildLabel('Company Name'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      companyNameController,
                      decoration: inputDecoration(
                        'Enter company name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Job Role'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: jobRoleController,
                      decoration: inputDecoration(
                        'Enter job role',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Location'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      locationController,
                      decoration: inputDecoration(
                        'Enter job location',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Job Type'),
                    const SizedBox(height: 7),
                    DropdownButtonFormField<String>(
                      initialValue: selectedJobType,
                      isExpanded: true,
                      decoration: inputDecoration(
                        'Select job type',
                      ),
                      items: jobTypes.map((jobType) {
                        return DropdownMenuItem<String>(
                          value: jobType,
                          child: Text(jobType),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedJobType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Salary'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: salaryController,
                      decoration: inputDecoration(
                        'Enter salary or package',
                      ),
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
                    buildLabel('Last Date'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      lastDateController,
                      readOnly: true,
                      onTap: selectLastDate,
                      decoration: inputDecoration(
                        'Select last date',
                      ).copyWith(
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Eligibility'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      eligibilityController,
                      maxLines: 3,
                      decoration: inputDecoration(
                        'Enter eligibility criteria',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Description'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      descriptionController,
                      maxLines: 4,
                      decoration: inputDecoration(
                        'Enter job description',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Apply URL'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      applyUrlController,
                      keyboardType:
                      TextInputType.url,
                      decoration: inputDecoration(
                        'Enter application URL',
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
              Icons.work_outline,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Placement'
                  : 'Add Placement',
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

  Widget buildCourseDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedCourseId,
      isExpanded: true,
      decoration: inputDecoration(
        'Select course',
      ),
      items: availableCourses.map((course) {
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
      key: ValueKey(
        '$selectedCourseId-$selectedBatchId',
      ),
      initialValue: selectedBatchId,
      isExpanded: true,
      decoration: inputDecoration(
        'Select batch',
      ),
      items: [
        const DropdownMenuItem<String>(
          value: '',
          child: Text('All Batches'),
        ),
        ...availableBatches.map((batch) {
          return DropdownMenuItem<String>(
            value: batch.id,
            child: Text(
              batch.name,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
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

  Future<void> selectLastDate() async {
    DateTime initialDate = DateTime.now();

    final DateTime? existingDate =
    DateTime.tryParse(
      lastDateController.text.trim(),
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

    if (selectedDate == null) {
      return;
    }

    lastDateController.text =
    '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';
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
              onPressed: savePlacement,
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

  void savePlacement() {
    final String companyName =
    companyNameController.text.trim();

    final String jobRole =
    jobRoleController.text.trim();

    final String location =
    locationController.text.trim();

    final String salary =
    salaryController.text.trim();

    final String eligibility =
    eligibilityController.text.trim();

    final String description =
    descriptionController.text.trim();

    final String applyUrl =
    applyUrlController.text.trim();

    final String lastDate =
    lastDateController.text.trim();

    if (companyName.isEmpty) {
      showDialogMessage(
        'Please enter company name',
      );
      return;
    }

    if (jobRole.isEmpty) {
      showDialogMessage(
        'Please enter job role',
      );
      return;
    }

    if (location.isEmpty) {
      showDialogMessage(
        'Please enter job location',
      );
      return;
    }

    if (selectedCourseId == null) {
      showDialogMessage(
        'Please select a course',
      );
      return;
    }

    if (lastDate.isEmpty) {
      showDialogMessage(
        'Please select last date',
      );
      return;
    }

    if (isEditing) {
      final bool updated =
      appData.updatePlacement(
        placementId: widget.placement!.id,
        companyName: companyName,
        jobRole: jobRole,
        location: location,
        jobType: selectedJobType,
        salary: salary,
        eligibility: eligibility,
        description: description,
        applyUrl: applyUrl,
        lastDate: lastDate,
        courseId: selectedCourseId!,
        batchId: selectedBatchId,
      );

      if (!updated) {
        showDialogMessage(
          'Unable to update placement',
        );
        return;
      }

      Navigator.pop(context, true);
      return;
    }

    final PlacementData? placement =
    appData.addPlacement(
      companyName: companyName,
      jobRole: jobRole,
      location: location,
      jobType: selectedJobType,
      salary: salary,
      eligibility: eligibility,
      description: description,
      applyUrl: applyUrl,
      lastDate: lastDate,
      courseId: selectedCourseId!,
      batchId: selectedBatchId,
    );

    if (placement == null) {
      showDialogMessage(
        'Unable to add placement',
      );
      return;
    }

    Navigator.pop(context, true);
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