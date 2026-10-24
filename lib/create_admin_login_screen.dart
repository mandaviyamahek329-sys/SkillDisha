import 'package:flutter/material.dart';

import 'app_data.dart';

class CreateAdminLoginScreen extends StatefulWidget {
  const CreateAdminLoginScreen({super.key});

  @override
  State<CreateAdminLoginScreen> createState() =>
      _CreateAdminLoginScreenState();
}

class _CreateAdminLoginScreenState
    extends State<CreateAdminLoginScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor = Color(0xFFF5F7F9);

  final AppData appData = AppData.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController =
  TextEditingController();
  final TextEditingController usernameController =
  TextEditingController();
  final TextEditingController passwordController =
  TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  final Set<String> selectedCourseIds = <String>{};
  final Set<String> selectedBatchIds = <String>{};

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isCreating = false;

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  List<CourseData> get activeCourses {
    final List<CourseData> result = appData.courses
        .where((course) => course.isActive)
        .toList();

    result.sort(
          (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
    );

    return result;
  }

  List<BatchData> get availableBatches {
    final List<BatchData> result = appData.batches
        .where(
          (batch) =>
      batch.isActive &&
          selectedCourseIds.contains(batch.courseId),
    )
        .toList();

    result.sort(
          (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
    );

    return result;
  }

  void toggleCourse(
      CourseData course,
      bool selected,
      ) {
    setState(() {
      if (selected) {
        selectedCourseIds.add(course.id);
      } else {
        selectedCourseIds.remove(course.id);

        final List<String> batchIdsToRemove = appData.batches
            .where(
              (batch) => batch.courseId == course.id,
        )
            .map((batch) => batch.id)
            .toList();

        selectedBatchIds.removeAll(batchIdsToRemove);
      }
    });
  }

  void toggleBatch(
      BatchData batch,
      bool selected,
      ) {
    setState(() {
      if (selected) {
        selectedBatchIds.add(batch.id);
      } else {
        selectedBatchIds.remove(batch.id);
      }
    });
  }

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedCourseIds.isEmpty) {
      showMessage('Please select at least one course.');
      return;
    }

    if (selectedBatchIds.isEmpty) {
      showMessage('Please select at least one batch.');
      return;
    }

    for (final String batchId in selectedBatchIds) {
      final BatchData? batch = appData.findBatchById(batchId);

      if (batch == null ||
          !selectedCourseIds.contains(batch.courseId)) {
        showMessage(
          'Selected batches must belong to the selected courses.',
        );
        return;
      }
    }

    setState(() {
      isCreating = true;
    });

    final FacultyData? faculty = appData.createAdminLogin(
      fullName: fullNameController.text,
      username: usernameController.text,
      password: passwordController.text,
      assignedCourseIds: selectedCourseIds.toList(),
      assignedBatchIds: selectedBatchIds.toList(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isCreating = false;
    });

    if (faculty == null) {
      showMessage(
        'Unable to create admin login. Please check the details.',
      );
      return;
    }

    await showSuccessDialog(faculty);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> showSuccessDialog(
      FacultyData faculty,
      ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFE5F7F5),
                child: Icon(
                  Icons.check_rounded,
                  color: darkBlue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Account Created',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Admin login has been created successfully.',
                style: TextStyle(
                  color: Color(0xFF5F6B76),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              _buildSuccessRow(
                label: 'Faculty ID',
                value: faculty.id,
              ),
              _buildSuccessRow(
                label: 'Full Name',
                value: faculty.fullName,
              ),
              _buildSuccessRow(
                label: 'Username',
                value: faculty.username,
              ),
              _buildSuccessRow(
                label: 'Courses',
                value: faculty.assignedCourseIds.length.toString(),
              ),
              _buildSuccessRow(
                label: 'Batches',
                value: faculty.assignedBatchIds.length.toString(),
              ),
            ],
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: darkBlue,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Widget _buildSuccessRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7A8792),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF263238),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkBlue,
            size: 20,
          ),
        ),
        title: const Text(
          'Create Admin Login',
          style: TextStyle(
            color: darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 18),
                _buildAccountDetailsCard(),
                const SizedBox(height: 18),
                _buildCourseCard(),
                const SizedBox(height: 18),
                _buildBatchCard(),
                const SizedBox(height: 24),
                _buildCreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            darkBlue,
            teal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.admin_panel_settings_outlined,
              color: darkBlue,
              size: 30,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Admin Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create login and assign courses and batches.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsCard() {
    return _buildSectionCard(
      title: 'Account Details',
      icon: Icons.person_add_alt_1_outlined,
      child: Column(
        children: [
          _buildTextField(
            controller: fullNameController,
            label: 'Full Name',
            hint: 'Enter full name',
            icon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required.';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: usernameController,
            label: 'Username',
            hint: 'Enter username',
            icon: Icons.account_circle_outlined,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              final String username = value?.trim() ?? '';

              if (username.isEmpty) {
                return 'Username is required.';
              }

              if (username.length < 3) {
                return 'Username must be at least 3 characters.';
              }

              if (!RegExp(r'^[a-zA-Z0-9._]+$')
                  .hasMatch(username)) {
                return 'Use only letters, numbers, dot or underscore.';
              }

              if (appData.facultyUsernameExists(username)) {
                return 'This username is already in use.';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: passwordController,
            label: 'Password',
            hint: 'Enter password',
            icon: Icons.lock_outline,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black45,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required.';
              }

              if (value.length < 6) {
                return 'Password must be at least 6 characters.';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Enter password again',
            icon: Icons.lock_reset_outlined,
            obscureText: obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword =
                  !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black45,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm the password.';
              }

              if (value != passwordController.text) {
                return 'Passwords do not match.';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard() {
    final List<CourseData> courses = activeCourses;

    return _buildSectionCard(
      title: 'Assign Courses',
      icon: Icons.menu_book_outlined,
      subtitle: selectedCourseIds.isEmpty
          ? 'Select at least one course.'
          : '${selectedCourseIds.length} course(s) selected',
      child: courses.isEmpty
          ? _buildEmptyState(
        icon: Icons.menu_book_outlined,
        message: 'No active courses are available.',
      )
          : Column(
        children: courses.map((course) {
          final bool selected =
          selectedCourseIds.contains(course.id);

          return _buildSelectionTile(
            title: course.name,
            subtitle:
            '${course.id}  •  ${course.duration}',
            selected: selected,
            onChanged: (value) {
              toggleCourse(
                course,
                value ?? false,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBatchCard() {
    if (selectedCourseIds.isEmpty) {
      return _buildSectionCard(
        title: 'Assign Batches',
        icon: Icons.groups_outlined,
        subtitle: 'Select courses first.',
        child: _buildEmptyState(
          icon: Icons.touch_app_outlined,
          message:
          'Select a course to see its available batches.',
        ),
      );
    }

    final List<BatchData> batches = availableBatches;

    return _buildSectionCard(
      title: 'Assign Batches',
      icon: Icons.groups_outlined,
      subtitle: selectedBatchIds.isEmpty
          ? 'Select at least one batch.'
          : '${selectedBatchIds.length} batch(es) selected',
      child: batches.isEmpty
          ? _buildEmptyState(
        icon: Icons.groups_outlined,
        message:
        'No active batches are available for the selected courses.',
      )
          : Column(
        children: batches.map((batch) {
          final CourseData? course =
          appData.findCourseById(batch.courseId);

          final bool selected =
          selectedBatchIds.contains(batch.id);

          return _buildSelectionTile(
            title: batch.name,
            subtitle: [
              if (course != null) course.name,
              batch.timing,
            ].where((item) => item.trim().isNotEmpty).join(
              '  •  ',
            ),
            selected: selected,
            onChanged: (value) {
              toggleBatch(
                batch,
                value ?? false,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8EDF1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: darkBlue,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF263238),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF7A8792),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: darkBlue,
          size: 21,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF9FBFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFDDE5EA),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFDDE5EA),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: teal,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required String subtitle,
    required bool selected,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFF0F9F9)
            : const Color(0xFFF9FBFC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: selected
              ? teal
              : const Color(0xFFE3E9ED),
        ),
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: onChanged,
        activeColor: darkBlue,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF263238),
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF7A8792),
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.black26,
          ),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7A8792),
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: isCreating ? null : createAccount,
        style: FilledButton.styleFrom(
          backgroundColor: darkBlue,
          disabledBackgroundColor: darkBlue.withValues(
            alpha: 0.55,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: isCreating
            ? const SizedBox(
          width: 19,
          height: 19,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(
          Icons.person_add_alt_1_rounded,
          color: Colors.white,
        ),
        label: Text(
          isCreating
              ? 'Creating Account...'
              : 'Create Account',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}