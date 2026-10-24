import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminCertificatesScreen extends StatefulWidget {
  const AdminCertificatesScreen({super.key});

  @override
  State<AdminCertificatesScreen> createState() =>
      _AdminCertificatesScreenState();
}

class _AdminCertificatesScreenState
    extends State<AdminCertificatesScreen> {
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

  List<CertificateData> get filteredCertificates {
    final List<CertificateData> certificates =
    List<CertificateData>.from(
      appData.certificates,
    );

    certificates.sort(
          (a, b) => b.issueDate.compareTo(a.issueDate),
    );

    final String query =
    searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return certificates;
    }

    return certificates.where((certificate) {
      final StudentData? student =
      appData.findStudentById(
        certificate.studentId,
      );

      final String studentName =
          student?.fullName ?? '';

      final String courseName =
      appData.getCourseName(
        certificate.courseId,
      );

      final String batchName =
      appData.getBatchName(
        certificate.batchId,
      );

      return certificate.id
          .toLowerCase()
          .contains(query) ||
          certificate.title
              .toLowerCase()
              .contains(query) ||
          certificate.certificateNumber
              .toLowerCase()
              .contains(query) ||
          certificate.issueDate
              .toLowerCase()
              .contains(query) ||
          studentName
              .toLowerCase()
              .contains(query) ||
          courseName
              .toLowerCase()
              .contains(query) ||
          batchName
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<CertificateData> certificates =
        filteredCertificates;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Certificates',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddCertificate,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Certificate',
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
              child: certificates.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  100,
                ),
                itemCount: certificates.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return buildCertificateCard(
                    certificates[index],
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
          hintText: 'Search certificates',
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: searchQuery.trim().isEmpty
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
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildCertificateCard(
      CertificateData certificate,
      ) {
    final StudentData? student =
    appData.findStudentById(
      certificate.studentId,
    );

    final String studentName =
        student?.fullName ?? 'Student Not Found';

    final String courseName =
    appData.getCourseName(
      certificate.courseId,
    );

    final String batchName =
    appData.getBatchName(
      certificate.batchId,
    );

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
                  Icons.workspace_premium_outlined,
                  color: darkBlue,
                  size: 29,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditCertificate(
                      certificate,
                    );
                  }

                  if (value == 'delete') {
                    confirmDelete(
                      certificate,
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
          const SizedBox(height: 15),
          buildInfoRow(
            Icons.badge_outlined,
            'Certificate ID',
            certificate.id,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.confirmation_number_outlined,
            'Certificate No.',
            certificate.certificateNumber,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.person_outline,
            'Student',
            studentName,
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
            Icons.calendar_today_outlined,
            'Issue Date',
            certificate.issueDate,
          ),
          if (certificate.description.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
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
              certificate.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF374151),
              ),
            ),
          ],
          if (certificate.certificateUrl.trim().isNotEmpty) ...[
            const SizedBox(height: 13),
            buildInfoRow(
              Icons.link_outlined,
              'URL',
              certificate.certificateUrl,
            ),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  certificate.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: certificate.isActive
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
              ),
              Switch(
                value: certificate.isActive,
                activeThumbColor: darkBlue,
                onChanged: (value) {
                  appData.updateCertificateStatus(
                    certificateId: certificate.id,
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
          width: 105,
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
                    : Icons.workspace_premium_outlined,
                color: darkBlue,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'No Certificates Found'
                  : 'No Certificates Available',
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
                  : 'Create the first student certificate.',
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

  Future<void> openAddCertificate() async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const CertificateFormDialog();
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage(
      'Certificate added successfully',
    );
  }

  Future<void> openEditCertificate(
      CertificateData certificate,
      ) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CertificateFormDialog(
          certificate: certificate,
        );
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage(
      'Certificate updated successfully',
    );
  }

  Future<void> confirmDelete(
      CertificateData certificate,
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
            'Delete Certificate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete certificate ${certificate.certificateNumber}?',
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
    appData.deleteCertificate(
      certificate.id,
    );

    showMessage(
      deleted
          ? 'Certificate deleted successfully'
          : 'Unable to delete certificate',
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

class CertificateFormDialog extends StatefulWidget {
  final CertificateData? certificate;

  const CertificateFormDialog({
    super.key,
    this.certificate,
  });

  @override
  State<CertificateFormDialog> createState() =>
      _CertificateFormDialogState();
}

class _CertificateFormDialogState
    extends State<CertificateFormDialog> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  late final TextEditingController
  titleController;

  late final TextEditingController
  certificateNumberController;

  late final TextEditingController
  issueDateController;

  late final TextEditingController
  descriptionController;

  late final TextEditingController
  certificateUrlController;

  String? selectedStudentId;

  bool get isEditing =>
      widget.certificate != null;

  @override
  void initState() {
    super.initState();

    final CertificateData? certificate =
        widget.certificate;

    selectedStudentId =
        certificate?.studentId;

    titleController = TextEditingController(
      text: certificate?.title ?? '',
    );

    certificateNumberController =
        TextEditingController(
          text: certificate?.certificateNumber ?? '',
        );

    issueDateController = TextEditingController(
      text: certificate?.issueDate ?? '',
    );

    descriptionController = TextEditingController(
      text: certificate?.description ?? '',
    );

    certificateUrlController = TextEditingController(
      text: certificate?.certificateUrl ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    certificateNumberController.dispose();
    issueDateController.dispose();
    descriptionController.dispose();
    certificateUrlController.dispose();
    super.dispose();
  }

  List<StudentData> get availableStudents {
    final List<StudentData> students =
    appData.students
        .where(
          (student) =>
      student.isActive &&
          student.courseId.isNotEmpty,
    )
        .toList();

    students.sort(
          (a, b) => a.fullName.compareTo(
        b.fullName,
      ),
    );

    if (isEditing) {
      final StudentData? currentStudent =
      appData.findStudentById(
        widget.certificate!.studentId,
      );

      if (currentStudent != null &&
          !students.any(
                (student) =>
            student.id == currentStudent.id,
          )) {
        students.add(currentStudent);
      }
    }

    return students;
  }

  StudentData? get selectedStudent {
    if (selectedStudentId == null) {
      return null;
    }

    return appData.findStudentById(
      selectedStudentId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final StudentData? student =
        selectedStudent;

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
          maxHeight: 760,
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
                    buildLabel('Student'),
                    const SizedBox(height: 7),
                    buildStudentDropdown(),
                    if (student != null) ...[
                      const SizedBox(height: 14),
                      buildStudentDetails(
                        student,
                      ),
                    ],
                    const SizedBox(height: 16),
                    buildLabel(
                      'Certificate Title',
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller: titleController,
                      decoration: inputDecoration(
                        'Enter certificate title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel(
                      'Certificate Number',
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      certificateNumberController,
                      decoration: inputDecoration(
                        'Enter unique certificate number',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Issue Date'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: issueDateController,
                      readOnly: true,
                      onTap: selectIssueDate,
                      decoration: inputDecoration(
                        'Select issue date',
                      ).copyWith(
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                        ),
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
                        'Enter certificate description',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel(
                      'Certificate URL',
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      certificateUrlController,
                      keyboardType:
                      TextInputType.url,
                      decoration: inputDecoration(
                        'Enter certificate URL',
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
              Icons.workspace_premium_outlined,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Certificate'
                  : 'Add Certificate',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
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
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentDropdown() {
    final List<StudentData> students =
        availableStudents;

    return DropdownButtonFormField<String>(
      value: selectedStudentId,
      isExpanded: true,
      decoration: inputDecoration(
        'Select student',
      ),
      items: students.map((student) {
        return DropdownMenuItem<String>(
          value: student.id,
          child: Text(
            '${student.fullName} (${student.id})',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedStudentId = value;
        });
      },
    );
  }

  Widget buildStudentDetails(
      StudentData student,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          buildDetailRow(
            'Course',
            appData.getCourseName(
              student.courseId,
            ),
          ),
          const SizedBox(height: 7),
          buildDetailRow(
            'Batch',
            appData.getBatchName(
              student.batchId,
            ),
          ),
          if (student.rollNumber
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 7),
            buildDetailRow(
              'Roll Number',
              student.rollNumber,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildDetailRow(
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
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

  Future<void> selectIssueDate() async {
    DateTime initialDate = DateTime.now();

    final DateTime? existingDate =
    DateTime.tryParse(
      issueDateController.text.trim(),
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

    issueDateController.text =
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
              onPressed: saveCertificate,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
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

  void saveCertificate() {
    final String title =
    titleController.text.trim();

    final String certificateNumber =
    certificateNumberController.text.trim();

    final String issueDate =
    issueDateController.text.trim();

    final String description =
    descriptionController.text.trim();

    final String certificateUrl =
    certificateUrlController.text.trim();

    if (selectedStudentId == null) {
      showDialogMessage(
        'Please select a student',
      );
      return;
    }

    final StudentData? student =
    appData.findStudentById(
      selectedStudentId!,
    );

    if (student == null) {
      showDialogMessage(
        'Selected student was not found',
      );
      return;
    }

    if (student.courseId.trim().isEmpty) {
      showDialogMessage(
        'Please assign a course to the student first',
      );
      return;
    }

    if (title.isEmpty) {
      showDialogMessage(
        'Please enter certificate title',
      );
      return;
    }

    if (certificateNumber.isEmpty) {
      showDialogMessage(
        'Please enter certificate number',
      );
      return;
    }

    if (issueDate.isEmpty) {
      showDialogMessage(
        'Please select issue date',
      );
      return;
    }

    if (isEditing) {
      final bool updated =
      appData.updateCertificate(
        certificateId:
        widget.certificate!.id,
        studentId:
        selectedStudentId!,
        title: title,
        certificateNumber:
        certificateNumber,
        issueDate: issueDate,
        description: description,
        certificateUrl:
        certificateUrl,
      );

      if (!updated) {
        showDialogMessage(
          'Unable to update certificate. Certificate number may already exist.',
        );
        return;
      }

      Navigator.pop(
        context,
        true,
      );

      return;
    }

    final CertificateData? certificate =
    appData.addCertificate(
      studentId: selectedStudentId!,
      title: title,
      certificateNumber:
      certificateNumber,
      issueDate: issueDate,
      description: description,
      certificateUrl: certificateUrl,
    );

    if (certificate == null) {
      showDialogMessage(
        'Unable to add certificate. Certificate number may already exist.',
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