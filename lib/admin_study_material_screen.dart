import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminStudyMaterialScreen extends StatefulWidget {
  const AdminStudyMaterialScreen({super.key});

  @override
  State<AdminStudyMaterialScreen> createState() =>
      _AdminStudyMaterialScreenState();
}

class _AdminStudyMaterialScreenState
    extends State<AdminStudyMaterialScreen> {
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

  List<StudyMaterialData> get filteredMaterials {
    final String query = searchQuery.trim().toLowerCase();

    final List<StudyMaterialData> materials =
    List<StudyMaterialData>.from(
      appData.studyMaterials,
    );

    materials.sort(
          (a, b) => b.uploadedDate.compareTo(a.uploadedDate),
    );

    if (query.isEmpty) {
      return materials;
    }

    return materials.where((material) {
      final String courseName =
      appData.getCourseName(material.courseId);

      final String batchName = material.batchId.isEmpty
          ? 'All Batches'
          : appData.getBatchName(material.batchId);

      return material.title.toLowerCase().contains(query) ||
          material.description.toLowerCase().contains(query) ||
          material.materialType.toLowerCase().contains(query) ||
          courseName.toLowerCase().contains(query) ||
          batchName.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> openAddMaterialDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const StudyMaterialFormDialog();
      },
    );
  }

  Future<void> openEditMaterialDialog(
      StudyMaterialData material,
      ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StudyMaterialFormDialog(
          material: material,
        );
      },
    );
  }

  Future<void> confirmDelete(
      StudyMaterialData material,
      ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Study Material',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${material.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final bool deleted =
    appData.deleteStudyMaterial(material.id);

    if (!mounted) {
      return;
    }

    showMessage(
      deleted
          ? 'Study material deleted successfully'
          : 'Unable to delete study material',
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<StudyMaterialData> materials =
        filteredMaterials;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Study Material',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddMaterialDialog,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Material',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                16,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText:
                  'Search material, course, batch, or type',
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: materials.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  100,
                ),
                itemCount: materials.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return buildMaterialCard(
                    materials[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    final bool hasSearch = searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              hasSearch
                  ? 'No Study Material Found'
                  : 'No Study Material Added',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Try a different search.'
                  : 'Add study material for a course or batch.',
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

  Widget buildMaterialCard(
      StudyMaterialData material,
      ) {
    final String courseName =
    appData.getCourseName(material.courseId);

    final String batchName = material.batchId.isEmpty
        ? 'All Batches'
        : appData.getBatchName(material.batchId);

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
                child: Icon(
                  getMaterialIcon(material.materialType),
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
                      material.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      material.materialType,
                      style: const TextStyle(
                        color: teal,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditMaterialDialog(material);
                  }

                  if (value == 'delete') {
                    confirmDelete(material);
                  }
                },
                itemBuilder: (context) {
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
          if (material.description.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              material.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.black54,
              ),
            ),
          ],
          const SizedBox(height: 14),
          buildInfoRow(
            Icons.menu_book_outlined,
            'Course',
            courseName,
          ),
          const SizedBox(height: 8),
          buildInfoRow(
            Icons.class_outlined,
            'Batch',
            batchName,
          ),
          const SizedBox(height: 8),
          buildInfoRow(
            Icons.calendar_today_outlined,
            'Uploaded Date',
            material.uploadedDate.isEmpty
                ? 'Not Available'
                : material.uploadedDate,
          ),
          if (material.materialUrl.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            buildInfoRow(
              Icons.link,
              'Material Link',
              material.materialUrl,
            ),
          ],
          const SizedBox(height: 14),
          const Divider(
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: material.isActive
                      ? Colors.green.withValues(
                    alpha: 0.10,
                  )
                      : Colors.red.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  material.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    color: material.isActive
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: material.isActive,
                activeTrackColor: teal,
                onChanged: (value) {
                  appData.updateStudyMaterialStatus(
                    materialId: material.id,
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
          width: 94,
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
            value,
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

  IconData getMaterialIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'video':
        return Icons.play_circle_outline;
      case 'document':
        return Icons.description_outlined;
      case 'presentation':
        return Icons.slideshow_outlined;
      case 'website':
        return Icons.language_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

class StudyMaterialFormDialog extends StatefulWidget {
  final StudyMaterialData? material;

  const StudyMaterialFormDialog({
    super.key,
    this.material,
  });

  @override
  State<StudyMaterialFormDialog> createState() =>
      _StudyMaterialFormDialogState();
}

class _StudyMaterialFormDialogState
    extends State<StudyMaterialFormDialog> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController materialUrlController;
  late final TextEditingController uploadedDateController;

  String? selectedCourseId;
  String selectedBatchId = '';
  String selectedMaterialType = 'PDF';

  final List<String> materialTypes = const [
    'PDF',
    'Document',
    'Video',
    'Presentation',
    'Website',
    'Other',
  ];

  bool get isEditing => widget.material != null;

  @override
  void initState() {
    super.initState();

    final StudyMaterialData? material =
        widget.material;

    titleController = TextEditingController(
      text: material?.title ?? '',
    );

    descriptionController = TextEditingController(
      text: material?.description ?? '',
    );

    materialUrlController = TextEditingController(
      text: material?.materialUrl ?? '',
    );

    uploadedDateController = TextEditingController(
      text: material?.uploadedDate ??
          formatDate(DateTime.now()),
    );

    selectedCourseId = material?.courseId;

    selectedBatchId =
        material?.batchId ?? '';

    if (material != null &&
        materialTypes.contains(material.materialType)) {
      selectedMaterialType = material.materialType;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    materialUrlController.dispose();
    uploadedDateController.dispose();
    super.dispose();
  }

  List<CourseData> get activeCourses {
    return appData.courses
        .where(
          (course) => course.isActive,
    )
        .toList();
  }

  List<BatchData> get availableBatches {
    if (selectedCourseId == null ||
        selectedCourseId!.isEmpty) {
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

  Future<void> selectUploadedDate() async {
    DateTime initialDate = DateTime.now();

    try {
      final List<String> parts =
      uploadedDateController.text.split('-');

      if (parts.length == 3) {
        initialDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (_) {
      initialDate = DateTime.now();
    }

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    uploadedDateController.text =
        formatDate(selectedDate);
  }

  String formatDate(DateTime date) {
    final String month =
    date.month.toString().padLeft(2, '0');

    final String day =
    date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  void saveMaterial() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedCourseId == null ||
        selectedCourseId!.isEmpty) {
      showMessage(
        'Please select a course',
      );
      return;
    }

    if (isEditing) {
      appData.updateStudyMaterial(
        materialId: widget.material!.id,
        title: titleController.text,
        description: descriptionController.text,
        courseId: selectedCourseId!,
        batchId: selectedBatchId,
        materialType: selectedMaterialType,
        materialUrl: materialUrlController.text,
        uploadedDate: uploadedDateController.text,
      );
    } else {
      final StudyMaterialData? material =
      appData.addStudyMaterial(
        title: titleController.text,
        description: descriptionController.text,
        courseId: selectedCourseId!,
        batchId: selectedBatchId,
        materialType: selectedMaterialType,
        materialUrl: materialUrlController.text,
        uploadedDate: uploadedDateController.text,
      );

      if (material == null) {
        showMessage(
          'Unable to save study material',
        );
        return;
      }
    }

    Navigator.pop(context);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<CourseData> courses = activeCourses;
    final List<BatchData> batches = availableBatches;

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
            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                12,
                18,
              ),
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Edit Study Material'
                          : 'Add Study Material',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      buildTextField(
                        controller: titleController,
                        label: 'Material Title',
                        hint: 'Enter material title',
                        icon: Icons.title,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter material title';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCourseId,
                        decoration: buildInputDecoration(
                          label: 'Course',
                          icon: Icons.menu_book_outlined,
                        ),
                        hint: const Text(
                          'Select Course',
                        ),
                        items: courses.map((course) {
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
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Please select a course';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: batches.any(
                              (batch) =>
                          batch.id == selectedBatchId,
                        )
                            ? selectedBatchId
                            : '',
                        decoration: buildInputDecoration(
                          label: 'Batch',
                          icon: Icons.class_outlined,
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text(
                              'All Batches',
                            ),
                          ),
                          ...batches.map(
                                (batch) {
                              return DropdownMenuItem<String>(
                                value: batch.id,
                                child: Text(
                                  batch.name,
                                  overflow:
                                  TextOverflow.ellipsis,
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
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedMaterialType,
                        decoration: buildInputDecoration(
                          label: 'Material Type',
                          icon:
                          Icons.insert_drive_file_outlined,
                        ),
                        items: materialTypes.map((type) {
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
                            selectedMaterialType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        controller: materialUrlController,
                        label: 'Material Link',
                        hint:
                        'Enter PDF, video, document, or website link',
                        icon: Icons.link,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        controller: uploadedDateController,
                        label: 'Uploaded Date',
                        hint: 'YYYY-MM-DD',
                        icon:
                        Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: selectUploadedDate,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please select uploaded date';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        controller: descriptionController,
                        label: 'Description',
                        hint:
                        'Enter study material description',
                        icon: Icons.notes_outlined,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                16,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize:
                        const Size.fromHeight(48),
                      ),
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: saveMaterial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        foregroundColor: Colors.white,
                        minimumSize:
                        const Size.fromHeight(48),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: buildInputDecoration(
        label: label,
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: darkBlue,
          width: 1.5,
        ),
      ),
    );
  }
}