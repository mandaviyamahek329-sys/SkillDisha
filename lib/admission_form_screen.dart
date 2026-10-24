import 'package:flutter/material.dart';

import 'app_data.dart';
import 'student_dashboard_screen.dart';

class AdmissionFormScreen extends StatefulWidget {
  final String studentId;

  const AdmissionFormScreen({
    super.key,
    required this.studentId,
  });

  @override
  State<AdmissionFormScreen> createState() =>
      _AdmissionFormScreenState();
}

class _AdmissionFormScreenState
    extends State<AdmissionFormScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final AppData appData = AppData.instance;

  int currentStep = 0;
  bool isLoading = false;

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  final TextEditingController guardianNameController =
  TextEditingController();

  final TextEditingController dateOfBirthController =
  TextEditingController();

  final TextEditingController nationalityController =
  TextEditingController(text: 'Indian');

  final TextEditingController parentPhoneController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  final TextEditingController cityController =
  TextEditingController();

  final TextEditingController stateController =
  TextEditingController();

  final TextEditingController pinCodeController =
  TextEditingController();

  final TextEditingController qualificationController =
  TextEditingController();

  final TextEditingController streamController =
  TextEditingController();

  final TextEditingController institutionController =
  TextEditingController();

  final TextEditingController yearController =
  TextEditingController();

  final TextEditingController percentageController =
  TextEditingController();

  final TextEditingController courseDurationController =
  TextEditingController();

  final TextEditingController startDateController =
  TextEditingController();

  final TextEditingController otherIdController =
  TextEditingController();

  final TextEditingController studentSignatureController =
  TextEditingController();

  final TextEditingController guardianSignatureController =
  TextEditingController();

  final TextEditingController declarationDateController =
  TextEditingController();

  String? selectedGender;
  String? selectedCourse;
  String? selectedTrainingMode;
  String? selectedBatchPreference;

  bool idProofCopy = false;
  bool aadhaarCard = false;
  bool panCard = false;
  bool drivingLicense = false;
  bool otherIdProof = false;

  bool tenthCertificate = false;
  bool twelfthCertificate = false;
  bool collegeCertificate = false;
  bool passportPhotoSubmitted = false;

  bool declarationAccepted = false;

  final List<String> stepTitles = const [
    'Personal Information',
    'Education',
    'Course Admission',
    'Documents',
    'Declaration',
    'Review & Submit',
  ];

  @override
  void initState() {
    super.initState();

    final StudentData? student =
    appData.findStudentById(widget.studentId);

    fullNameController = TextEditingController(
      text: student?.fullName ?? '',
    );

    emailController = TextEditingController(
      text: student?.email ?? '',
    );

    phoneController = TextEditingController(
      text: student?.phone ?? '',
    );

    if (student != null) {
      guardianNameController.text = student.guardianName;
      dateOfBirthController.text = student.dateOfBirth;

      if (student.nationality.isNotEmpty) {
        nationalityController.text = student.nationality;
      }

      parentPhoneController.text = student.parentPhone;
      addressController.text = student.address;
      cityController.text = student.city;
      stateController.text = student.state;
      pinCodeController.text = student.pinCode;

      qualificationController.text =
          student.highestQualification;

      streamController.text =
          student.streamSpecialization;

      institutionController.text =
          student.institutionName;

      yearController.text =
          student.yearOfPassing;

      percentageController.text =
          student.percentageCgpa;

      courseDurationController.text =
          student.courseDuration;

      startDateController.text =
          student.preferredStartDate;

      otherIdController.text =
          student.otherIdProofName;

      studentSignatureController.text =
          student.studentSignature;

      guardianSignatureController.text =
          student.guardianSignature;

      declarationDateController.text =
          student.declarationDate;

      selectedGender =
      student.gender.isEmpty ? null : student.gender;

      selectedCourse = student.appliedCourse.isEmpty
          ? null
          : student.appliedCourse;

      selectedTrainingMode =
      student.trainingMode.isEmpty
          ? null
          : student.trainingMode;

      selectedBatchPreference =
      student.batchPreference.isEmpty
          ? null
          : student.batchPreference;

      idProofCopy = student.idProofCopy;
      aadhaarCard = student.aadhaarCard;
      panCard = student.panCard;
      drivingLicense = student.drivingLicense;
      otherIdProof = student.otherIdProof;

      tenthCertificate = student.tenthCertificate;
      twelfthCertificate = student.twelfthCertificate;
      collegeCertificate = student.collegeCertificate;
      passportPhotoSubmitted =
          student.passportPhotoSubmitted;

      declarationAccepted =
          student.declarationAccepted;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    guardianNameController.dispose();
    dateOfBirthController.dispose();
    nationalityController.dispose();
    parentPhoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    qualificationController.dispose();
    streamController.dispose();
    institutionController.dispose();
    yearController.dispose();
    percentageController.dispose();
    courseDurationController.dispose();
    startDateController.dispose();
    otherIdController.dispose();
    studentSignatureController.dispose();
    guardianSignatureController.dispose();
    declarationDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StudentData? student =
    appData.findStudentById(widget.studentId);

    if (student == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: darkBlue,
          title: const Text('Student Admission'),
        ),
        body: const Center(
          child: Text('Student record not found.'),
        ),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: darkBlue,
          elevation: 0,
          title: const Text(
            'Student Admission',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            buildProgressHeader(),
            Expanded(
              child: buildCurrentStep(),
            ),
            buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildProgressHeader() {
    final double progress =
        (currentStep + 1) / stepTitles.length;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        8,
        4,
        8,
        6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step ${currentStep + 1} of ${stepTitles.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: darkBlue,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor:
              const Color(0xFFE5ECEF),
              color: teal,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            stepTitles[currentStep],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return buildPersonalStep();

      case 1:
        return buildEducationStep();

      case 2:
        return buildCourseStep();

      case 3:
        return buildDocumentsStep();

      case 4:
        return buildDeclarationStep();

      case 5:
        return buildReviewStep();

      default:
        return buildPersonalStep();
    }
  }

  Widget buildPersonalStep() {
    return buildPage(
      children: [
        buildTextField(
          controller: fullNameController,
          label: 'Student Full Name',
          icon: Icons.person_outline,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: guardianNameController,
          label: 'Parent / Guardian Name',
          icon: Icons.family_restroom_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildDateField(
          controller: dateOfBirthController,
          label: 'Date of Birth',
          allowFuture: false,
        ),
        buildDropdown(
          label: 'Gender',
          value: selectedGender,
          icon: Icons.wc_outlined,
          items: const [
            'Male',
            'Female',
            'Other',
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
        ),
        buildTextField(
          controller: nationalityController,
          label: 'Nationality',
          icon: Icons.flag_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: phoneController,
          label: 'Student Mobile Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        buildTextField(
          controller: parentPhoneController,
          label: 'Parent Mobile Number',
          icon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
        ),
        buildTextField(
          controller: emailController,
          label: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType:
          TextInputType.emailAddress,
        ),
        buildTextField(
          controller: addressController,
          label: 'Residential Address',
          icon: Icons.home_outlined,
          maxLines: 3,
          textCapitalization:
          TextCapitalization.sentences,
        ),
        buildTextField(
          controller: cityController,
          label: 'City',
          icon: Icons.location_city_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: stateController,
          label: 'State',
          icon: Icons.map_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: pinCodeController,
          label: 'PIN Code',
          icon: Icons.pin_drop_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget buildEducationStep() {
    return buildPage(
      children: [
        buildTextField(
          controller: qualificationController,
          label: 'Highest Qualification',
          icon: Icons.school_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: streamController,
          label: 'Stream / Specialization',
          icon: Icons.category_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: institutionController,
          label: 'College / School / University',
          icon: Icons.account_balance_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller: yearController,
          label: 'Year of Passing',
          icon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.number,
        ),
        buildTextField(
          controller: percentageController,
          label: 'Percentage or CGPA',
          icon: Icons.percent_outlined,
          keyboardType:
          const TextInputType.numberWithOptions(
            decimal: true,
          ),
        ),
      ],
    );
  }

  Widget buildCourseStep() {
    return buildPage(
      children: [
        buildDropdown(
          label: 'Course Name Applied For',
          value: selectedCourse,
          icon: Icons.menu_book_outlined,
          items: appData.courses
              .where(
                (course) => course.isActive,
          )
              .map((course) => course.name)
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCourse = value;

              if (value != null) {
                final CourseData? course =
                findCourseByName(value);

                if (course != null) {
                  courseDurationController.text =
                      course.duration;
                }
              }
            });
          },
        ),
        buildDropdown(
          label: 'Training Mode',
          value: selectedTrainingMode,
          icon: Icons.computer_outlined,
          items: const [
            'Classroom',
            'Online',
            'Hybrid',
          ],
          onChanged: (value) {
            setState(() {
              selectedTrainingMode = value;
            });
          },
        ),
        buildDropdown(
          label: 'Batch Preference',
          value: selectedBatchPreference,
          icon: Icons.schedule_outlined,
          items: const [
            'Morning',
            'Afternoon',
            'Evening',
            'Weekend',
          ],
          onChanged: (value) {
            setState(() {
              selectedBatchPreference = value;
            });
          },
        ),
        buildTextField(
          controller: courseDurationController,
          label: 'Course Duration',
          icon: Icons.timelapse_outlined,
          readOnly: true,
        ),
        buildDateField(
          controller: startDateController,
          label: 'Preferred Start Date',
          allowFuture: true,
        ),
        buildInformationBox(
          icon: Icons.info_outline,
          title: 'Course Assignment',
          message:
          'The selected course is your application preference. The final course, batch and trainer will be assigned by faculty.',
        ),
      ],
    );
  }

  Widget buildDocumentsStep() {
    return buildPage(
      children: [
        buildSectionTitle('Identity Documents'),
        buildCheckTile(
          title: 'ID Proof Copy',
          value: idProofCopy,
          onChanged: (value) {
            setState(() {
              idProofCopy = value;
            });
          },
        ),
        buildCheckTile(
          title: 'Aadhaar Card',
          value: aadhaarCard,
          onChanged: (value) {
            setState(() {
              aadhaarCard = value;
            });
          },
        ),
        buildCheckTile(
          title: 'PAN Card',
          value: panCard,
          onChanged: (value) {
            setState(() {
              panCard = value;
            });
          },
        ),
        buildCheckTile(
          title: 'Driving License',
          value: drivingLicense,
          onChanged: (value) {
            setState(() {
              drivingLicense = value;
            });
          },
        ),
        buildCheckTile(
          title: 'Other ID Proof',
          value: otherIdProof,
          onChanged: (value) {
            setState(() {
              otherIdProof = value;

              if (!value) {
                otherIdController.clear();
              }
            });
          },
        ),
        if (otherIdProof)
          buildTextField(
            controller: otherIdController,
            label: 'Other ID Proof Name',
            icon: Icons.badge_outlined,
          ),
        const SizedBox(height: 6),
        buildSectionTitle(
          'Educational Documents',
        ),
        buildCheckTile(
          title: '10th Certificate',
          value: tenthCertificate,
          onChanged: (value) {
            setState(() {
              tenthCertificate = value;
            });
          },
        ),
        buildCheckTile(
          title: '12th Certificate',
          value: twelfthCertificate,
          onChanged: (value) {
            setState(() {
              twelfthCertificate = value;
            });
          },
        ),
        buildCheckTile(
          title:
          'College / University Certificate',
          value: collegeCertificate,
          onChanged: (value) {
            setState(() {
              collegeCertificate = value;
            });
          },
        ),
        buildCheckTile(
          title:
          'Passport Size Photograph Submitted',
          value: passportPhotoSubmitted,
          onChanged: (value) {
            setState(() {
              passportPhotoSubmitted = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildDeclarationStep() {
    return buildPage(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Text(
            'I declare that the information provided above is true and correct to the best of my knowledge. I agree to follow the rules, regulations, attendance requirements, and fee policies of SkillDisha TechLab.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 6),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: darkBlue,
          value: declarationAccepted,
          controlAffinity:
          ListTileControlAffinity.leading,
          title: const Text(
            'I accept the declaration',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          onChanged: (value) {
            setState(() {
              declarationAccepted =
                  value ?? false;
            });
          },
        ),
        buildTextField(
          controller:
          studentSignatureController,
          label: 'Student Signature Name',
          icon: Icons.draw_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildTextField(
          controller:
          guardianSignatureController,
          label:
          'Parent / Guardian Signature Name',
          icon: Icons.draw_outlined,
          textCapitalization:
          TextCapitalization.words,
        ),
        buildDateField(
          controller:
          declarationDateController,
          label: 'Declaration Date',
          allowFuture: false,
        ),
      ],
    );
  }

  Widget buildReviewStep() {
    return buildPage(
      children: [
        buildReviewCard(
          title: 'Personal Information',
          icon: Icons.person_outline,
          rows: [
            ReviewRow(
              'Student Name',
              fullNameController.text,
            ),
            ReviewRow(
              'Guardian',
              guardianNameController.text,
            ),
            ReviewRow(
              'Date of Birth',
              dateOfBirthController.text,
            ),
            ReviewRow(
              'Gender',
              selectedGender ?? '',
            ),
            ReviewRow(
              'Mobile',
              phoneController.text,
            ),
            ReviewRow(
              'Email',
              emailController.text,
            ),
            ReviewRow(
              'Address',
              addressController.text,
            ),
            ReviewRow(
              'City',
              cityController.text,
            ),
            ReviewRow(
              'State',
              stateController.text,
            ),
          ],
        ),
        const SizedBox(height: 10),
        buildReviewCard(
          title: 'Education',
          icon: Icons.school_outlined,
          rows: [
            ReviewRow(
              'Qualification',
              qualificationController.text,
            ),
            ReviewRow(
              'Stream',
              streamController.text,
            ),
            ReviewRow(
              'Institution',
              institutionController.text,
            ),
            ReviewRow(
              'Passing Year',
              yearController.text,
            ),
            ReviewRow(
              'Percentage / CGPA',
              percentageController.text,
            ),
          ],
        ),
        const SizedBox(height: 10),
        buildReviewCard(
          title: 'Course Application',
          icon: Icons.menu_book_outlined,
          rows: [
            ReviewRow(
              'Applied Course',
              selectedCourse ?? '',
            ),
            ReviewRow(
              'Training Mode',
              selectedTrainingMode ?? '',
            ),
            ReviewRow(
              'Batch Preference',
              selectedBatchPreference ?? '',
            ),
            ReviewRow(
              'Duration',
              courseDurationController.text,
            ),
            ReviewRow(
              'Preferred Start',
              startDateController.text,
            ),
          ],
        ),
        const SizedBox(height: 10),
        buildInformationBox(
          icon: Icons.payments_outlined,
          title: 'Fee & Payment Details',
          message:
          'Fee details will be completed by the faculty or office after admission review.',
        ),
        const SizedBox(height: 10),
        buildInformationBox(
          icon:
          Icons.admin_panel_settings_outlined,
          title: 'Office Authorization',
          message:
          'Admission number, roll number, assigned course, batch, trainer, joining date and authorization will be completed by faculty.',
        ),
      ],
    );
  }

  Widget buildPage({
    required List<Widget> children,
  }) {
    return SingleChildScrollView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        8,
        4,
        8,
        12,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget buildBottomButtons() {
    final bool isLastStep =
        currentStep == stepTitles.length - 1;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          8,
          8,
          8,
          8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E7EB),
            ),
          ),
        ),
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed:
                    isLoading ? null : previousStep,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 17,
                    ),
                    label: const Text('Previous'),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor: darkBlue,
                      side: const BorderSide(
                        color: darkBlue,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            if (currentStep > 0)
              const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : isLastStep
                      ? submitAdmission
                      : nextStep,
                  icon: isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Icon(
                    isLastStep
                        ? Icons
                        .check_circle_outline
                        : Icons.arrow_forward,
                    size: 18,
                  ),
                  label: Text(
                    isLoading
                        ? 'Submitting...'
                        : isLastStep
                        ? 'Submit '
                        : 'Next',
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    darkBlue.withValues(
                      alpha: 0.55,
                    ),
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    final bool isMultiline = maxLines > 1;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: TextField(
        controller: controller,
        keyboardType: isMultiline
            ? TextInputType.multiline
            : keyboardType,
        textCapitalization:
        textCapitalization,
        maxLines: maxLines,
        readOnly: readOnly,
        textInputAction: isMultiline
            ? TextInputAction.newline
            : TextInputAction.next,
        decoration: buildDecoration(
          label,
          icon,
        ),
      ),
    );
  }

  Widget buildDateField({
    required TextEditingController controller,
    required String label,
    required bool allowFuture,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () {
          selectDate(
            controller,
            allowFuture: allowFuture,
          );
        },
        decoration: buildDecoration(
          label,
          Icons.calendar_month_outlined,
        ).copyWith(
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: darkBlue,
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final bool valueExists =
        value != null && items.contains(value);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: DropdownButtonFormField<String>(
        key: ValueKey(
          '${label}_${value ?? 'empty'}',
        ),
        initialValue:
        valueExists ? value : null,
        isExpanded: true,
        decoration:
        buildDecoration(label, icon),
        items: items.map(
              (item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildCheckTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: value
            ? const Color(0xFFF0F7F8)
            : const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value
              ? teal
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: CheckboxListTile(
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        dense: true,
        activeColor: darkBlue,
        value: value,
        controlAffinity:
        ListTileControlAffinity.leading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        onChanged: (newValue) {
          onChanged(newValue ?? false);
        },
      ),
    );
  }

  Widget buildSectionTitle(
      String title,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
    );
  }

  Widget buildInformationBox({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFDDE5EA),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: darkBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewCard({
    required String title,
    required IconData icon,
    required List<ReviewRow> rows,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: darkBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...rows.map(
                (row) => buildReviewRow(
              row.title,
              row.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewRow(
      String title,
      String value,
      ) {
    final String displayValue =
    value.trim().isEmpty
        ? 'Not Provided'
        : value.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 11.5,
      ),
      prefixIcon: Icon(
        icon,
        size: 18,
        color: darkBlue,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFBFC),
      isDense: true,
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
    );
  }

  Future<void> selectDate(
      TextEditingController controller, {
        required bool allowFuture,
      }) async {
    FocusScope.of(context).unfocus();

    final DateTime now = DateTime.now();

    final DateTime? selectedDate =
    await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1950),
      lastDate: allowFuture
          ? DateTime(now.year + 5)
          : now,
    );

    if (selectedDate == null) {
      return;
    }

    controller.text =
    '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year}';

    setState(() {});
  }

  CourseData? findCourseByName(
      String name,
      ) {
    try {
      return appData.courses.firstWhere(
            (course) =>
        course.name.trim().toLowerCase() ==
            name.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  void nextStep() {
    FocusScope.of(context).unfocus();

    if (!validateCurrentStep()) {
      return;
    }

    if (currentStep <
        stepTitles.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    FocusScope.of(context).unfocus();

    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return validatePersonalStep();

      case 1:
        return validateEducationStep();

      case 2:
        return validateCourseStep();

      case 3:
        return validateDocumentsStep();

      case 4:
        return validateDeclarationStep();

      default:
        return true;
    }
  }

  bool validatePersonalStep() {
    if (fullNameController.text.trim().isEmpty) {
      showMessage(
        'Please enter student full name',
      );
      return false;
    }

    if (guardianNameController.text.trim().isEmpty) {
      showMessage(
        'Please enter parent or guardian name',
      );
      return false;
    }

    if (dateOfBirthController.text.trim().isEmpty) {
      showMessage(
        'Please select date of birth',
      );
      return false;
    }

    if (selectedGender == null) {
      showMessage(
        'Please select gender',
      );
      return false;
    }

    if (nationalityController.text.trim().isEmpty) {
      showMessage(
        'Please enter nationality',
      );
      return false;
    }

    final String phone =
    phoneController.text.trim();

    if (!RegExp(
      r'^[0-9]{10}$',
    ).hasMatch(phone)) {
      showMessage(
        'Please enter a valid 10-digit student mobile number',
      );
      return false;
    }

    final String parentPhone =
    parentPhoneController.text.trim();

    if (!RegExp(
      r'^[0-9]{10}$',
    ).hasMatch(parentPhone)) {
      showMessage(
        'Please enter a valid 10-digit parent mobile number',
      );
      return false;
    }

    final String email =
    emailController.text.trim();

    final RegExp emailPattern = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailPattern.hasMatch(email)) {
      showMessage(
        'Please enter a valid email address',
      );
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      showMessage(
        'Please enter residential address',
      );
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      showMessage(
        'Please enter city',
      );
      return false;
    }

    if (stateController.text.trim().isEmpty) {
      showMessage(
        'Please enter state',
      );
      return false;
    }

    final String pinCode =
    pinCodeController.text.trim();

    if (!RegExp(
      r'^[0-9]{6}$',
    ).hasMatch(pinCode)) {
      showMessage(
        'Please enter a valid 6-digit PIN code',
      );
      return false;
    }

    return true;
  }

  bool validateEducationStep() {
    if (qualificationController.text.trim().isEmpty) {
      showMessage(
        'Please enter highest qualification',
      );
      return false;
    }

    if (streamController.text.trim().isEmpty) {
      showMessage(
        'Please enter stream or specialization',
      );
      return false;
    }

    if (institutionController.text.trim().isEmpty) {
      showMessage(
        'Please enter institution name',
      );
      return false;
    }

    if (yearController.text.trim().isEmpty) {
      showMessage(
        'Please enter year of passing',
      );
      return false;
    }

    if (percentageController.text.trim().isEmpty) {
      showMessage(
        'Please enter percentage or CGPA',
      );
      return false;
    }

    return true;
  }

  bool validateCourseStep() {
    if (selectedCourse == null) {
      showMessage(
        'Please select course',
      );
      return false;
    }

    if (selectedTrainingMode == null) {
      showMessage(
        'Please select training mode',
      );
      return false;
    }

    if (selectedBatchPreference == null) {
      showMessage(
        'Please select batch preference',
      );
      return false;
    }

    if (courseDurationController.text
        .trim()
        .isEmpty) {
      showMessage(
        'Course duration is not available',
      );
      return false;
    }

    if (startDateController.text.trim().isEmpty) {
      showMessage(
        'Please select preferred start date',
      );
      return false;
    }

    return true;
  }

  bool validateDocumentsStep() {
    if (otherIdProof &&
        otherIdController.text.trim().isEmpty) {
      showMessage(
        'Please enter other ID proof name',
      );
      return false;
    }

    return true;
  }

  bool validateDeclarationStep() {
    if (!declarationAccepted) {
      showMessage(
        'Please accept the declaration',
      );
      return false;
    }

    if (studentSignatureController.text
        .trim()
        .isEmpty) {
      showMessage(
        'Please enter student signature name',
      );
      return false;
    }

    if (guardianSignatureController.text
        .trim()
        .isEmpty) {
      showMessage(
        'Please enter parent or guardian signature name',
      );
      return false;
    }

    if (declarationDateController.text
        .trim()
        .isEmpty) {
      showMessage(
        'Please select declaration date',
      );
      return false;
    }

    return true;
  }

  bool validateAllSteps() {
    if (!validatePersonalStep()) {
      setState(() {
        currentStep = 0;
      });
      return false;
    }

    if (!validateEducationStep()) {
      setState(() {
        currentStep = 1;
      });
      return false;
    }

    if (!validateCourseStep()) {
      setState(() {
        currentStep = 2;
      });
      return false;
    }

    if (!validateDocumentsStep()) {
      setState(() {
        currentStep = 3;
      });
      return false;
    }

    if (!validateDeclarationStep()) {
      setState(() {
        currentStep = 4;
      });
      return false;
    }

    return true;
  }

  Future<void> submitAdmission() async {
    if (isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!validateAllSteps()) {
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

    appData.completeAdmission(
      studentId: widget.studentId,
      fullName:
      fullNameController.text.trim(),
      guardianName:
      guardianNameController.text.trim(),
      dateOfBirth:
      dateOfBirthController.text.trim(),
      gender: selectedGender!,
      nationality:
      nationalityController.text.trim(),
      phone:
      phoneController.text.trim(),
      parentPhone:
      parentPhoneController.text.trim(),
      address:
      addressController.text.trim(),
      email:
      emailController.text.trim(),
      city:
      cityController.text.trim(),
      state:
      stateController.text.trim(),
      pinCode:
      pinCodeController.text.trim(),
      highestQualification:
      qualificationController.text.trim(),
      streamSpecialization:
      streamController.text.trim(),
      institutionName:
      institutionController.text.trim(),
      yearOfPassing:
      yearController.text.trim(),
      percentageCgpa:
      percentageController.text.trim(),
      appliedCourse: selectedCourse!,
      trainingMode:
      selectedTrainingMode!,
      batchPreference:
      selectedBatchPreference!,
      courseDuration:
      courseDurationController.text.trim(),
      preferredStartDate:
      startDateController.text.trim(),
      idProofCopy: idProofCopy,
      aadhaarCard: aadhaarCard,
      panCard: panCard,
      drivingLicense: drivingLicense,
      otherIdProof: otherIdProof,
      otherIdProofName:
      otherIdController.text.trim(),
      tenthCertificate:
      tenthCertificate,
      twelfthCertificate:
      twelfthCertificate,
      collegeCertificate:
      collegeCertificate,
      passportPhotoSubmitted:
      passportPhotoSubmitted,
      declarationAccepted:
      declarationAccepted,
      studentSignature:
      studentSignatureController.text.trim(),
      guardianSignature:
      guardianSignatureController.text.trim(),
      declarationDate:
      declarationDateController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const StudentDashboardScreen(),
      ),
          (route) => false,
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
}

class ReviewRow {
  final String title;
  final String value;

  ReviewRow(
      this.title,
      this.value,
      );
}
