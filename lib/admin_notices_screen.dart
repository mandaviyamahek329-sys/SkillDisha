import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminNoticesScreen extends StatefulWidget {
  const AdminNoticesScreen({super.key});

  @override
  State<AdminNoticesScreen> createState() =>
      _AdminNoticesScreenState();
}

class _AdminNoticesScreenState extends State<AdminNoticesScreen> {
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

  List<NoticeData> get filteredNotices {
    final String query = searchQuery.trim().toLowerCase();

    final List<NoticeData> result =
    List<NoticeData>.from(appData.notices);

    result.sort(
          (a, b) => b.publishedDate.compareTo(a.publishedDate),
    );

    if (query.isEmpty) {
      return result;
    }

    return result.where((notice) {
      final String courseName =
      appData.getCourseName(notice.courseId);

      final String batchName =
      appData.getBatchName(notice.batchId);

      return notice.id.toLowerCase().contains(query) ||
          notice.title.toLowerCase().contains(query) ||
          notice.description.toLowerCase().contains(query) ||
          notice.audience.toLowerCase().contains(query) ||
          courseName.toLowerCase().contains(query) ||
          batchName.toLowerCase().contains(query) ||
          notice.publishedDate.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<NoticeData> notices = filteredNotices;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Notices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddNotice,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Notice',
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
              child: notices.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  100,
                ),
                itemCount: notices.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return buildNoticeCard(
                    notices[index],
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
          hintText: 'Search notices',
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
    final bool isSearching = searchQuery.trim().isNotEmpty;

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
                    : Icons.campaign_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isSearching
                  ? 'No Notices Found'
                  : 'No Notices Available',
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
                  : 'Create the first notice.',
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

  Widget buildNoticeCard(NoticeData notice) {
    final String audienceDetails =
    getAudienceDetails(notice);

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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.campaign_outlined,
                  color: darkBlue,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 6),
                    buildBadge(
                      notice.audience,
                      darkBlue,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    openEditNotice(notice);
                  }

                  if (value == 'delete') {
                    confirmDelete(notice);
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
          const SizedBox(height: 14),
          Text(
            notice.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 15),
          buildInfoRow(
            Icons.badge_outlined,
            'Notice ID',
            notice.id,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.groups_outlined,
            'Audience',
            audienceDetails,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.calendar_today_outlined,
            'Published',
            notice.publishedDate,
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  notice.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: notice.isActive
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
              ),
              Switch(
                value: notice.isActive,
                activeThumbColor: darkBlue,
                onChanged: (value) {
                  appData.updateNoticeStatus(
                    noticeId: notice.id,
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

  Widget buildBadge(
      String text,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: darkBlue,
        ),
        const SizedBox(width: 9),
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

  String getAudienceDetails(
      NoticeData notice,
      ) {
    if (notice.audience == 'All Students') {
      return 'All Students';
    }

    if (notice.audience == 'Course') {
      return appData.getCourseName(
        notice.courseId,
      );
    }

    if (notice.audience == 'Batch') {
      return appData.getBatchName(
        notice.batchId,
      );
    }

    return notice.audience;
  }

  Future<void> openAddNotice() async {
    final bool? saved =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const NoticeFormDialog();
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage(
      'Notice added successfully',
    );
  }

  Future<void> openEditNotice(
      NoticeData notice,
      ) async {
    final bool? saved =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return NoticeFormDialog(
          notice: notice,
        );
      },
    );

    if (!mounted || saved != true) {
      return;
    }

    showMessage(
      'Notice updated successfully',
    );
  }

  Future<void> confirmDelete(
      NoticeData notice,
      ) async {
    final bool? confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Notice',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this notice?',
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
    appData.deleteNotice(
      notice.id,
    );

    showMessage(
      deleted
          ? 'Notice deleted successfully'
          : 'Unable to delete notice',
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

class NoticeFormDialog extends StatefulWidget {
  final NoticeData? notice;

  const NoticeFormDialog({
    super.key,
    this.notice,
  });

  @override
  State<NoticeFormDialog> createState() =>
      _NoticeFormDialogState();
}

class _NoticeFormDialogState extends State<NoticeFormDialog> {
  static const Color darkBlue =
  Color(0xFF075273);

  final AppData appData =
      AppData.instance;

  late final TextEditingController
  titleController;

  late final TextEditingController
  descriptionController;

  late final TextEditingController
  publishedDateController;

  String selectedAudience =
      'All Students';

  String? selectedCourseId;
  String? selectedBatchId;

  bool get isEditing =>
      widget.notice != null;

  final List<String> audiences = const [
    'All Students',
    'Course',
    'Batch',
  ];

  @override
  void initState() {
    super.initState();

    final NoticeData? notice =
        widget.notice;

    titleController =
        TextEditingController(
          text: notice?.title ?? '',
        );

    descriptionController =
        TextEditingController(
          text: notice?.description ?? '',
        );

    publishedDateController =
        TextEditingController(
          text: notice?.publishedDate ?? '',
        );

    selectedAudience =
        notice?.audience ??
            'All Students';

    selectedCourseId =
    notice?.courseId.isNotEmpty ==
        true
        ? notice!.courseId
        : null;

    selectedBatchId =
    notice?.batchId.isNotEmpty ==
        true
        ? notice!.batchId
        : null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    publishedDateController.dispose();
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
        BorderRadius.circular(20),
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
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.all(
                  18,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    buildLabel('Title'),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      titleController,
                      decoration:
                      inputDecoration(
                        'Enter notice title',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel(
                      'Description',
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      descriptionController,
                      maxLines: 5,
                      decoration:
                      inputDecoration(
                        'Enter notice description',
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildLabel('Audience'),
                    const SizedBox(height: 7),
                    DropdownButtonFormField<
                        String>(
                      value:
                      selectedAudience,
                      isExpanded: true,
                      decoration:
                      inputDecoration(
                        'Select audience',
                      ),
                      items:
                      audiences.map(
                            (audience) {
                          return DropdownMenuItem<
                              String>(
                            value: audience,
                            child: Text(
                              audience,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedAudience =
                              value;

                          if (value !=
                              'Course') {
                            selectedCourseId =
                            null;
                          }

                          if (value !=
                              'Batch') {
                            selectedBatchId =
                            null;
                          }
                        });
                      },
                    ),
                    if (selectedAudience ==
                        'Course') ...[
                      const SizedBox(
                        height: 16,
                      ),
                      buildLabel('Course'),
                      const SizedBox(
                        height: 7,
                      ),
                      buildCourseDropdown(),
                    ],
                    if (selectedAudience ==
                        'Batch') ...[
                      const SizedBox(
                        height: 16,
                      ),
                      buildLabel('Batch'),
                      const SizedBox(
                        height: 7,
                      ),
                      buildBatchDropdown(),
                    ],
                    const SizedBox(height: 16),
                    buildLabel(
                      'Published Date',
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller:
                      publishedDateController,
                      readOnly: true,
                      onTap:
                      selectPublishedDate,
                      decoration:
                      inputDecoration(
                        'Select published date',
                      ).copyWith(
                        suffixIcon:
                        const Icon(
                          Icons
                              .calendar_today_outlined,
                        ),
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
              Icons.campaign_outlined,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Notice'
                  : 'Add Notice',
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
            icon: const Icon(
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
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget buildCourseDropdown() {
    return DropdownButtonFormField<
        String>(
      value: selectedCourseId,
      isExpanded: true,
      decoration:
      inputDecoration(
        'Select course',
      ),
      items: appData.courses
          .where(
            (course) =>
        course.isActive,
      )
          .map(
            (course) =>
            DropdownMenuItem<String>(
              value: course.id,
              child: Text(
                course.name,
                overflow:
                TextOverflow.ellipsis,
              ),
            ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCourseId = value;
        });
      },
    );
  }

  Widget buildBatchDropdown() {
    return DropdownButtonFormField<
        String>(
      value: selectedBatchId,
      isExpanded: true,
      decoration:
      inputDecoration(
        'Select batch',
      ),
      items: appData.batches
          .where(
            (batch) =>
        batch.isActive,
      )
          .map(
            (batch) =>
            DropdownMenuItem<String>(
              value: batch.id,
              child: Text(
                '${batch.name} - ${appData.getCourseName(batch.courseId)}',
                overflow:
                TextOverflow.ellipsis,
              ),
            ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedBatchId = value;
        });
      },
    );
  }

  Future<void>
  selectPublishedDate() async {
    final DateTime now =
    DateTime.now();

    DateTime initialDate = now;

    final DateTime? existingDate =
    DateTime.tryParse(
      publishedDateController.text
          .trim(),
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

    publishedDateController.text =
    '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';
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
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color:
          Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide:
        const BorderSide(
          color:
          Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
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
      const EdgeInsets.all(16),
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
              OutlinedButton.styleFrom(
                foregroundColor:
                darkBlue,
                padding:
                const EdgeInsets
                    .symmetric(
                  vertical: 13,
                ),
              ),
              child: const Text(
                'Cancel',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: saveNotice,
              style:
              ElevatedButton.styleFrom(
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

  void saveNotice() {
    final String title =
    titleController.text.trim();

    final String description =
    descriptionController.text.trim();

    final String publishedDate =
    publishedDateController.text.trim();

    if (title.isEmpty) {
      showDialogMessage(
        'Please enter notice title',
      );
      return;
    }

    if (description.isEmpty) {
      showDialogMessage(
        'Please enter notice description',
      );
      return;
    }

    if (publishedDate.isEmpty) {
      showDialogMessage(
        'Please select published date',
      );
      return;
    }

    if (selectedAudience ==
        'Course' &&
        selectedCourseId == null) {
      showDialogMessage(
        'Please select a course',
      );
      return;
    }

    if (selectedAudience ==
        'Batch' &&
        selectedBatchId == null) {
      showDialogMessage(
        'Please select a batch',
      );
      return;
    }

    if (isEditing) {
      final bool updated =
      appData.updateNotice(
        noticeId:
        widget.notice!.id,
        title: title,
        description: description,
        audience:
        selectedAudience,
        courseId:
        selectedCourseId ?? '',
        batchId:
        selectedBatchId ?? '',
        publishedDate:
        publishedDate,
      );

      if (!updated) {
        showDialogMessage(
          'Unable to update notice',
        );
        return;
      }

      Navigator.pop(
        context,
        true,
      );

      return;
    }

    final NoticeData? notice =
    appData.addNotice(
      title: title,
      description: description,
      audience: selectedAudience,
      courseId:
      selectedCourseId ?? '',
      batchId:
      selectedBatchId ?? '',
      publishedDate:
      publishedDate,
    );

    if (notice == null) {
      showDialogMessage(
        'Unable to add notice',
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