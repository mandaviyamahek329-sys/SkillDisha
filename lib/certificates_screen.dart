import 'package:flutter/material.dart';

import 'app_data.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() =>
      _CertificatesScreenState();
}

class _CertificatesScreenState
    extends State<CertificatesScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color backgroundColor = Color(0xFFF7F8FA);

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
        backgroundColor: backgroundColor,
        appBar: buildAppBar(),
        body: buildStudentNotFound(),
      );
    }

    final List<CertificateData> certificates =
    appData.getCertificatesForStudent(
      student.id,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildStudentHeader(student),
            Expanded(
              child: certificates.isEmpty
                  ? buildEmptyState()
                  : buildCertificateList(
                certificates,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
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
    );
  }

  Widget buildStudentHeader(
      StudentData student,
      ) {
    final String courseName =
    appData.getCourseName(
      student.courseId,
    );

    final String batchName =
    appData.getBatchName(
      student.batchId,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            darkBlue,
            Color(0xFF0B708F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withValues(
              alpha: 0.12,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.16,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  batchName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCertificateList(
      List<CertificateData> certificates,
      ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        26,
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
    );
  }

  Widget buildCertificateCard(
      CertificateData certificate,
      ) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4F7),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Text(
                        certificate.certificateNumber,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildInfoRow(
            Icons.confirmation_number_outlined,
            'Certificate No.',
            certificate.certificateNumber,
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
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.badge_outlined,
            'Certificate ID',
            certificate.id,
          ),
          if (certificate.description
              .trim()
              .isNotEmpty) ...[
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
          if (certificate.certificateUrl
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.link_outlined,
                    color: darkBlue,
                    size: 19,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      certificate.certificateUrl,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: darkBlue,
                        fontWeight: FontWeight.w600,
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
              child: const Icon(
                Icons.workspace_premium_outlined,
                color: darkBlue,
                size: 43,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Certificates Available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Your issued certificates will appear here.',
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

  Widget buildStudentNotFound() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Student information was not found.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}