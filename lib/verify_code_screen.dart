import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String email;
  final String phone;
  final String verificationCode;

  const VerifyCodeScreen({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.email,
    required this.phone,
    required this.verificationCode,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  static const Color darkBlue = Color(0xFF075273);

  final TextEditingController codeController = TextEditingController();

  late String currentVerificationCode;

  bool isVerifying = false;

  @override
  void initState() {
    super.initState();

    currentVerificationCode = widget.verificationCode;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  String maskEmail(String email) {
    if (!email.contains('@')) {
      return email;
    }

    final List<String> parts = email.split('@');
    final String name = parts.first;
    final String domain = parts.last;

    if (name.length <= 2) {
      return '${name.substring(0, 1)}***@$domain';
    }

    return '${name.substring(0, 1)}${'*' * (name.length - 2)}${name.substring(name.length - 1)}@$domain';
  }

  String maskPhone(String phone) {
    final String digits = phone.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (digits.length < 4) {
      return phone;
    }

    return '******${digits.substring(digits.length - 4)}';
  }

  String generateVerificationCode() {
    final Random random = Random();
    final int code = 100000 + random.nextInt(900000);

    return code.toString();
  }

  Future<void> verifyCode() async {
    final String enteredCode = codeController.text.trim();

    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter the 6-digit verification code',
            ),
          ),
        );

      return;
    }

    setState(() {
      isVerifying = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isVerifying = false;
    });

    if (enteredCode != currentVerificationCode) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'The verification code is incorrect',
            ),
          ),
        );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(
          studentId: widget.studentId,
        ),
      ),
    );
  }

  void resendCode() {
    final String newCode = generateVerificationCode();

    setState(() {
      currentVerificationCode = newCode;
      codeController.clear();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(
            'New testing verification code: $newCode',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4F7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 45,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter security code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter the 6-digit code sent to your registered contact information.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              buildAccountCard(),
              const SizedBox(height: 24),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                  color: darkBlue,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '000000',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    letterSpacing: 10,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF7F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isVerifying ? null : verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    darkBlue.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isVerifying
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Verify Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Did not receive a code?',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              TextButton(
                onPressed: resendCode,
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFFEAF4F7),
            child: Icon(
              Icons.person,
              size: 31,
              color: darkBlue,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  maskEmail(widget.email),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  maskPhone(widget.phone),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}