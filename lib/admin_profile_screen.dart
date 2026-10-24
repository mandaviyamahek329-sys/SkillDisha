import 'package:flutter/material.dart';

import 'app_data.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() =>
      _AdminProfileScreenState();
}

class _AdminProfileScreenState
    extends State<AdminProfileScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);
  static const Color backgroundColor =
  Color(0xFFF5F7F9);

  final AppData appData = AppData.instance;

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  final TextEditingController fullNameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController dateOfBirthController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  final TextEditingController qualificationController =
  TextEditingController();

  final TextEditingController specializationController =
  TextEditingController();

  final TextEditingController experienceController =
  TextEditingController();

  final TextEditingController bioController =
  TextEditingController();

  bool isEditing = false;
  String selectedGender = '';

  FacultyData? get faculty {
    return appData.currentFacultyOrNull;
  }

  bool get isProfileCompleted {
    final FacultyData? currentFaculty = faculty;

    if (currentFaculty == null) {
      return false;
    }

    return currentFaculty.email.trim().isNotEmpty &&
        currentFaculty.phone.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    appData.addListener(_handleDataChanged);

    _loadProfile();

    if (!isProfileCompleted) {
      isEditing = true;
    }
  }

  @override
  void dispose() {
    appData.removeListener(_handleDataChanged);

    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    qualificationController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    bioController.dispose();

    super.dispose();
  }

  void _handleDataChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void _loadProfile() {
    final FacultyData? currentFaculty = faculty;

    if (currentFaculty == null) {
      return;
    }

    final TrainerData? trainer =
    appData.findTrainerById(
      currentFaculty.trainerId,
    );

    fullNameController.text =
        currentFaculty.fullName;

    emailController.text =
        currentFaculty.email;

    phoneController.text =
        currentFaculty.phone;

    dateOfBirthController.text =
        currentFaculty.dateOfBirth;

    selectedGender =
        currentFaculty.gender;

    addressController.text =
        currentFaculty.address;

    qualificationController.text =
        currentFaculty.qualification;

    specializationController.text =
    currentFaculty.specialization.trim().isNotEmpty
        ? currentFaculty.specialization
        : trainer?.specialization ?? '';

    experienceController.text =
        currentFaculty.experience;

    bioController.text =
        currentFaculty.bio;
  }

  @override
  Widget build(BuildContext context) {
    final FacultyData? currentFaculty = faculty;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        title: Text(
          isEditing
              ? isProfileCompleted
              ? 'Edit Profile'
              : 'Create Profile'
              : 'Profile',
          style: const TextStyle(
            color: darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (currentFaculty != null &&
              !isEditing)
            IconButton(
              tooltip: 'Edit Profile',
              onPressed: _startEditing,
              icon: const Icon(
                Icons.edit_outlined,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: currentFaculty == null
            ? _buildNoProfile()
            : isEditing
            ? _buildEditProfile(
          currentFaculty,
        )
            : _buildProfile(
          currentFaculty,
        ),
      ),
    );
  }

  Widget _buildProfile(
      FacultyData currentFaculty,
      ) {
    final TrainerData? trainer =
    appData.findTrainerById(
      currentFaculty.trainerId,
    );

    final String specialization =
    currentFaculty.specialization
        .trim()
        .isNotEmpty
        ? currentFaculty.specialization
        : trainer?.specialization ??
        'Not Added';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        30,
      ),
      child: Column(
        children: [
          _buildProfileHeader(
            currentFaculty,
          ),

          const SizedBox(height: 16),

          _buildInformationCard(
            children: [
              _buildInfoRow(
                icon: Icons.badge_outlined,
                label: 'Faculty ID',
                value: currentFaculty.id,
              ),

              _buildDivider(),

              _buildInfoRow(
                icon:
                Icons.account_circle_outlined,
                label: 'Username',
                value: currentFaculty.username,
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: _displayValue(
                  currentFaculty.email,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone Number',
                value: _displayValue(
                  currentFaculty.phone,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons.cake_outlined,
                label: 'Date of Birth',
                value: _displayValue(
                  currentFaculty.dateOfBirth,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons.person_outline,
                label: 'Gender',
                value: _displayValue(
                  currentFaculty.gender,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon:
                Icons.location_on_outlined,
                label: 'Address',
                value: _displayValue(
                  currentFaculty.address,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons.school_outlined,
                label: 'Qualification',
                value: _displayValue(
                  currentFaculty.qualification,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons
                    .workspace_premium_outlined,
                label: 'Specialization',
                value: specialization,
              ),

              _buildDivider(),

              _buildInfoRow(
                icon:
                Icons.work_history_outlined,
                label: 'Experience',
                value: _displayValue(
                  currentFaculty.experience,
                ),
              ),

              _buildDivider(),

              _buildInfoRow(
                icon: Icons.notes_outlined,
                label: 'Bio',
                value: _displayValue(
                  currentFaculty.bio,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _startEditing,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      FacultyData currentFaculty,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E5E9),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor:
            const Color(0xFFEAF4F7),
            child: Text(
              _getInitials(
                currentFaculty.fullName,
              ),
              style: const TextStyle(
                color: darkBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            currentFaculty.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Faculty',
            style: TextStyle(
              color: teal,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E5E9),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildEditProfile(
      FacultyData currentFaculty,
      ) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          30,
        ),
        child: Column(
          children: [
            _buildAccountCard(
              currentFaculty,
            ),

            const SizedBox(height: 16),

            _buildEditCard(),

            const SizedBox(height: 18),

            Row(
              children: [
                if (isProfileCompleted) ...[
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed:
                        _cancelEditing,
                        style:
                        OutlinedButton
                            .styleFrom(
                          foregroundColor:
                          darkBlue,
                          side:
                          const BorderSide(
                            color: darkBlue,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                ],

                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                      _saveProfile,
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        darkBlue,
                        foregroundColor:
                        Colors.white,
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(12),
                        ),
                      ),
                      child: Text(
                        isProfileCompleted
                            ? 'Update Profile'
                            : 'Save Profile',
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(
      FacultyData currentFaculty,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F7),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline,
            color: darkBlue,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Faculty ID: ${currentFaculty.id}\n'
                  'Username: ${currentFaculty.username}',
              style: const TextStyle(
                color: darkBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E5E9),
        ),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller:
            fullNameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            requiredField: true,
          ),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType:
            TextInputType.emailAddress,
            requiredField: true,
            emailField: true,
          ),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType:
            TextInputType.phone,
            requiredField: true,
            phoneField: true,
          ),

          const SizedBox(height: 14),

          _buildDateField(),

          const SizedBox(height: 14),

          _buildGenderField(),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            addressController,
            label: 'Address',
            icon:
            Icons.location_on_outlined,
            maxLines: 2,
          ),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            qualificationController,
            label: 'Qualification',
            icon: Icons.school_outlined,
          ),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            specializationController,
            label: 'Specialization',
            icon: Icons
                .workspace_premium_outlined,
          ),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            experienceController,
            label: 'Experience',
            icon:
            Icons.work_history_outlined,
          ),

          const SizedBox(height: 14),

          _buildTextField(
            controller:
            bioController,
            label: 'Bio',
            icon: Icons.notes_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool requiredField = false,
    bool emailField = false,
    bool phoneField = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        final String text =
            value?.trim() ?? '';

        if (requiredField &&
            text.isEmpty) {
          return 'Please enter $label';
        }

        if (emailField &&
            text.isNotEmpty &&
            (!text.contains('@') ||
                !text.contains('.'))) {
          return 'Please enter a valid email address';
        }

        if (phoneField &&
            text.isNotEmpty &&
            !RegExp(
              r'^\d{10}$',
            ).hasMatch(text)) {
          return 'Please enter a valid 10-digit phone number';
        }

        return null;
      },
      decoration: _buildDecoration(
        label: label,
        icon: icon,
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller:
      dateOfBirthController,
      readOnly: true,
      onTap: _selectDateOfBirth,
      decoration: _buildDecoration(
        label: 'Date of Birth',
        icon: Icons.cake_outlined,
      ).copyWith(
        suffixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      initialValue:
      selectedGender.isEmpty
          ? null
          : selectedGender,
      decoration: _buildDecoration(
        label: 'Gender',
        icon: Icons.person_outline,
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
          selectedGender =
              value ?? '';
        });
      },
    );
  }

  InputDecoration _buildDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: darkBlue,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(11),
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(11),
        borderSide:
        const BorderSide(
          color: Color(0xFFE1E5E9),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(11),
        borderSide:
        const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
      errorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(11),
        borderSide:
        const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(11),
        borderSide:
        const BorderSide(
          color: Colors.red,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
              const Color(0xFFEAF4F7),
              borderRadius:
              BorderRadius.circular(10),
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                  const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF374151),
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Color(0xFFEEF1F3),
    );
  }

  Widget _buildNoProfile() {
    return const Center(
      child: Text(
        'Faculty profile is not available.',
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }

  Future<void>
  _selectDateOfBirth() async {
    final DateTime now =
    DateTime.now();

    final DateTime? selectedDate =
    await showDatePicker(
      context: context,
      initialDate:
      DateTime(now.year - 25),
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (selectedDate == null ||
        !mounted) {
      return;
    }

    setState(() {
      dateOfBirthController.text =
      '${selectedDate.day.toString().padLeft(2, '0')}/'
          '${selectedDate.month.toString().padLeft(2, '0')}/'
          '${selectedDate.year}';
    });
  }

  void _startEditing() {
    _loadProfile();

    setState(() {
      isEditing = true;
    });
  }

  void _cancelEditing() {
    _loadProfile();

    setState(() {
      isEditing = false;
    });
  }

  void _saveProfile() {
    final FacultyData? currentFaculty =
        faculty;

    if (currentFaculty == null) {
      return;
    }

    if (!formKey.currentState!
        .validate()) {
      return;
    }

    appData.updateFacultyProfile(
      facultyId: currentFaculty.id,
      fullName:
      fullNameController.text,
      email:
      emailController.text,
      phone:
      phoneController.text,
      dateOfBirth:
      dateOfBirthController.text,
      gender:
      selectedGender,
      address:
      addressController.text,
      qualification:
      qualificationController.text,
      specialization:
      specializationController.text,
      experience:
      experienceController.text,
      bio:
      bioController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Profile saved successfully',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  String _displayValue(
      String value,
      ) {
    return value.trim().isEmpty
        ? 'Not Added'
        : value.trim();
  }

  String _getInitials(
      String fullName,
      ) {
    final List<String> parts =
    fullName
        .trim()
        .split(
      RegExp(r'\s+'),
    )
        .where(
          (part) =>
      part.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return 'A';
    }

    if (parts.length == 1) {
      return parts.first
          .substring(0, 1)
          .toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
        '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}