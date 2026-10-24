import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminFeesScreen extends StatefulWidget {
  const AdminFeesScreen({super.key});

  @override
  State<AdminFeesScreen> createState() => _AdminFeesScreenState();
}

class _AdminFeesScreenState extends State<AdminFeesScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor = Color(0xFFF6F8FA);

  final AppData appData = AppData.instance;

  final TextEditingController searchController =
  TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    appData.addListener(refreshScreen);

    searchController.addListener(() {
      if (!mounted) {
        return;
      }

      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    appData.removeListener(refreshScreen);
    searchController.dispose();
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
    final List<StudentData> students = getFilteredStudents();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Fees Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                0,
              ),
              child: Column(
                children: [
                  buildHeader(),
                  const SizedBox(height: 14),
                  buildSearchField(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: students.isEmpty
                  ? buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  30,
                ),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return buildStudentFeeCard(
                    students[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
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
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x22FFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Icon(
                Icons.currency_rupee,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Fees',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Manage course fees and payment details for students.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFFE5F4F5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search student, ID, course or batch',
        prefixIcon: const Icon(
          Icons.search,
        ),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
          onPressed: () {
            searchController.clear();
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
            color: teal,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget buildStudentFeeCard(
      StudentData student,
      ) {
    final String courseName =
    appData.getCourseName(student.courseId);

    final String batchName =
    appData.getBatchName(student.batchId);

    final double totalFees = parseAmount(
      student.totalCourseFees,
    );

    final double discount = parseAmount(
      student.discountOffer,
    );

    final double finalFees = student.finalPayableFees.trim().isEmpty
        ? calculateFinalFees(
      totalFees,
      discount,
    )
        : parseAmount(
      student.finalPayableFees,
    );

    final double registrationAmount = parseAmount(
      student.registrationAmount,
    );

    final double remainingAmount =
    (finalFees - registrationAmount) < 0
        ? 0
        : finalFees - registrationAmount;

    final bool hasFeeDetails =
        student.totalCourseFees.trim().isNotEmpty ||
            student.finalPayableFees.trim().isNotEmpty ||
            student.registrationAmount.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F5),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  getInitials(
                    student.fullName,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      student.rollNumber.trim().isEmpty
                          ? student.id
                          : '${student.id} • ${student.rollNumber}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit Fees',
                onPressed: () {
                  openFeeDialog(
                    student,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          buildDetailRow(
            title: 'Course',
            value: courseName,
          ),
          const SizedBox(height: 7),
          buildDetailRow(
            title: 'Batch',
            value: batchName,
          ),
          const Divider(
            height: 24,
            color: Color(0xFFEEF0F2),
          ),
          if (!hasFeeDetails)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Fee details are not added yet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: buildAmountBox(
                    title: 'Total Fees',
                    amount: totalFees,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildAmountBox(
                    title: 'Payable',
                    amount: finalFees,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: buildAmountBox(
                    title: 'Paid',
                    amount: registrationAmount,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildAmountBox(
                    title: 'Remaining',
                    amount: remainingAmount,
                  ),
                ),
              ],
            ),
            if (student.paymentMode.trim().isNotEmpty ||
                student.installmentPlan.trim().isNotEmpty) ...[
              const Divider(
                height: 24,
                color: Color(0xFFEEF0F2),
              ),
              if (student.paymentMode.trim().isNotEmpty)
                buildDetailRow(
                  title: 'Payment Mode',
                  value: student.paymentMode,
                ),
              if (student.paymentMode.trim().isNotEmpty &&
                  student.installmentPlan.trim().isNotEmpty)
                const SizedBox(height: 7),
              if (student.installmentPlan.trim().isNotEmpty)
                buildDetailRow(
                  title: 'Installment Plan',
                  value: student.installmentPlan,
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget buildAmountBox({
    required String title,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatCurrency(amount),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow({
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.trim().isEmpty
                ? 'Not Available'
                : value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
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
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 32,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.currency_rupee,
                size: 56,
                color: darkBlue,
              ),
              SizedBox(height: 14),
              Text(
                'No Students Found',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Student fee details will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<StudentData> getFilteredStudents() {
    final List<StudentData> result = appData.students.where(
          (StudentData student) {
        if (!student.isActive) {
          return false;
        }

        if (searchQuery.isEmpty) {
          return true;
        }

        final String courseName =
        appData.getCourseName(student.courseId);

        final String batchName =
        appData.getBatchName(student.batchId);

        return student.fullName.toLowerCase().contains(searchQuery) ||
            student.id.toLowerCase().contains(searchQuery) ||
            student.rollNumber.toLowerCase().contains(searchQuery) ||
            courseName.toLowerCase().contains(searchQuery) ||
            batchName.toLowerCase().contains(searchQuery);
      },
    ).toList();

    result.sort(
          (StudentData a, StudentData b) =>
          a.fullName.toLowerCase().compareTo(
            b.fullName.toLowerCase(),
          ),
    );

    return result;
  }

  Future<void> openFeeDialog(
      StudentData student,
      ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return FeeFormDialog(
          student: student,
          onSave: ({
            required String totalCourseFees,
            required String discountOffer,
            required String finalPayableFees,
            required String paymentMode,
            required String registrationAmount,
            required String installmentPlan,
            required String feeRemarks,
          }) {
            appData.updateStudentAdmission(
              studentId: student.id,
              totalCourseFees: totalCourseFees,
              discountOffer: discountOffer,
              finalPayableFees: finalPayableFees,
              paymentMode: paymentMode,
              registrationAmount: registrationAmount,
              installmentPlan: installmentPlan,
              feeRemarks: feeRemarks,
            );

            showMessage(
              'Fee details updated successfully.',
            );
          },
        );
      },
    );
  }

  double parseAmount(
      String value,
      ) {
    return double.tryParse(
      value.replaceAll(',', '').trim(),
    ) ??
        0;
  }

  double calculateFinalFees(
      double totalFees,
      double discount,
      ) {
    final double result = totalFees - discount;

    if (result < 0) {
      return 0;
    }

    return result;
  }

  String formatCurrency(
      double amount,
      ) {
    final bool isWholeNumber =
        amount == amount.roundToDouble();

    final String value = isWholeNumber
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);

    return '₹$value';
  }

  String getInitials(
      String name,
      ) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where(
          (String part) => part.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return 'S';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
        '${parts.last.substring(0, 1)}'
        .toUpperCase();
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
          content: Text(
            message,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class FeeFormDialog extends StatefulWidget {
  final StudentData student;

  final void Function({
  required String totalCourseFees,
  required String discountOffer,
  required String finalPayableFees,
  required String paymentMode,
  required String registrationAmount,
  required String installmentPlan,
  required String feeRemarks,
  }) onSave;

  const FeeFormDialog({
    super.key,
    required this.student,
    required this.onSave,
  });

  @override
  State<FeeFormDialog> createState() =>
      _FeeFormDialogState();
}

class _FeeFormDialogState extends State<FeeFormDialog> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  late final TextEditingController totalFeesController;
  late final TextEditingController discountController;
  late final TextEditingController finalFeesController;
  late final TextEditingController registrationController;
  late final TextEditingController installmentController;
  late final TextEditingController remarksController;

  String? paymentMode;

  final List<String> paymentModes = const [
    'Cash',
    'UPI',
    'Card',
    'Bank Transfer',
    'Cheque',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    totalFeesController = TextEditingController(
      text: widget.student.totalCourseFees,
    );

    discountController = TextEditingController(
      text: widget.student.discountOffer,
    );

    finalFeesController = TextEditingController(
      text: widget.student.finalPayableFees,
    );

    registrationController = TextEditingController(
      text: widget.student.registrationAmount,
    );

    installmentController = TextEditingController(
      text: widget.student.installmentPlan,
    );

    remarksController = TextEditingController(
      text: widget.student.feeRemarks,
    );

    paymentMode = widget.student.paymentMode.trim().isEmpty
        ? null
        : widget.student.paymentMode;

    totalFeesController.addListener(
      calculateFinalFees,
    );

    discountController.addListener(
      calculateFinalFees,
    );
  }

  @override
  void dispose() {
    totalFeesController.removeListener(
      calculateFinalFees,
    );

    discountController.removeListener(
      calculateFinalFees,
    );

    totalFeesController.dispose();
    discountController.dispose();
    finalFeesController.dispose();
    registrationController.dispose();
    installmentController.dispose();
    remarksController.dispose();

    super.dispose();
  }

  void calculateFinalFees() {
    final double total = double.tryParse(
      totalFeesController.text
          .replaceAll(',', '')
          .trim(),
    ) ??
        0;

    final double discount = double.tryParse(
      discountController.text
          .replaceAll(',', '')
          .trim(),
    ) ??
        0;

    double finalFees = total - discount;

    if (finalFees < 0) {
      finalFees = 0;
    }

    final String calculatedValue =
    finalFees == finalFees.roundToDouble()
        ? finalFees.toStringAsFixed(0)
        : finalFees.toStringAsFixed(2);

    if (finalFeesController.text != calculatedValue) {
      finalFeesController.text = calculatedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        10,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        14,
      ),
      title: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          12,
          18,
        ),
        decoration: const BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.currency_rupee,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Fees',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.student.fullName,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAmountField(
                controller: totalFeesController,
                label: 'Total Course Fees',
                icon: Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(height: 13),
              buildAmountField(
                controller: discountController,
                label: 'Discount Amount',
                icon: Icons.discount_outlined,
              ),
              const SizedBox(height: 13),
              TextField(
                controller: finalFeesController,
                readOnly: true,
                decoration: buildInputDecoration(
                  label: 'Final Payable Fees',
                  icon: Icons.payments_outlined,
                ),
              ),
              const SizedBox(height: 13),
              buildAmountField(
                controller: registrationController,
                label: 'Paid Amount',
                icon: Icons.currency_rupee,
              ),
              const SizedBox(height: 13),
              DropdownButtonFormField<String>(
                initialValue: paymentModes.contains(paymentMode)
                    ? paymentMode
                    : null,
                isExpanded: true,
                decoration: buildInputDecoration(
                  label: 'Payment Mode',
                  icon: Icons.payment_outlined,
                ),
                hint: const Text(
                  'Select Payment Mode',
                ),
                items: paymentModes.map(
                      (String mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(
                        mode,
                      ),
                    );
                  },
                ).toList(),
                onChanged: (String? value) {
                  setState(() {
                    paymentMode = value;
                  });
                },
              ),
              const SizedBox(height: 13),
              TextField(
                controller: installmentController,
                textCapitalization:
                TextCapitalization.sentences,
                decoration: buildInputDecoration(
                  label: 'Installment Plan',
                  icon: Icons.calendar_month_outlined,
                ).copyWith(
                  hintText: 'Example: 3 Monthly Installments',
                ),
              ),
              const SizedBox(height: 13),
              TextField(
                controller: remarksController,
                maxLines: 3,
                textCapitalization:
                TextCapitalization.sentences,
                decoration: buildInputDecoration(
                  label: 'Fee Remarks',
                  icon: Icons.notes_outlined,
                ).copyWith(
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton.icon(
          onPressed: saveFees,
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          icon: const Icon(
            Icons.save_outlined,
            size: 18,
          ),
          label: const Text(
            'Save',
          ),
        ),
      ],
    );
  }

  Widget buildAmountField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: buildInputDecoration(
        label: label,
        icon: icon,
      ),
    );
  }

  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
    );
  }

  void saveFees() {
    final double totalFees = double.tryParse(
      totalFeesController.text
          .replaceAll(',', '')
          .trim(),
    ) ??
        -1;

    final double discount = double.tryParse(
      discountController.text
          .replaceAll(',', '')
          .trim(),
    ) ??
        0;

    final double paidAmount = double.tryParse(
      registrationController.text
          .replaceAll(',', '')
          .trim(),
    ) ??
        0;

    if (totalFees < 0) {
      showMessage(
        'Please enter valid total course fees.',
      );
      return;
    }

    if (discount < 0) {
      showMessage(
        'Discount amount cannot be negative.',
      );
      return;
    }

    if (discount > totalFees) {
      showMessage(
        'Discount amount cannot be greater than total fees.',
      );
      return;
    }

    final double finalFees = totalFees - discount;

    if (paidAmount < 0) {
      showMessage(
        'Paid amount cannot be negative.',
      );
      return;
    }

    if (paidAmount > finalFees) {
      showMessage(
        'Paid amount cannot be greater than payable fees.',
      );
      return;
    }

    widget.onSave(
      totalCourseFees: cleanAmount(
        totalFees,
      ),
      discountOffer: cleanAmount(
        discount,
      ),
      finalPayableFees: cleanAmount(
        finalFees,
      ),
      paymentMode: paymentMode ?? '',
      registrationAmount: cleanAmount(
        paidAmount,
      ),
      installmentPlan:
      installmentController.text.trim(),
      feeRemarks:
      remarksController.text.trim(),
    );

    Navigator.pop(context);
  }

  String cleanAmount(
      double amount,
      ) {
    if (amount == amount.roundToDouble()) {
      return amount.toStringAsFixed(0);
    }

    return amount.toStringAsFixed(2);
  }

  void showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}