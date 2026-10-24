import 'package:flutter/material.dart';

import 'app_data.dart';

class ProfileScreen extends StatefulWidget {
  final bool showAppBar;

  const ProfileScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color darkBlue = Color(0xFF075273);

  final AppData appData = AppData.instance;

  final TextEditingController fullNameController =
  TextEditingController();

  final TextEditingController guardianNameController =
  TextEditingController();

  final TextEditingController dateOfBirthController =
  TextEditingController();

  final TextEditingController nationalityController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController parentPhoneController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController cityController =
  TextEditingController();

  final TextEditingController stateController =
  TextEditingController();

  final TextEditingController pinCodeController =
  TextEditingController();

  String? selectedGender;

  bool isEditing = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    appData.addListener(refreshScreen);

    loadStudentData();
  }

  @override
  void dispose() {
    appData.removeListener(refreshScreen);

    fullNameController.dispose();
    guardianNameController.dispose();
    dateOfBirthController.dispose();
    nationalityController.dispose();
    phoneController.dispose();
    parentPhoneController.dispose();
    addressController.dispose();
    emailController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();

    super.dispose();
  }

  void refreshScreen() {
    if (!mounted || isEditing) {
      return;
    }

    setState(() {
      loadStudentData();
    });
  }

  void loadStudentData() {
    final StudentData? student =
        appData.currentStudentOrNull;

    if (student == null) {
      return;
    }

    fullNameController.text = student.fullName;
    guardianNameController.text = student.guardianName;
    dateOfBirthController.text = student.dateOfBirth;

    selectedGender =
    student.gender.isEmpty ? null : student.gender;

    nationalityController.text = student.nationality;
    phoneController.text = student.phone;
    parentPhoneController.text = student.parentPhone;
    addressController.text = student.address;
    emailController.text = student.email;
    cityController.text = student.city;
    stateController.text = student.state;
    pinCodeController.text = student.pinCode;
  }

  @override
  Widget build(BuildContext context) {
    final StudentData? student =
        appData.currentStudentOrNull;

    if (student == null) {
      return buildStudentNotFound();
    }

    final Widget content = SafeArea(
      top: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildStudentHeader(student),
            const SizedBox(height: 18),
            buildPersonalInformation(),
            if (isEditing) ...[
              const SizedBox(height: 20),
              buildEditButtons(),
            ],
          ],
        ),
      ),
    );

    if (!widget.showAppBar) {
      return Container(
        color: const Color(0xFFF6F8FA),
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: buildAppBar(),
      body: content,
    );
  }

  Widget buildStudentNotFound() {
    if (!widget.showAppBar) {
      return const Center(
        child: Text(
          'Student not found',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Student not found',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
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
        'Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (!isEditing)
          IconButton(
            tooltip: 'Edit Profile',
            onPressed: startEditing,
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget buildStudentHeader(
      StudentData student,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline,
              color: darkBlue,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName.isEmpty
                      ? 'Student'
                      : student.fullName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'ID: ${student.id}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
          ),
          if (!widget.showAppBar && !isEditing)
            IconButton(
              tooltip: 'Edit Profile',
              onPressed: startEditing,
              icon: const Icon(
                Icons.edit_outlined,
                color: darkBlue,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPersonalInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person_outline,
                color: darkBlue,
                size: 22,
              ),
              SizedBox(width: 9),
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildProfileField(
            label: 'Student Name',
            controller: fullNameController,
            icon: Icons.person_outline,
            enabled: isEditing,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Parent / Guardian Name',
            controller: guardianNameController,
            icon: Icons.family_restroom_outlined,
            enabled: isEditing,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Date of Birth',
            controller: dateOfBirthController,
            icon: Icons.calendar_month_outlined,
            enabled: isEditing,
            readOnly: true,
            onTap:
            isEditing ? selectDateOfBirth : null,
          ),
          const SizedBox(height: 14),
          buildGenderField(),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Nationality',
            controller: nationalityController,
            icon: Icons.flag_outlined,
            enabled: isEditing,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Phone Number',
            controller: phoneController,
            icon: Icons.phone_outlined,
            enabled: isEditing,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Parent Phone Number',
            controller: parentPhoneController,
            icon: Icons.phone_android_outlined,
            enabled: isEditing,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Residential Address',
            controller: addressController,
            icon: Icons.home_outlined,
            enabled: isEditing,
            maxLines: 3,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'Email Address',
            controller: emailController,
            icon: Icons.email_outlined,
            enabled: isEditing,
            keyboardType:
            TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'City',
            controller: cityController,
            icon: Icons.location_city_outlined,
            enabled: isEditing,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'State',
            controller: stateController,
            icon: Icons.map_outlined,
            enabled: isEditing,
          ),
          const SizedBox(height: 14),
          buildProfileField(
            label: 'PIN Code',
            controller: pinCodeController,
            icon: Icons.pin_drop_outlined,
            enabled: isEditing,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget buildProfileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    if (!isEditing) {
      final String value =
      controller.text.trim();

      return buildInformationRow(
        label: label,
        value: value.isEmpty
            ? 'Not Provided'
            : value,
        icon: icon,
      );
    }

    return TextField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization:
      keyboardType ==
          TextInputType.emailAddress
          ? TextCapitalization.none
          : TextCapitalization.words,
      style: const TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: darkBlue,
        ),
        suffixIcon: readOnly && enabled
            ? const Icon(
          Icons.calendar_month_outlined,
          color: Color(0xFF6B7280),
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD8E1E5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: darkBlue,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget buildGenderField() {
    if (!isEditing) {
      return buildInformationRow(
        label: 'Gender',
        value: selectedGender == null ||
            selectedGender!.isEmpty
            ? 'Not Provided'
            : selectedGender!,
        icon: Icons.wc_outlined,
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(
          Icons.wc_outlined,
          color: darkBlue,
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD8E1E5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: darkBlue,
            width: 1.4,
          ),
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'Male',
          child: Text('Male'),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text('Female'),
        ),
        DropdownMenuItem(
          value: 'Other',
          child: Text('Other'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedGender = value;
        });
      },
    );
  }

  Widget buildInformationRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: darkBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w500,
                    color: Color(0xFF1F2937),
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

  Widget buildEditButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed:
              isSaving ? null : cancelEditing,
              style: OutlinedButton.styleFrom(
                foregroundColor: darkBlue,
                side: const BorderSide(
                  color: darkBlue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed:
              isSaving ? null : saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isSaving
                    ? 'Saving...'
                    : 'Save Changes',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void startEditing() {
    loadStudentData();

    setState(() {
      isEditing = true;
    });
  }

  void cancelEditing() {
    loadStudentData();

    setState(() {
      isEditing = false;
    });
  }

  Future<void> selectDateOfBirth() async {
    final DateTime now = DateTime.now();

    DateTime initialDate =
    DateTime(now.year - 16);

    final String currentValue =
    dateOfBirthController.text.trim();

    if (currentValue.isNotEmpty) {
      final List<String> parts =
      currentValue.split('/');

      if (parts.length == 3) {
        final int? day =
        int.tryParse(parts[0]);

        final int? month =
        int.tryParse(parts[1]);

        final int? year =
        int.tryParse(parts[2]);

        if (day != null &&
            month != null &&
            year != null) {
          initialDate = DateTime(
            year,
            month,
            day,
          );
        }
      }
    }

    final DateTime? selectedDate =
    await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (selectedDate == null) {
      return;
    }

    dateOfBirthController.text =
    '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year}';
  }

  Future<void> saveProfile() async {
    final StudentData? student =
        appData.currentStudentOrNull;

    if (student == null) {
      showMessage(
        'Student not found',
      );
      return;
    }

    final String fullName =
    fullNameController.text.trim();

    final String guardianName =
    guardianNameController.text.trim();

    final String dateOfBirth =
    dateOfBirthController.text.trim();

    final String nationality =
    nationalityController.text.trim();

    final String phone =
    phoneController.text.trim();

    final String parentPhone =
    parentPhoneController.text.trim();

    final String address =
    addressController.text.trim();

    final String email =
    emailController.text.trim();

    final String city =
    cityController.text.trim();

    final String state =
    stateController.text.trim();

    final String pinCode =
    pinCodeController.text.trim();

    if (fullName.length < 3) {
      showMessage(
        'Please enter a valid student name',
      );
      return;
    }

    if (selectedGender == null ||
        selectedGender!.isEmpty) {
      showMessage(
        'Please select gender',
      );
      return;
    }

    if (!RegExp(
      r'^[0-9]{10}$',
    ).hasMatch(phone)) {
      showMessage(
        'Please enter a valid 10-digit phone number',
      );
      return;
    }

    if (parentPhone.isNotEmpty &&
        !RegExp(
          r'^[0-9]{10}$',
        ).hasMatch(parentPhone)) {
      showMessage(
        'Please enter a valid parent phone number',
      );
      return;
    }

    if (!RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email)) {
      showMessage(
        'Please enter a valid email address',
      );
      return;
    }

    if (pinCode.isNotEmpty &&
        !RegExp(
          r'^[0-9]{6}$',
        ).hasMatch(pinCode)) {
      showMessage(
        'Please enter a valid 6-digit PIN code',
      );
      return;
    }

    final bool nameExists =
    appData.students.any(
          (item) =>
      item.id != student.id &&
          item.fullName
              .trim()
              .toLowerCase() ==
              fullName.toLowerCase(),
    );

    if (nameExists) {
      showMessage(
        'This student name is already registered',
      );
      return;
    }

    final bool emailExists =
    appData.students.any(
          (item) =>
      item.id != student.id &&
          item.email
              .trim()
              .toLowerCase() ==
              email.toLowerCase(),
    );

    if (emailExists) {
      showMessage(
        'This email is already registered',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    appData.updateStudentProfile(
      studentId: student.id,
      fullName: fullName,
      guardianName: guardianName,
      dateOfBirth: dateOfBirth,
      gender: selectedGender!,
      nationality: nationality,
      phone: phone,
      parentPhone: parentPhone,
      address: address,
      email: email,
      city: city,
      state: state,
      pinCode: pinCode,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
      isEditing = false;
    });

    showMessage(
      'Profile updated successfully',
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
        ),
      );
  }
}