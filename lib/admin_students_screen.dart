import 'package:flutter/material.dart';

import 'app_data.dart';
import 'create_student_login_screen.dart';

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({
    super.key,
  });

  @override
  State<AdminStudentsScreen> createState() =>
      _AdminStudentsScreenState();
}

class _AdminStudentsScreenState
    extends State<AdminStudentsScreen> {
  static const Color darkBlue = Color(0xFF075273);
  static const Color teal = Color(0xFF55B2B8);

  final AppData appData = AppData.instance;

  @override
  void initState() {
    super.initState();
    appData.addListener(refreshScreen);
  }

  @override
  void dispose() {
    appData.removeListener(refreshScreen);
    super.dispose();
  }

  void refreshScreen() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> openCreateStudentLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const CreateStudentLoginScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<StudentData> students =
        appData.students;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Students Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: students.isEmpty
          ? buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          100,
        ),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return buildStudentCard(
            students[index],
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: openCreateStudentLogin,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(
          Icons.person_add_alt_1_outlined,
        ),
        label: const Text(
          'Create Student Login',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.groups_outlined,
                size: 58,
                color: darkBlue,
              ),
              SizedBox(height: 14),
              Text(
                'No students registered yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Create a student login to add a new student.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStudentCard(
      StudentData student,
      ) {
    final String courseName =
    appData.getCourseName(
      student.courseId,
    );

    final String batchName =
    appData.getBatchName(
      student.batchId,
    );

    final String trainerName =
    appData.getTrainerName(
      student.trainerId,
    );

    final String batchTime =
    appData.getBatchTiming(
      student.batchId,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFEAF4F7),
                child: Icon(
                  Icons.person,
                  size: 34,
                  color: darkBlue,
                ),
              ),
              const SizedBox(width: 13),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${student.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      student.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: student.isActive
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  student.isActive
                      ? 'Active'
                      : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: student.isActive
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 10),
          buildInfoRow(
            title: 'Admission',
            value: student.admissionCompleted
                ? 'Completed'
                : 'Pending',
          ),
          buildInfoRow(
            title: 'Email',
            value: student.email,
          ),
          buildInfoRow(
            title: 'Phone',
            value: student.phone,
          ),
          buildInfoRow(
            title: 'Gender',
            value: student.gender,
          ),
          buildInfoRow(
            title: 'Qualification',
            value: student.highestQualification,
          ),
          buildInfoRow(
            title: 'Applied Course',
            value: student.appliedCourse,
          ),
          buildInfoRow(
            title: 'Address',
            value: student.address,
          ),
          buildInfoRow(
            title: 'Assigned Course',
            value: courseName,
          ),
          buildInfoRow(
            title: 'Batch',
            value: batchName,
          ),
          buildInfoRow(
            title: 'Trainer',
            value: trainerName,
          ),
          buildInfoRow(
            title: 'Batch Time',
            value: batchTime,
          ),
          buildInfoRow(
            title: 'Roll Number',
            value: student.rollNumber,
          ),
          buildInfoRow(
            title: 'Joining Date',
            value: student.joiningDate,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                openEditDialog(
                  student,
                );
              },
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
                size: 19,
              ),
              label: const Text(
                'Edit Student',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required String title,
    required String value,
  }) {
    final String displayValue =
    value.trim().isEmpty
        ? 'Not Assigned'
        : value;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openEditDialog(
      StudentData student,
      ) async {
    final TextEditingController
    fullNameController =
    TextEditingController(
      text: student.fullName,
    );

    final TextEditingController
    emailController =
    TextEditingController(
      text: student.email,
    );

    final TextEditingController
    phoneController =
    TextEditingController(
      text: student.phone,
    );

    final TextEditingController
    addressController =
    TextEditingController(
      text: student.address,
    );

    final TextEditingController
    rollNumberController =
    TextEditingController(
      text: student.rollNumber,
    );

    final TextEditingController
    joiningDateController =
    TextEditingController(
      text: student.joiningDate,
    );

    String? selectedTrainerId =
    student.trainerId.isEmpty
        ? null
        : student.trainerId;

    String? selectedCourseId =
    student.courseId.isEmpty
        ? null
        : student.courseId;

    String? selectedBatchId =
    student.batchId.isEmpty
        ? null
        : student.batchId;

    final StudentEditResult? result =
    await showDialog<StudentEditResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              BuildContext context,
              StateSetter setDialogState,
              ) {
            final List<CourseData>
            availableCourses =
            selectedTrainerId == null
                ? <CourseData>[]
                : appData
                .getCoursesByTrainer(
              selectedTrainerId!,
            )
                .where(
                  (course) =>
              course.isActive,
            )
                .toList();

            if (selectedCourseId != null &&
                !availableCourses.any(
                      (course) =>
                  course.id ==
                      selectedCourseId,
                )) {
              selectedCourseId = null;
              selectedBatchId = null;
            }

            final List<BatchData>
            availableBatches =
            selectedCourseId == null
                ? <BatchData>[]
                : appData
                .getBatchesByCourse(
              selectedCourseId!,
            )
                .where(
                  (batch) =>
              batch.isActive,
            )
                .toList();

            if (selectedBatchId != null &&
                !availableBatches.any(
                      (batch) =>
                  batch.id ==
                      selectedBatchId,
                )) {
              selectedBatchId = null;
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(18),
              ),
              title: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Student',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${student.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildField(
                        controller:
                        fullNameController,
                        label: 'Full Name',
                      ),
                      buildField(
                        controller:
                        emailController,
                        label: 'Email',
                        keyboardType:
                        TextInputType
                            .emailAddress,
                      ),
                      buildField(
                        controller:
                        phoneController,
                        label: 'Phone',
                        keyboardType:
                        TextInputType.phone,
                      ),
                      buildField(
                        controller:
                        addressController,
                        label: 'Address',
                        maxLines: 2,
                      ),
                      buildField(
                        controller:
                        rollNumberController,
                        label: 'Roll Number',
                      ),
                      buildDateField(
                        context: context,
                        controller:
                        joiningDateController,
                        label: 'Joining Date',
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<
                          String>(
                        key: ValueKey(
                          'trainer_$selectedTrainerId',
                        ),
                        initialValue:
                        selectedTrainerId,
                        isExpanded: true,
                        decoration:
                        buildDecoration(
                          'Trainer',
                        ),
                        items: appData.trainers
                            .where(
                              (trainer) =>
                          trainer.isActive,
                        )
                            .map(
                              (trainer) {
                            return DropdownMenuItem<
                                String>(
                              value: trainer.id,
                              child: Text(
                                trainer.name,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedTrainerId =
                                value;

                            selectedCourseId =
                            null;

                            selectedBatchId =
                            null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<
                          String>(
                        key: ValueKey(
                          'course_${selectedTrainerId}_$selectedCourseId',
                        ),
                        initialValue:
                        selectedCourseId,
                        isExpanded: true,
                        decoration:
                        buildDecoration(
                          'Course',
                        ),
                        items: availableCourses
                            .map(
                              (course) {
                            return DropdownMenuItem<
                                String>(
                              value: course.id,
                              child: Text(
                                course.name,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ),
                            );
                          },
                        ).toList(),
                        onChanged:
                        selectedTrainerId ==
                            null
                            ? null
                            : (value) {
                          setDialogState(
                                () {
                              selectedCourseId =
                                  value;

                              selectedBatchId =
                              null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<
                          String>(
                        key: ValueKey(
                          'batch_${selectedCourseId}_$selectedBatchId',
                        ),
                        initialValue:
                        selectedBatchId,
                        isExpanded: true,
                        decoration:
                        buildDecoration(
                          'Batch',
                        ),
                        items: availableBatches
                            .map(
                              (batch) {
                            return DropdownMenuItem<
                                String>(
                              value: batch.id,
                              child: Text(
                                '${batch.name} - ${batch.timing}',
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ),
                            );
                          },
                        ).toList(),
                        onChanged:
                        selectedCourseId ==
                            null
                            ? null
                            : (value) {
                          setDialogState(
                                () {
                              selectedBatchId =
                                  value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String fullName =
                    fullNameController
                        .text
                        .trim();

                    final String email =
                    emailController
                        .text
                        .trim();

                    final String phone =
                    phoneController
                        .text
                        .trim();

                    if (fullName.isEmpty) {
                      showDialogMessage(
                        'Please enter student name',
                      );
                      return;
                    }

                    if (email.isEmpty) {
                      showDialogMessage(
                        'Please enter email address',
                      );
                      return;
                    }

                    if (phone.isEmpty) {
                      showDialogMessage(
                        'Please enter phone number',
                      );
                      return;
                    }

                    if (selectedTrainerId ==
                        null) {
                      showDialogMessage(
                        'Please select a trainer',
                      );
                      return;
                    }

                    if (selectedCourseId ==
                        null) {
                      showDialogMessage(
                        'Please select a course',
                      );
                      return;
                    }

                    if (selectedBatchId ==
                        null) {
                      showDialogMessage(
                        'Please select a batch',
                      );
                      return;
                    }

                    final CourseData?
                    selectedCourse =
                    appData
                        .findCourseById(
                      selectedCourseId!,
                    );

                    if (selectedCourse ==
                        null) {
                      showDialogMessage(
                        'Selected course is not available',
                      );
                      return;
                    }

                    final BatchData?
                    selectedBatch =
                    appData.findBatchById(
                      selectedBatchId!,
                    );

                    if (selectedBatch ==
                        null) {
                      showDialogMessage(
                        'Selected batch is not available',
                      );
                      return;
                    }

                    if (selectedCourse
                        .trainerId !=
                        selectedTrainerId) {
                      showDialogMessage(
                        'Selected course does not belong to this trainer',
                      );
                      return;
                    }

                    if (selectedBatch
                        .courseId !=
                        selectedCourse.id) {
                      showDialogMessage(
                        'Selected batch does not belong to this course',
                      );
                      return;
                    }

                    if (selectedBatch
                        .trainerId !=
                        selectedTrainerId) {
                      showDialogMessage(
                        'Selected batch does not belong to this trainer',
                      );
                      return;
                    }

                    final StudentEditResult
                    editResult =
                    StudentEditResult(
                      fullName: fullName,
                      email: email,
                      phone: phone,
                      address:
                      addressController
                          .text
                          .trim(),
                      rollNumber:
                      rollNumberController
                          .text
                          .trim(),
                      joiningDate:
                      joiningDateController
                          .text
                          .trim(),
                      trainerId:
                      selectedTrainerId!,
                      courseId:
                      selectedCourse.id,
                      batchId:
                      selectedBatch.id,
                      courseName:
                      selectedCourse.name,
                    );

                    Navigator.pop(
                      dialogContext,
                      editResult,
                    );
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    darkBlue,
                    foregroundColor:
                    Colors.white,
                  ),
                  child: const Text(
                    'Save Changes',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (result == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final BatchData? selectedBatch =
    appData.findBatchById(
      result.batchId,
    );

    if (selectedBatch == null) {
      showMessage(
        'Selected batch is no longer available',
      );
      return;
    }

    appData.updateStudent(
      studentId: student.id,
      fullName: result.fullName,
      email: result.email,
      phone: result.phone,
      address: result.address,
      courseId: result.courseId,
      batchId: result.batchId,
      trainerId: result.trainerId,
    );

    appData.assignStudentAcademicDetails(
      studentId: student.id,
      rollNumber: result.rollNumber,
      courseId: result.courseId,
      batchId: result.batchId,
      trainerId: result.trainerId,
      joiningDate: result.joiningDate,
    );

    if (!mounted) {
      return;
    }

    setState(() {});

    showMessage(
      '${result.fullName} assigned to ${result.courseName} successfully',
    );
  }

  void showDialogMessage(
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

  Future<void> selectDate(
      BuildContext context,
      TextEditingController controller,
      ) async {
    final DateTime now =
    DateTime.now();

    DateTime initialDate = now;

    final String currentDate =
    controller.text.trim();

    if (currentDate.isNotEmpty) {
      final List<String> parts =
      currentDate.split('/');

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
      firstDate: DateTime(2020),
      lastDate:
      DateTime(now.year + 5),
    );

    if (selectedDate == null) {
      return;
    }

    controller.text =
    '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year}';
  }

  Widget buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () {
          selectDate(
            context,
            controller,
          );
        },
        decoration: buildDecoration(
          label,
        ).copyWith(
          suffixIcon: const Icon(
            Icons.calendar_month_outlined,
            color: darkBlue,
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: buildDecoration(
          label,
        ),
      ),
    );
  }

  InputDecoration buildDecoration(
      String label,
      ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: teal,
          width: 1.5,
        ),
      ),
      disabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
    );
  }
}

class StudentEditResult {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String rollNumber;
  final String joiningDate;
  final String trainerId;
  final String courseId;
  final String batchId;
  final String courseName;

  const StudentEditResult({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.rollNumber,
    required this.joiningDate,
    required this.trainerId,
    required this.courseId,
    required this.batchId,
    required this.courseName,
  });
}
