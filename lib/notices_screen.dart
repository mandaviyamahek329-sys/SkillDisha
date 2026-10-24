import 'package:flutter/material.dart';

import 'app_data.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor = Color(0xFFF7F8FA);

  final AppData appData = AppData.instance;
  final TextEditingController searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final StudentData? student = appData.currentStudentOrNull;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Notices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: student == null
          ? buildStudentNotFound()
          : buildNoticeContent(student),
    );
  }

  Widget buildNoticeContent(StudentData student) {
    final List<NoticeData> notices = getFilteredNotices(student);

    return SafeArea(
      child: Column(
        children: [
          buildStudentHeader(student),
          buildSearchBox(),
          Expanded(
            child: notices.isEmpty
                ? buildEmptyState()
                : buildNoticeList(notices),
          ),
        ],
      ),
    );
  }

  List<NoticeData> getFilteredNotices(StudentData student) {
    final List<NoticeData> notices =
    appData.getNoticesForStudent(student.id);

    final String query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return notices;
    }

    return notices.where((notice) {
      final String audienceName = getAudienceName(notice);

      return notice.title.toLowerCase().contains(query) ||
          notice.description.toLowerCase().contains(query) ||
          notice.id.toLowerCase().contains(query) ||
          notice.audience.toLowerCase().contains(query) ||
          audienceName.toLowerCase().contains(query) ||
          notice.publishedDate.toLowerCase().contains(query);
    }).toList();
  }

  Widget buildStudentHeader(StudentData student) {
    final String courseName = appData.getCourseName(
      student.courseId,
    );

    final String batchName = appData.getBatchName(
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
              Icons.campaign_outlined,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Institute Notices',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  courseName.trim().isEmpty
                      ? 'Course Not Assigned'
                      : courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  batchName.trim().isEmpty
                      ? 'Batch Not Assigned'
                      : batchName,
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

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        6,
        16,
        8,
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
          prefixIcon: const Icon(
            Icons.search,
            color: darkBlue,
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
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: darkBlue,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNoticeList(List<NoticeData> notices) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        28,
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
    );
  }

  Widget buildNoticeCard(NoticeData notice) {
    final String audienceName = getAudienceName(notice);

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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
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
                      notice.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 7),
                    buildAudienceBadge(
                      notice.audience,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            notice.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(
            height: 1,
            color: Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 13),
          buildInfoRow(
            Icons.groups_outlined,
            'For',
            audienceName,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.calendar_today_outlined,
            'Published',
            notice.publishedDate,
          ),
          const SizedBox(height: 9),
          buildInfoRow(
            Icons.badge_outlined,
            'Notice ID',
            notice.id,
          ),
        ],
      ),
    );
  }

  Widget buildAudienceBadge(String audience) {
    IconData icon;

    if (audience == 'Course') {
      icon = Icons.menu_book_outlined;
    } else if (audience == 'Batch') {
      icon = Icons.groups_outlined;
    } else {
      icon = Icons.people_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: darkBlue,
          ),
          const SizedBox(width: 5),
          Text(
            audience,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: darkBlue,
            ),
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
          size: 17,
          color: darkBlue,
        ),
        const SizedBox(width: 9),
        SizedBox(
          width: 72,
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

  String getAudienceName(NoticeData notice) {
    if (notice.audience == 'All Students') {
      return 'All Students';
    }

    if (notice.audience == 'Course') {
      final String courseName = appData.getCourseName(
        notice.courseId,
      );

      return courseName.trim().isEmpty
          ? 'Course'
          : courseName;
    }

    if (notice.audience == 'Batch') {
      final String batchName = appData.getBatchName(
        notice.batchId,
      );

      return batchName.trim().isEmpty
          ? 'Batch'
          : batchName;
    }

    return notice.audience;
  }

  Widget buildEmptyState() {
    final bool isSearching =
        searchQuery.trim().isNotEmpty;

    return Center(
      child: SingleChildScrollView(
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
                    : Icons.campaign_outlined,
                color: darkBlue,
                size: 42,
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
                  : 'New notices from the institute will appear here.',
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