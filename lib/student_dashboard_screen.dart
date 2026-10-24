import 'dart:async';

import 'package:flutter/material.dart';

import 'app_data.dart';
import 'attendance_screen.dart';
import 'assignments_screen.dart';
import 'certificates_screen.dart';
import 'courses_screen.dart';
import 'exams_screen.dart';
import 'fees_screen.dart';
import 'login_screen.dart';
import 'my_batch_screen.dart';
import 'notices_screen.dart';
import 'notifications_screen.dart';
import 'placements_screen.dart';
import 'profile_screen.dart';
import 'results_screen.dart';
import 'study_material_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends State<StudentDashboardScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final AppData appData = AppData.instance;

  final PageController carouselController =
  PageController();

  int currentCarouselIndex = 0;
  int currentBottomIndex = 0;

  Timer? carouselTimer;

  final List<Map<String, dynamic>>
  educationCarouselItems = [
    {
      'title': 'Learn. Build. Grow.',
      'subtitle':
      'Develop practical skills and prepare yourself for a successful career.',
      'icon': Icons.school_outlined,
    },
    {
      'title': 'Keep Learning',
      'subtitle':
      'Learn something new every day and improve your technical skills.',
      'icon': Icons.auto_stories_outlined,
    },
    {
      'title': 'Build Your Skills',
      'subtitle':
      'Practice with projects, assignments and real-world learning.',
      'icon': Icons.code_outlined,
    },
    {
      'title': 'Achieve Your Goals',
      'subtitle':
      'Stay focused, complete your course and move towards your career goals.',
      'icon': Icons.workspace_premium_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    startCarousel();
  }

  @override
  void dispose() {
    carouselTimer?.cancel();
    carouselController.dispose();
    super.dispose();
  }

  void startCarousel() {
    carouselTimer?.cancel();

    carouselTimer = Timer.periodic(
      const Duration(seconds: 4),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (!carouselController.hasClients) {
          return;
        }

        final int nextIndex =
            (currentCarouselIndex + 1) %
                educationCarouselItems.length;

        WidgetsBinding.instance.addPostFrameCallback(
              (_) {
            if (!mounted ||
                !carouselController.hasClients) {
              return;
            }

            carouselController.animateToPage(
              nextIndex,
              duration:
              const Duration(milliseconds: 450),
              curve: Curves.easeInOut,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: buildSelectedPage(),
      bottomNavigationBar:
      buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: darkBlue,
      elevation: 0,
      titleSpacing: 0,
      title: const Text(
        'SkillDisha',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const NotificationsScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none_outlined,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget buildSelectedPage() {
    switch (currentBottomIndex) {
      case 1:
        return const MyBatchScreen();

      case 2:
        return const NoticesScreen();

      case 3:
        return const ProfileScreen();

      case 0:
      default:
        return buildHomePage();
    }
  }

  Widget buildHomePage() {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics:
        const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            buildEducationCarousel(),

            const SizedBox(height: 22),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),

            const SizedBox(height: 12),

            buildQuickAccessGrid(),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildEducationCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: carouselController,
            itemCount:
            educationCarouselItems.length,
            onPageChanged: (index) {
              if (!mounted) {
                return;
              }

              if (currentCarouselIndex == index) {
                return;
              }

              setState(() {
                currentCarouselIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final Map<String, dynamic> item =
              educationCarouselItems[index];

              return Container(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                padding:
                const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient:
                  const LinearGradient(
                    begin: Alignment.topLeft,
                    end:
                    Alignment.bottomRight,
                    colors: [
                      Color(0xFF075273),
                      Color(0xFF0B6A83),
                      Color(0xFF55B2B8),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 12,
                      offset:
                      const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            item['title'],
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 18,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            item['subtitle'],
                            maxLines: 3,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: TextStyle(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.90,
                              ),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 66,
                      height: 66,
                      decoration:
                      BoxDecoration(
                        color: Colors.white
                            .withValues(
                          alpha: 0.16,
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment:
                      Alignment.center,
                      child: Icon(
                        item['icon'],
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: List.generate(
            educationCarouselItems.length,
                (index) {
              final bool selected =
                  currentCarouselIndex == index;

              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                width: selected ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: selected
                      ? darkBlue
                      : const Color(
                    0xFFCED9DE,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildQuickAccessGrid() {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'Courses',
        icon: Icons.menu_book_outlined,
        onTap: () {
          openScreen(
            const CoursesScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Attendance',
        icon:
        Icons.fact_check_outlined,
        onTap: () {
          openScreen(
            const AttendanceScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Fees',
        icon:
        Icons.account_balance_wallet_outlined,
        onTap: () {
          openScreen(
            const FeesScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Study Material',
        icon: Icons.library_books_outlined,
        onTap: () {
          openScreen(
            const StudyMaterialScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Assignments',
        icon: Icons.assignment_outlined,
        onTap: () {
          openScreen(
            const AssignmentsScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Exams / Tests',
        icon: Icons.quiz_outlined,
        onTap: () {
          openScreen(
            const ExamsScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Results',
        icon: Icons.bar_chart_outlined,
        onTap: () {
          openScreen(
            const ResultsScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Notices',
        icon:
        Icons.campaign_outlined,
        onTap: () {
          openScreen(
            const NoticesScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Certificates',
        icon:
        Icons.workspace_premium_outlined,
        onTap: () {
          openScreen(
            const CertificatesScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Placements',
        icon: Icons.work_outline,
        onTap: () {
          openScreen(
            const PlacementsScreen(),
          );
        },
      ),
      DashboardItem(
        title: 'Profile',
        icon: Icons.person_outline,
        onTap: () {
          openScreen(
            const ProfileScreen(),
          );
        },
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 105,
      ),
      itemBuilder: (context, index) {
        return buildDashboardCard(
          items[index],
        );
      },
    );
  }

  Widget buildDashboardCard(
      DashboardItem item,
      ) {
    return Material(
      color: Colors.white,
      borderRadius:
      BorderRadius.circular(14),
      child: InkWell(
        onTap: item.onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(14),
            border: Border.all(
              color:
              const Color(0xFFE6ECEF),
            ),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(
                  alpha: 0.025,
                ),
                blurRadius: 8,
                offset:
                const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEAF5F6,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: darkBlue,
                  size: 23,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return NavigationBar(
      height: 64,
      backgroundColor: Colors.white,
      indicatorColor:
      const Color(0xFFDDEFF1),
      selectedIndex: currentBottomIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentBottomIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: darkBlue,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.groups_outlined,
          ),
          selectedIcon: Icon(
            Icons.groups,
            color: darkBlue,
          ),
          label: 'My Batch',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.campaign_outlined,
          ),
          selectedIcon: Icon(
            Icons.campaign,
            color: darkBlue,
          ),
          label: 'Notices',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
          ),
          selectedIcon: Icon(
            Icons.person,
            color: darkBlue,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget buildDrawer() {
    final StudentData? student =
        appData.currentStudentOrNull;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.fromLTRB(
                18,
                18,
                18,
                20,
              ),
              decoration:
              const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:
                  Alignment.bottomRight,
                  colors: [
                    darkBlue,
                    teal,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration:
                    const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: darkBlue,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    student?.fullName ??
                        'Student',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student?.email ?? '',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white
                          .withValues(
                        alpha: 0.86,
                      ),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                children: [
                  buildDrawerTile(
                    title: 'Dashboard',
                    icon:
                    Icons.dashboard_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        currentBottomIndex = 0;
                      });
                    },
                  ),
                  buildDrawerTile(
                    title: 'Courses',
                    icon:
                    Icons.menu_book_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const CoursesScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'My Batch',
                    icon:
                    Icons.groups_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        currentBottomIndex = 1;
                      });
                    },
                  ),
                  buildDrawerTile(
                    title: 'Attendance',
                    icon:
                    Icons.fact_check_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const AttendanceScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Fees',
                    icon: Icons
                        .account_balance_wallet_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const FeesScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Study Material',
                    icon:
                    Icons.library_books_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const StudyMaterialScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Assignments',
                    icon:
                    Icons.assignment_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const AssignmentsScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Exams / Tests',
                    icon:
                    Icons.quiz_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const ExamsScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Results',
                    icon:
                    Icons.bar_chart_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const ResultsScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Notices',
                    icon:
                    Icons.campaign_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const NoticesScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Certificates',
                    icon: Icons
                        .workspace_premium_outlined,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const CertificatesScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Placements',
                    icon:
                    Icons.work_outline,
                    onTap: () {
                      Navigator.pop(context);

                      openScreen(
                        const PlacementsScreen(),
                      );
                    },
                  ),
                  buildDrawerTile(
                    title: 'Profile',
                    icon:
                    Icons.person_outline,
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        currentBottomIndex = 3;
                      });
                    },
                  ),

                  buildDrawerTile(
                    title: 'About SkillDisha',
                    icon: Icons.info_outline,
                    onTap: () {
                      Navigator.pop(context);

                      showAboutSkillDishaDialog();
                    },
                  ),

                  const Divider(
                    height: 20,
                  ),

                  buildDrawerTile(
                    title: 'Logout',
                    icon:
                    Icons.logout_outlined,
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);

                      showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color color = darkBlue,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: color,
        size: 21,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void openScreen(
      Widget screen,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  Future<void> showAboutSkillDishaDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          titlePadding:
          const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            8,
          ),
          actionsPadding:
          const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            12,
          ),
          title: const Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                Color(0xFFEAF5F6),
                child: Icon(
                  Icons.school_outlined,
                  color: darkBlue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'About SkillDisha',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'SkillDisha TechLab',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'SkillDisha TechLab is an education and training platform designed to help students learn practical skills and manage their academic journey.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: Color(0xFF4B5563),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Students can access courses, batches, attendance, fees, study materials, assignments, exams, results, notices, certificates, and placement information from one place.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: Color(0xFF4B5563),
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 18,
                    color: teal,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Learn. Build. Grow.',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                      FontWeight.w600,
                      color: darkBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: darkBlue,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showLogoutDialog() async {
    final bool? shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor:
                Colors.white,
              ),
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true ||
        !mounted) {
      return;
    }

    appData.logoutStudent();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),
          (route) => false,
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
