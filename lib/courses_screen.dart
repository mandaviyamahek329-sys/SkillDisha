import 'package:flutter/material.dart';

import 'app_data.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor = Color(0xFFF6F8FA);

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

  @override
  Widget build(BuildContext context) {
    final StudentData? student = appData.currentStudentOrNull;

    if (student == null) {
      return buildPage(
        body: buildNoStudentState(),
      );
    }

    if (student.courseId.trim().isEmpty) {
      return buildPage(
        body: buildNoCourseState(),
      );
    }

    final CourseData? course = appData.findCourseById(
      student.courseId,
    );

    if (course == null) {
      return buildPage(
        body: buildNoCourseState(),
      );
    }

    final TrainerData? trainer = student.trainerId.trim().isEmpty
        ? appData.findTrainerById(course.trainerId)
        : appData.findTrainerById(student.trainerId);

    final BatchData? batch = student.batchId.trim().isEmpty
        ? null
        : appData.findBatchById(student.batchId);

    return buildPage(
      body: buildCourseContent(
        student: student,
        course: course,
        trainer: trainer,
        batch: batch,
      ),
    );
  }

  Widget buildPage({
    required Widget body,
  }) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'My Course',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget buildNoStudentState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 34,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline,
                size: 62,
                color: darkBlue,
              ),
              SizedBox(height: 16),
              Text(
                'Student Not Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please log in again to view your course.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoCourseState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 34,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 62,
                color: darkBlue,
              ),
              SizedBox(height: 16),
              Text(
                'No Course Assigned',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your assigned course will appear here after the admin assigns it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCourseContent({
    required StudentData student,
    required CourseData course,
    required TrainerData? trainer,
    required BatchData? batch,
  }) {
    final List<String> learningPoints = course.whatYouWillLearn
        .where(
          (String item) => item.trim().isNotEmpty,
    )
        .toList();

    final List<CourseModuleData> activeModules = course.modules
        .where(
          (CourseModuleData module) => module.isActive,
    )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCourseHeader(
            course: course,
          ),
          const SizedBox(height: 16),

          buildAssignmentCard(
            student: student,
            course: course,
            trainer: trainer,
            batch: batch,
          ),

          const SizedBox(height: 16),

          buildSectionCard(
            title: 'About Course',
            icon: Icons.info_outline,
            child: Text(
              getAboutText(course),
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF4B5563),
              ),
            ),
          ),

          const SizedBox(height: 16),

          buildLearningSection(
            learningPoints,
          ),

          const SizedBox(height: 16),

          buildModulesSection(
            activeModules,
          ),

          const SizedBox(height: 16),

          buildProgressSection(
            activeModules,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: activeModules.isEmpty
                  ? null
                  : () {
                showMessage(
                  'Course learning content will be available here.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                const Color(0xFFD1D5DB),
                disabledForegroundColor:
                const Color(0xFF6B7280),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.play_circle_outline,
              ),
              label: const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCourseHeader({
    required CourseData course,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            darkBlue,
            Color(0xFF0A6A8F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.16,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'YOUR COURSE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFFBFE5E8),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            course.name,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: Colors.white,
            ),
          ),
          if (course.description.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              course.description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFFE5F4F5),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              buildHeaderChip(
                icon: Icons.schedule_outlined,
                text: course.duration.trim().isEmpty
                    ? 'Duration Not Available'
                    : course.duration,
              ),
              buildHeaderChip(
                icon: course.isActive
                    ? Icons.check_circle_outline
                    : Icons.pause_circle_outline,
                text: course.isActive
                    ? 'Active Course'
                    : 'Inactive Course',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeaderChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.14,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAssignmentCard({
    required StudentData student,
    required CourseData course,
    required TrainerData? trainer,
    required BatchData? batch,
  }) {
    return buildSectionCard(
      title: 'Course Information',
      icon: Icons.assignment_ind_outlined,
      child: Column(
        children: [
          buildInformationRow(
            icon: Icons.menu_book_outlined,
            title: 'Course',
            value: course.name,
          ),
          buildDivider(),
          buildInformationRow(
            icon: Icons.person_outline,
            title: 'Trainer',
            value: trainer?.name ?? 'Not Assigned',
          ),
          buildDivider(),
          buildInformationRow(
            icon: Icons.groups_outlined,
            title: 'Batch',
            value: batch?.name ?? 'Not Assigned',
          ),
          buildDivider(),
          buildInformationRow(
            icon: Icons.access_time_outlined,
            title: 'Batch Timing',
            value: batch?.timing ?? 'Not Assigned',
          ),
          buildDivider(),
          buildInformationRow(
            icon: Icons.calendar_today_outlined,
            title: 'Batch Days',
            value: batch?.days ?? 'Not Assigned',
          ),
          buildDivider(),
          buildInformationRow(
            icon: Icons.meeting_room_outlined,
            title: 'Room',
            value: batch?.room ?? 'Not Assigned',
          ),
          buildDivider(),
          buildInformationRow(
            icon: Icons.timelapse_outlined,
            title: 'Duration',
            value: course.duration.trim().isEmpty
                ? 'Not Available'
                : course.duration,
          ),
          if (student.rollNumber.trim().isNotEmpty) ...[
            buildDivider(),
            buildInformationRow(
              icon: Icons.badge_outlined,
              title: 'Roll Number',
              value: student.rollNumber,
            ),
          ],
          if (student.joiningDate.trim().isNotEmpty) ...[
            buildDivider(),
            buildInformationRow(
              icon: Icons.event_available_outlined,
              title: 'Joining Date',
              value: student.joiningDate,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildLearningSection(
      List<String> learningPoints,
      ) {
    return buildSectionCard(
      title: 'What You Will Learn',
      icon: Icons.lightbulb_outline,
      child: learningPoints.isEmpty
          ? const Text(
        'Learning points have not been added yet.',
        style: TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
      )
          : Column(
        children: List<Widget>.generate(
          learningPoints.length,
              (int index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                index == learningPoints.length - 1
                    ? 0
                    : 12,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 15,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 2),
                      child: Text(
                        learningPoints[index],
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildModulesSection(
      List<CourseModuleData> modules,
      ) {
    return buildSectionCard(
      title: 'Course Modules',
      icon: Icons.view_list_outlined,
      child: modules.isEmpty
          ? const Text(
        'Course modules have not been added yet.',
        style: TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
      )
          : Column(
        children: List<Widget>.generate(
          modules.length,
              (int index) {
            final CourseModuleData module =
            modules[index];

            return Container(
              margin: EdgeInsets.only(
                bottom:
                index == modules.length - 1
                    ? 0
                    : 10,
              ),
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
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F5),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(0xFF1F2937),
                          ),
                        ),
                        if (module.description
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            module.description,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.45,
                              color:
                              Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildProgressSection(
      List<CourseModuleData> modules,
      ) {
    return buildSectionCard(
      title: 'Course Progress',
      icon: Icons.trending_up_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Learning Progress',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Text(
                modules.isEmpty ? '0%' : '0%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 8,
              backgroundColor:
              const Color(0xFFE5E7EB),
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                teal,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            modules.isEmpty
                ? 'No active modules are available yet.'
                : '${modules.length} active modules available',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: darkBlue,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget buildInformationRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.trim().isEmpty
                      ? 'Not Assigned'
                      : value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Divider(
        height: 1,
        color: Color(0xFFEEF0F2),
      ),
    );
  }

  String getAboutText(
      CourseData course,
      ) {
    if (course.about.trim().isNotEmpty) {
      return course.about;
    }

    if (course.description.trim().isNotEmpty) {
      return course.description;
    }

    return 'Course information has not been added yet.';
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
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}