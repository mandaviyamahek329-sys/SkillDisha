import 'package:flutter/material.dart';

import 'app_data.dart';

class PlacementsScreen extends StatefulWidget {
  const PlacementsScreen({super.key});

  @override
  State<PlacementsScreen> createState() =>
      _PlacementsScreenState();
}

class _PlacementsScreenState
    extends State<PlacementsScreen> {
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

  List<PlacementData> getFilteredPlacements(
      StudentData student,
      ) {
    final List<PlacementData> placements =
    appData.getPlacementsForStudent(
      student.id,
    );

    final String query =
    searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return placements;
    }

    return placements.where((placement) {
      return placement.companyName
          .toLowerCase()
          .contains(query) ||
          placement.jobRole
              .toLowerCase()
              .contains(query) ||
          placement.location
              .toLowerCase()
              .contains(query) ||
          placement.jobType
              .toLowerCase()
              .contains(query) ||
          placement.salary
              .toLowerCase()
              .contains(query) ||
          placement.eligibility
              .toLowerCase()
              .contains(query);
    }).toList();
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

    final List<PlacementData> placements =
    getFilteredPlacements(student);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildStudentHeader(student),
            buildSearchSection(),
            Expanded(
              child: placements.isEmpty
                  ? buildEmptyState()
                  : buildPlacementList(
                placements,
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
        'Placements',
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
              Icons.work_outline,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Placement Opportunities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
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

  Widget buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        6,
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
          fillColor: Colors.white,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlacementList(
      List<PlacementData> placements,
      ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        26,
      ),
      itemCount: placements.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        return buildPlacementCard(
          placements[index],
        );
      },
    );
  }

  Widget buildPlacementCard(
      PlacementData placement,
      ) {
    final String courseName =
    appData.getCourseName(
      placement.courseId,
    );

    final String batchName =
    placement.batchId.isEmpty
        ? 'All Batches'
        : appData.getBatchName(
      placement.batchId,
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
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.business_center_outlined,
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
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildJobTypeBadge(
                      placement.jobType,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          if (placement.eligibility
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            buildSectionTitle(
              'Eligibility',
            ),
            const SizedBox(height: 6),
            Text(
              placement.eligibility,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF374151),
              ),
            ),
          ],
          if (placement.description
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 14),
            buildSectionTitle(
              'Job Description',
            ),
            const SizedBox(height: 6),
            Text(
              placement.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF374151),
              ),
            ),
          ],
          if (placement.applyUrl
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius:
                BorderRadius.circular(13),
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
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Apply URL',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          placement.applyUrl,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: darkBlue,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
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

  Widget buildJobTypeBadge(
      String jobType,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        jobType.trim().isEmpty
            ? 'Job Opportunity'
            : jobType,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: darkBlue,
        ),
      ),
    );
  }

  Widget buildSectionTitle(
      String title,
      ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
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
                borderRadius:
                BorderRadius.circular(24),
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
                  : 'No Placement Opportunities',
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
                  : 'Placement opportunities for your course and batch will appear here.',
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