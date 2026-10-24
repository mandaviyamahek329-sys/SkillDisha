import 'package:flutter/material.dart';

import 'app_data.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String studentId;

  const ResetPasswordScreen({
    super.key,
    required this.studentId,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  static const Color darkBlue =
  Color(0xFF075273);

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  final TextEditingController
  newPasswordController =
  TextEditingController();

  final TextEditingController
  confirmPasswordController =
  TextEditingController();

  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!(formKey.currentState?.validate() ??
        false)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) {
      return;
    }

    final bool updated =
    AppData.instance.resetStudentPassword(
      studentId: widget.studentId,
      newPassword:
      newPasswordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!updated) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Student account was not found.',
      );

      return;
    }

    setState(() {
      isLoading = false;
    });

    await showSuccessDialog();
  }

  Future<void> showSuccessDialog() async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(
            24,
            28,
            24,
            12,
          ),
          content: const Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor:
                Color(0xFFE8F5E9),
                child: Icon(
                  Icons.check,
                  size: 38,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Password Updated',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your password has been changed successfully. You can now login with your new password.',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color:
                  Colors.black54,
                ),
              ),
            ],
          ),
          actionsPadding:
          const EdgeInsets.fromLTRB(
            20,
            4,
            20,
            20,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator
                      .pushAndRemoveUntil(
                    dialogContext,
                    MaterialPageRoute(
                      builder: (_) =>
                      const LoginScreen(),
                    ),
                        (route) => false,
                  );
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  darkBlue,
                  foregroundColor:
                  Colors.white,
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
          behavior:
          SnackBarBehavior.floating,
          duration:
          const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor:
        Colors.white,
        surfaceTintColor:
        Colors.white,
        elevation: 0,
        foregroundColor:
        darkBlue,
      ),
      body: SafeArea(
        child:
        SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          padding:
          const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            30,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildHeaderIcon(),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Create a new password',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Your new password must be at least 6 characters long.',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color:
                    Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                buildPasswordField(
                  controller:
                  newPasswordController,
                  label:
                  'New Password',
                  hidden:
                  hideNewPassword,
                  onVisibilityPressed:
                      () {
                    setState(() {
                      hideNewPassword =
                      !hideNewPassword;
                    });
                  },
                  validator: (value) {
                    final String
                    password =
                        value?.trim() ??
                            '';

                    if (password
                        .isEmpty) {
                      return 'Please enter a new password';
                    }

                    if (password
                        .length <
                        6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                buildPasswordField(
                  controller:
                  confirmPasswordController,
                  label:
                  'Confirm New Password',
                  hidden:
                  hideConfirmPassword,
                  onVisibilityPressed:
                      () {
                    setState(() {
                      hideConfirmPassword =
                      !hideConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please confirm your new password';
                    }

                    if (value !=
                        newPasswordController
                            .text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 22,
                ),
                buildResetButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderIcon() {
    return Container(
      width: 90,
      height: 90,
      decoration:
      const BoxDecoration(
        color: Color(0xFFEAF4F7),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.password_outlined,
        size: 45,
        color: darkBlue,
      ),
    );
  }

  Widget buildResetButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
        isLoading
            ? null
            : resetPassword,
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          darkBlue,
          foregroundColor:
          Colors.white,
          disabledBackgroundColor:
          darkBlue.withValues(
            alpha: 0.6,
          ),
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
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
            : const Text(
          'Reset Password',
          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController
    controller,
    required String label,
    required bool hidden,
    required VoidCallback
    onVisibilityPressed,
    required String? Function(
        String?,
        ) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: hidden,
      validator: validator,
      textInputAction:
      label ==
          'Confirm New Password'
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted:
      label ==
          'Confirm New Password'
          ? (_) {
        resetPassword();
      }
          : null,
      style: const TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 14,
      ),
      decoration:
      InputDecoration(
        labelText: label,
        prefixIcon:
        const Icon(
          Icons.lock_outline,
          color: darkBlue,
        ),
        suffixIcon:
        IconButton(
          onPressed:
          onVisibilityPressed,
          icon: Icon(
            hidden
                ? Icons
                .visibility_off_outlined
                : Icons
                .visibility_outlined,
            color:
            const Color(
              0xFF6B7280,
            ),
          ),
        ),
        filled: true,
        fillColor:
        const Color(
          0xFFF7F8FA,
        ),
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            12,
          ),
        ),
        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            12,
          ),
          borderSide:
          const BorderSide(
            color:
            Color(
              0xFFE5E7EB,
            ),
          ),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            12,
          ),
          borderSide:
          const BorderSide(
            color: darkBlue,
            width: 1.5,
          ),
        ),
        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            12,
          ),
          borderSide:
          const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            12,
          ),
          borderSide:
          const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}