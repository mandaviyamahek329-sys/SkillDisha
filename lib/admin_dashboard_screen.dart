import 'package:flutter/material.dart';

import 'admin_assignments_screen.dart';
import 'admin_attendance_screen.dart';
import 'admin_batches_screen.dart';
import 'admin_certificates_screen.dart';
import 'admin_courses_screen.dart';
import 'admin_exams_screen.dart';
import 'admin_fees_screen.dart';
import 'admin_notices_screen.dart';
import 'admin_placements_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_results_screen.dart';
import 'admin_students_screen.dart';
import 'admin_study_material_screen.dart';
import 'app_data.dart';
import 'create_admin_login_screen.dart';
import 'create_student_login_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color backgroundColor = Color(0xFFF5F7F9);

  final AppData appData = AppData.instance;

  bool isStudentsMenuExpanded = false;
  bool isAdminsMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    appData.addListener(_handleDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(_handleDataChanged);
    super.dispose();
  }

  void _handleDataChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  int get totalStudents {
    return appData.students.length;
  }

  int get totalCourses {
    return appData.courses.length;
  }

  int get totalBatches {
    return appData.batches.length;
  }

  int get completedAdmissions {
    return appData.students
        .where((student) => student.admissionCompleted)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              _showMessage('No new notifications');
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            14,
            16,
            14,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 22),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              _buildOverviewGrid(),
              const SizedBox(height: 24),
              const Text(
                'Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              _buildManagementGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
            color: darkBlue.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Manage your institute from one place.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.white,
              size: 31,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.65,
      children: [
        _buildOverviewCard(
          title: 'Students',
          value: totalStudents.toString(),
          icon: Icons.people_outline,
        ),
        _buildOverviewCard(
          title: 'Courses',
          value: totalCourses.toString(),
          icon: Icons.menu_book_outlined,
        ),
        _buildOverviewCard(
          title: 'Batches',
          value: totalBatches.toString(),
          icon: Icons.groups_outlined,
        ),
        _buildOverviewCard(
          title: 'Admissions',
          value: completedAdmissions.toString(),
          icon: Icons.person_add_alt_1_outlined,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE1E5E9),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: darkBlue,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      mainAxisExtent: 105,
      children: [
        _buildManagementCard(
          title: 'Students',
          icon: Icons.people_outline,
          onTap: () {
            _openScreen(
              const AdminStudentsScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Courses',
          icon: Icons.menu_book_outlined,
          onTap: () {
            _openScreen(
              const AdminCoursesScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Batches',
          icon: Icons.groups_outlined,
          onTap: () {
            _openScreen(
              const AdminBatchesScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Attendance',
          icon: Icons.fact_check_outlined,
          onTap: () {
            _openScreen(
              const AdminAttendanceScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Fees',
          icon: Icons.payments_outlined,
          onTap: () {
            _openScreen(
              const AdminFeesScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Study Material',
          icon: Icons.library_books_outlined,
          onTap: () {
            _openScreen(
              const AdminStudyMaterialScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Assignments',
          icon: Icons.assignment_outlined,
          onTap: () {
            _openScreen(
              const AdminAssignmentsScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Exams / Tests',
          icon: Icons.quiz_outlined,
          onTap: () {
            _openScreen(
              const AdminExamsScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Results',
          icon: Icons.assessment_outlined,
          onTap: () {
            _openScreen(
              const AdminResultsScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Notices',
          icon: Icons.campaign_outlined,
          onTap: () {
            _openScreen(
              const AdminNoticesScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Certificates',
          icon: Icons.workspace_premium_outlined,
          onTap: () {
            _openScreen(
              const AdminCertificatesScreen(),
            );
          },
        ),
        _buildManagementCard(
          title: 'Placements',
          icon: Icons.business_center_outlined,
          onTap: () {
            _openScreen(
              const AdminPlacementsScreen(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildManagementCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE6ECEF),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: darkBlue,
                  size: 23,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 8,
                ),
                children: [
                  _buildDrawerItem(
                    title: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildStudentsMenu(),
                  _buildAdminsMenu(),
                  _buildDrawerItem(
                    title: 'Courses',
                    icon: Icons.menu_book_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminCoursesScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Batches',
                    icon: Icons.groups_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminBatchesScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Attendance',
                    icon: Icons.fact_check_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminAttendanceScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Fees',
                    icon: Icons.payments_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminFeesScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Study Material',
                    icon: Icons.library_books_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminStudyMaterialScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Assignments',
                    icon: Icons.assignment_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminAssignmentsScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Exams / Tests',
                    icon: Icons.quiz_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminExamsScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Results',
                    icon: Icons.assessment_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminResultsScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Notices',
                    icon: Icons.campaign_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminNoticesScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Certificates',
                    icon: Icons.workspace_premium_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminCertificatesScreen(),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    title: 'Placements',
                    icon: Icons.business_center_outlined,
                    onTap: () {
                      _closeDrawerAndOpen(
                        const AdminPlacementsScreen(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(9),
              child: _buildDrawerItem(
                title: 'Logout',
                icon: Icons.logout,
                color: Colors.red,
                onTap: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsMenu() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: ListTile(
            dense: true,
            onTap: () {
              setState(() {
                isStudentsMenuExpanded =
                !isStudentsMenuExpanded;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.people_outline,
              color: darkBlue,
              size: 22,
            ),
            title: const Text(
              'Students',
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isStudentsMenuExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.chevron_right,
              size: 20,
              color: Colors.black38,
            ),
          ),
        ),
        if (isStudentsMenuExpanded)
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 4,
              bottom: 4,
            ),
            child: ListTile(
              dense: true,
              onTap: () {
                _closeDrawerAndOpen(
                  const CreateStudentLoginScreen(),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(
                Icons.person_add_alt_1_outlined,
                color: darkBlue,
                size: 20,
              ),
              title: const Text(
                'Create Student Login',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAdminsMenu() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: ListTile(
            dense: true,
            onTap: () {
              setState(() {
                isAdminsMenuExpanded =
                !isAdminsMenuExpanded;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(
              Icons.admin_panel_settings_outlined,
              color: darkBlue,
              size: 22,
            ),
            title: const Text(
              'Admins',
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isAdminsMenuExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.chevron_right,
              size: 20,
              color: Colors.black38,
            ),
          ),
        ),
        if (isAdminsMenuExpanded)
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 4,
              bottom: 4,
            ),
            child: ListTile(
              dense: true,
              onTap: () {
                _closeDrawerAndOpen(
                  const CreateAdminLoginScreen(),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const Icon(
                Icons.person_add_alt_1_outlined,
                color: darkBlue,
                size: 20,
              ),
              title: const Text(
                'Create Admin Login',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        22,
        18,
        20,
      ),
      color: darkBlue,
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                'assets/icon/logo.jpg',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SkillDisha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Admin Panel',
                  style: TextStyle(
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

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color color = darkBlue,
  }) {
    final bool isLogout = color == Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(
          icon,
          color: color,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? Colors.red
                : const Color(0xFF374151),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isLogout
            ? null
            : const Icon(
          Icons.chevron_right,
          size: 19,
          color: Colors.black38,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: darkBlue,
      unselectedItemColor: Colors.black45,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 10,
      onTap: _handleBottomNavigation,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Students',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign_outlined),
          activeIcon: Icon(Icons.campaign),
          label: 'Notices',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _handleBottomNavigation(int index) {
    if (index == 0) {
      return;
    }

    if (index == 1) {
      _openScreen(
        const AdminStudentsScreen(),
      );
      return;
    }

    if (index == 2) {
      _openScreen(
        const AdminNoticesScreen(),
      );
      return;
    }

    if (index == 3) {
      _openScreen(
        const AdminProfileScreen(),
      );
    }
  }

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void _closeDrawerAndOpen(Widget screen) {
    Navigator.pop(context);

    Future.delayed(
      const Duration(milliseconds: 150),
          () {
        if (!mounted) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}