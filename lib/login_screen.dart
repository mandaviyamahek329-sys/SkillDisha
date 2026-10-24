import 'package:flutter/material.dart';

import 'admin_dashboard_screen.dart';
import 'admission_form_screen.dart';
import 'app_data.dart';
import 'forgot_password_screen.dart';
import 'student_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController loginController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isStudent = true;
  bool rememberMe = false;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void changeRole(bool studentRole) {
    if (isStudent == studentRole) {
      return;
    }

    setState(() {
      isStudent = studentRole;
    });
  }

  Future<void> login() async {
    if (isLoading) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) {
      return;
    }

    if (isStudent) {
      loginStudent();
    } else {
      loginFaculty();
    }
  }

  void loginStudent() {
    final StudentData? student =
    AppData.instance.authenticateStudent(
      username: loginController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (student == null) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Invalid student name or password',
      );

      return;
    }

    setState(() {
      isLoading = false;
    });

    if (student.admissionCompleted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const StudentDashboardScreen(),
        ),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => AdmissionFormScreen(
            studentId: student.id,
          ),
        ),
            (route) => false,
      );
    }
  }

  void loginFaculty() {
    final FacultyData? faculty =
    AppData.instance.authenticateFaculty(
      username: loginController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (faculty == null) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Invalid faculty username or password',
      );

      return;
    }

    setState(() {
      isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AdminDashboardScreen()
      ),
          (route) => false,
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
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void openForgotPassword() {
    if (!isStudent) {
      showMessage(
        'Please contact the administrator to reset a faculty password',
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const ForgotPasswordScreen(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              30,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildLogo(),

                  const SizedBox(height: 20),

                  buildHeader(),

                  const SizedBox(height: 18),

                  buildRoleSelector(),

                  const SizedBox(height: 20),

                  buildLoginField(),

                  const SizedBox(height: 14),

                  buildPasswordField(),

                  const SizedBox(height: 4),

                  buildLoginOptions(),

                  const SizedBox(height: 12),

                  buildLoginButton(),

                  const SizedBox(height: 22),

                  buildDivider(),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 76,
                    child: isStudent
                        ? buildSignUpSection()
                        : buildFacultyInfoSection(),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'SkillDisha TechLab',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return SizedBox(
      height: 125,
      child: Center(
        child: Image.asset(
          'assets/icon/logo.jpg',
          width: 125,
          fit: BoxFit.contain,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F7),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 45,
                color: darkBlue,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      height: 62,
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            isStudent
                ? 'Student Login'
                : 'Faculty Login',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isStudent
                ? 'Login to continue your learning journey'
                : 'Login to manage SkillDisha',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoleSelector() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F5),
          borderRadius:
          BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: buildRoleButton(
                title: 'Student',
                icon: Icons.school_outlined,
                selected: isStudent,
                onTap: () {
                  changeRole(true);
                },
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: buildRoleButton(
                title: 'Faculty',
                icon:
                Icons.admin_panel_settings_outlined,
                selected: !isStudent,
                onTap: () {
                  changeRole(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoleButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? darkBlue
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected
                    ? Colors.white
                    : Colors.black54,
              ),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginField() {
    return SizedBox(
      height: 58,
      child: TextFormField(
        controller: loginController,
        textInputAction:
        TextInputAction.next,
        validator: (value) {
          if (value == null ||
              value.trim().isEmpty) {
            return isStudent
                ? 'Please enter your student name'
                : 'Please enter your faculty username';
          }

          return null;
        },
        decoration: buildDecoration(
          label: isStudent
              ? 'Student Name'
              : 'Faculty Username',
          icon: isStudent
              ? Icons.badge_outlined
              : Icons.person_outline,
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return SizedBox(
      height: 58,
      child: TextFormField(
        controller: passwordController,
        obscureText: hidePassword,
        textInputAction:
        TextInputAction.done,
        onFieldSubmitted: (_) {
          login();
        },
        validator: (value) {
          if (value == null ||
              value.isEmpty) {
            return 'Please enter your password';
          }

          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }

          return null;
        },
        decoration: buildDecoration(
          label: 'Password',
          icon: Icons.lock_outline,
        ).copyWith(
          suffixIcon: IconButton(
            tooltip: hidePassword
                ? 'Show Password'
                : 'Hide Password',
            onPressed: () {
              setState(() {
                hidePassword =
                !hidePassword;
              });
            },
            icon: Icon(
              hidePassword
                  ? Icons
                  .visibility_off_outlined
                  : Icons
                  .visibility_outlined,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginOptions() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Transform.scale(
            scale: 0.88,
            child: Checkbox(
              value: rememberMe,
              activeColor: darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(4),
              ),
              onChanged: (value) {
                setState(() {
                  rememberMe =
                      value ?? false;
                });
              },
            ),
          ),
          const Text(
            'Remember me',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed:
            openForgotPassword,
            style: TextButton.styleFrom(
              foregroundColor: darkBlue,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 4,
              ),
            ),
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 51,
      child: ElevatedButton(
        onPressed:
        isLoading ? null : login,
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          darkBlue.withValues(
            alpha: 0.55,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child:
          CircularProgressIndicator(
            strokeWidth: 2.4,
            color: Colors.white,
          ),
        )
            : Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              isStudent
                  ? Icons.login
                  : Icons
                  .admin_panel_settings_outlined,
              size: 19,
            ),
            const SizedBox(width: 8),
            Text(
              isStudent
                  ? 'Login as Student'
                  : 'Login as Faculty',
              style: const TextStyle(
                fontSize: 14,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFE5E7EB),
          ),
        ),
        Padding(
          padding:
          EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black38,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ],
    );
  }

  Widget buildSignUpSection() {
    return Container(
      width: double.infinity,
      height: 76,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          const Flexible(
            child: Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),



        ],
      ),
    );
  }

  Widget buildFacultyInfoSection() {
    return Container(
      width: double.infinity,
      height: 76,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons
                .admin_panel_settings_outlined,
            size: 19,
            color: darkBlue,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Faculty accounts are managed by SkillDisha',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: darkBlue,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
        borderSide:
        const BorderSide(
          color: Color(0xFFE1E5E9),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
        borderSide:
        const BorderSide(
          color: teal,
          width: 1.6,
        ),
      ),
      errorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
        borderSide:
        const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(10),
        borderSide:
        const BorderSide(
          color: Colors.red,
          width: 1.4,
        ),
      ),
    );
  }
}
