import 'package:flutter/material.dart';

import 'app_data.dart';

class StudyMaterialScreen extends StatefulWidget {
  const StudyMaterialScreen({super.key});

  @override
  State<StudyMaterialScreen> createState() =>
      _StudyMaterialScreenState();
}

class _StudyMaterialScreenState
    extends State<StudyMaterialScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final AppData appData = AppData.instance;

  @override
  void initState() {
    super.initState();
    appData.addListener(handleDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(handleDataChanged);
    super.dispose();
  }

  void handleDataChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final StudentData? student =
        appData.currentStudentOrNull;

    if (student == null) {
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
        body: const Center(
          child: Text(
            'Student Not Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final List<StudyMaterialData> materials =
    appData.getStudyMaterialsForStudent(
      student.id,
    );

    final CourseData? course =
    appData.findCourseById(student.courseId);

    final BatchData? batch =
    appData.findBatchById(student.batchId);

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
      body: SafeArea(
        child: Column(
          children: [
            buildStudentCourseHeader(
              course: course,
              batch: batch,
            ),
            Expanded(
              child: materials.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24,
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

  Widget buildStudentCourseHeader({
    required CourseData? course,
    required BatchData? batch,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
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
                    course?.name ?? 'No Course Assigned',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    batch?.name ?? 'No Batch Assigned',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12.5,
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

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
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
              child: const Icon(
                Icons.folder_open_outlined,
                size: 42,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Study Material Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Study material added for your course or batch will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
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

  Widget buildMaterialCard(
      StudyMaterialData material,
      ) {
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
                  color: getMaterialBackground(
                    material.materialType,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  getMaterialIcon(
                    material.materialType,
                  ),
                  color: getMaterialColor(
                    material.materialType,
                  ),
                  size: 26,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: teal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (material.description.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
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
            Icons.calendar_today_outlined,
            'Uploaded Date',
            material.uploadedDate.isEmpty
                ? 'Not Available'
                : material.uploadedDate,
          ),
          const SizedBox(height: 8),
          buildInfoRow(
            Icons.groups_outlined,
            'Available For',
            material.batchId.isEmpty
                ? 'All Batches'
                : appData.getBatchName(
              material.batchId,
            ),
          ),
          if (material.materialUrl.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.link,
                    size: 19,
                    color: darkBlue,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: SelectableText(
                      material.materialUrl,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          width: 96,
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

  Color getMaterialColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red.shade700;

      case 'video':
        return Colors.deepPurple;

      case 'document':
        return Colors.blue.shade700;

      case 'presentation':
        return Colors.orange.shade800;

      case 'website':
        return Colors.green.shade700;

      default:
        return darkBlue;
    }
  }

  Color getMaterialBackground(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red.withValues(
          alpha: 0.08,
        );

      case 'video':
        return Colors.deepPurple.withValues(
          alpha: 0.08,
        );

      case 'document':
        return Colors.blue.withValues(
          alpha: 0.08,
        );

      case 'presentation':
        return Colors.orange.withValues(
          alpha: 0.10,
        );

      case 'website':
        return Colors.green.withValues(
          alpha: 0.08,
        );

      default:
        return const Color(0xFFEAF4F7);
    }
  }
}