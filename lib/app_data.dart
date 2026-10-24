import 'package:flutter/foundation.dart';

class TrainerData {
  String id;
  String name;
  String specialization;
  bool isActive;

  TrainerData({
    required this.id,
    required this.name,
    required this.specialization,
    this.isActive = true,
  });
}

class FacultyData {
  String id;
  String fullName;
  String username;
  String password;
  String trainerId;
  bool isActive;

  String email;
  String phone;
  String dateOfBirth;
  String gender;
  String address;
  String qualification;
  String specialization;
  String experience;
  String bio;

  List<String> assignedCourseIds;
  List<String> assignedBatchIds;

  FacultyData({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.trainerId,
    this.isActive = true,
    this.email = '',
    this.phone = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.address = '',
    this.qualification = '',
    this.specialization = '',
    this.experience = '',
    this.bio = '',
    List<String>? assignedCourseIds,
    List<String>? assignedBatchIds,
  })  : assignedCourseIds = assignedCourseIds ?? <String>[],
        assignedBatchIds = assignedBatchIds ?? <String>[];
}

class CourseModuleData {
  String id;
  String title;
  String description;
  bool isActive;

  CourseModuleData({
    required this.id,
    required this.title,
    this.description = '',
    this.isActive = true,
  });
}

class CourseData {
  String id;
  String name;
  String trainerId;
  String duration;
  String description;
  String about;
  List<String> whatYouWillLearn;
  List<CourseModuleData> modules;
  bool isActive;

  CourseData({
    required this.id,
    required this.name,
    required this.trainerId,
    required this.duration,
    this.description = '',
    this.about = '',
    List<String>? whatYouWillLearn,
    List<CourseModuleData>? modules,
    this.isActive = true,
  })  : whatYouWillLearn = whatYouWillLearn ?? <String>[],
        modules = modules ?? <CourseModuleData>[];
}

class BatchData {
  String id;
  String name;
  String courseId;
  String trainerId;
  String timing;
  String room;
  String days;
  bool isActive;

  BatchData({
    required this.id,
    required this.name,
    required this.courseId,
    required this.trainerId,
    required this.timing,
    required this.room,
    this.days = 'Monday - Saturday',
    this.isActive = true,
  });
}

class StudentData {
  String id;

  String fullName;
  String email;
  String phone;
  String username;
  String password;

  bool admissionCompleted;
  bool isActive;

  String guardianName;
  String dateOfBirth;
  String gender;
  String nationality;
  String parentPhone;
  String address;
  String city;
  String state;
  String pinCode;

  String highestQualification;
  String streamSpecialization;
  String institutionName;
  String yearOfPassing;
  String percentageCgpa;

  String appliedCourse;
  String trainingMode;
  String batchPreference;
  String courseDuration;
  String preferredStartDate;

  bool idProofCopy;
  bool aadhaarCard;
  bool panCard;
  bool drivingLicense;
  bool otherIdProof;
  String otherIdProofName;

  bool tenthCertificate;
  bool twelfthCertificate;
  bool collegeCertificate;
  bool passportPhotoSubmitted;

  bool declarationAccepted;
  String studentSignature;
  String guardianSignature;
  String declarationDate;

  String totalCourseFees;
  String discountOffer;
  String finalPayableFees;
  String paymentMode;
  String registrationAmount;
  String installmentPlan;
  String feeRemarks;

  bool photoSubmitted;
  bool identityProofSubmitted;
  bool qualificationProofSubmitted;
  bool addressProofSubmitted;
  bool otherDocumentsSubmitted;

  String declarationName;

  String officeRemarks;
  String authorizedBy;
  String authorizationDate;

  String rollNumber;
  String courseId;
  String batchId;
  String trainerId;
  String joiningDate;

  StudentData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    this.admissionCompleted = false,
    this.isActive = true,
    this.guardianName = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.nationality = '',
    this.parentPhone = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.pinCode = '',
    this.highestQualification = '',
    this.streamSpecialization = '',
    this.institutionName = '',
    this.yearOfPassing = '',
    this.percentageCgpa = '',
    this.appliedCourse = '',
    this.trainingMode = '',
    this.batchPreference = '',
    this.courseDuration = '',
    this.preferredStartDate = '',
    this.idProofCopy = false,
    this.aadhaarCard = false,
    this.panCard = false,
    this.drivingLicense = false,
    this.otherIdProof = false,
    this.otherIdProofName = '',
    this.tenthCertificate = false,
    this.twelfthCertificate = false,
    this.collegeCertificate = false,
    this.passportPhotoSubmitted = false,
    this.declarationAccepted = false,
    this.studentSignature = '',
    this.guardianSignature = '',
    this.declarationDate = '',
    this.totalCourseFees = '',
    this.discountOffer = '',
    this.finalPayableFees = '',
    this.paymentMode = '',
    this.registrationAmount = '',
    this.installmentPlan = '',
    this.feeRemarks = '',
    this.photoSubmitted = false,
    this.identityProofSubmitted = false,
    this.qualificationProofSubmitted = false,
    this.addressProofSubmitted = false,
    this.otherDocumentsSubmitted = false,
    this.declarationName = '',
    this.officeRemarks = '',
    this.authorizedBy = '',
    this.authorizationDate = '',
    this.rollNumber = '',
    this.courseId = '',
    this.batchId = '',
    this.trainerId = '',
    this.joiningDate = '',
  });
}

class AttendanceRecordData {
  String id;
  String studentId;
  String date;
  String status;
  String remarks;

  AttendanceRecordData({
    required this.id,
    required this.studentId,
    required this.date,
    required this.status,
    this.remarks = '',
  });
}

class StudyMaterialData {
  String id;
  String title;
  String description;
  String courseId;
  String batchId;
  String materialType;
  String materialUrl;
  String uploadedDate;
  bool isActive;

  StudyMaterialData({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.batchId,
    required this.materialType,
    required this.materialUrl,
    required this.uploadedDate,
    this.isActive = true,
  });
}

class AssignmentData {
  String id;
  String title;
  String description;
  String courseId;
  String batchId;
  String assignedDate;
  String dueDate;
  String attachmentUrl;
  bool isActive;

  AssignmentData({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.batchId,
    required this.assignedDate,
    required this.dueDate,
    required this.attachmentUrl,
    this.isActive = true,
  });
}


class ExamData {
  String id;
  String title;
  String courseId;
  String batchId;
  String examType;
  String examDate;
  String startTime;
  String duration;
  String totalMarks;
  String passingMarks;
  String instructions;
  bool isActive;

  ExamData({
    required this.id,
    required this.title,
    required this.courseId,
    required this.batchId,
    required this.examType,
    required this.examDate,
    required this.startTime,
    required this.duration,
    required this.totalMarks,
    required this.passingMarks,
    required this.instructions,
    this.isActive = true,
  });
}


class ResultData {
  String id;
  String examId;
  String studentId;
  String courseId;
  String batchId;
  String totalMarks;
  String obtainedMarks;
  String percentage;
  String resultStatus;
  String grade;
  String remarks;
  bool isPublished;

  ResultData({
    required this.id,
    required this.examId,
    required this.studentId,
    required this.courseId,
    required this.batchId,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
    required this.resultStatus,
    required this.grade,
    required this.remarks,
    this.isPublished = false,
  });
}


class NoticeData {
  String id;
  String title;
  String description;
  String audience;
  String courseId;
  String batchId;
  String publishedDate;
  bool isActive;

  NoticeData({
    required this.id,
    required this.title,
    required this.description,
    required this.audience,
    required this.courseId,
    required this.batchId,
    required this.publishedDate,
    this.isActive = true,
  });
}


class CertificateData {
  String id;
  String studentId;
  String courseId;
  String batchId;
  String title;
  String certificateNumber;
  String issueDate;
  String description;
  String certificateUrl;
  bool isActive;

  CertificateData({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.batchId,
    required this.title,
    required this.certificateNumber,
    required this.issueDate,
    required this.description,
    required this.certificateUrl,
    this.isActive = true,
  });
}


class PlacementData {
  String id;
  String companyName;
  String jobRole;
  String location;
  String jobType;
  String salary;
  String eligibility;
  String description;
  String applyUrl;
  String lastDate;
  String courseId;
  String batchId;
  bool isActive;

  PlacementData({
    required this.id,
    required this.companyName,
    required this.jobRole,
    required this.location,
    required this.jobType,
    required this.salary,
    required this.eligibility,
    required this.description,
    required this.applyUrl,
    required this.lastDate,
    required this.courseId,
    required this.batchId,
    this.isActive = true,
  });
}

class AppData extends ChangeNotifier {
  AppData._();

  static final AppData instance = AppData._();

  String? currentStudentId;
  String? currentFacultyId;

  final List<TrainerData> trainers = [
    TrainerData(
      id: 'TR001',
      name: 'Rishi Mehta',
      specialization: 'Software Development',
    ),
    TrainerData(
      id: 'TR002',
      name: 'Shailesh Patel',
      specialization: 'Cyber Security',
    ),
  ];

  final List<FacultyData> facultyMembers = [
    FacultyData(
      id: 'FC001',
      fullName: 'Rishi Mehta',
      username: 'rishi',
      password: 'rishi123',
      trainerId: 'TR001',
      assignedCourseIds: <String>[
        'CR001',
        'CR002',
        'CR003',
      ],
      assignedBatchIds: <String>[
        'BT001',
        'BT002',
        'BT003',
      ],
    ),
    FacultyData(
      id: 'FC002',
      fullName: 'Shailesh Patel',
      username: 'shailesh',
      password: 'shailesh123',
      trainerId: 'TR002',
      assignedCourseIds: <String>[
        'CR004',
        'CR005',
        'CR006',
      ],
      assignedBatchIds: <String>[
        'BT004',
        'BT005',
        'BT006',
      ],
    ),
  ];

  List<FacultyData> get faculties => facultyMembers;

  final List<CourseData> courses = [
    CourseData(
      id: 'CR001',
      name: 'Flutter App Development',
      trainerId: 'TR001',
      duration: '6 Months',
      description: 'Flutter mobile application development.',
    ),
    CourseData(
      id: 'CR002',
      name: 'Dart Programming',
      trainerId: 'TR001',
      duration: '3 Months',
      description: 'Dart programming fundamentals.',
    ),
    CourseData(
      id: 'CR003',
      name: 'Web Development',
      trainerId: 'TR001',
      duration: '6 Months',
      description: 'Modern web application development.',
    ),
    CourseData(
      id: 'CR004',
      name: 'Cyber Security Fundamentals',
      trainerId: 'TR002',
      duration: '4 Months',
      description: 'Cyber security fundamentals.',
    ),
    CourseData(
      id: 'CR005',
      name: 'Ethical Hacking',
      trainerId: 'TR002',
      duration: '5 Months',
      description: 'Ethical hacking and defensive security.',
    ),
    CourseData(
      id: 'CR006',
      name: 'Network Security',
      trainerId: 'TR002',
      duration: '4 Months',
      description: 'Network security fundamentals.',
    ),
  ];

  final List<BatchData> batches = [
    BatchData(
      id: 'BT001',
      name: 'FLT-2026-A',
      courseId: 'CR001',
      trainerId: 'TR001',
      timing: '10:00 AM - 12:00 PM',
      room: 'Lab 2',
    ),
    BatchData(
      id: 'BT002',
      name: 'DART-2026-A',
      courseId: 'CR002',
      trainerId: 'TR001',
      timing: '12:00 PM - 01:30 PM',
      room: 'Lab 2',
    ),
    BatchData(
      id: 'BT003',
      name: 'WEB-2026-A',
      courseId: 'CR003',
      trainerId: 'TR001',
      timing: '02:00 PM - 04:00 PM',
      room: 'Lab 1',
    ),
    BatchData(
      id: 'BT004',
      name: 'CYBER-2026-A',
      courseId: 'CR004',
      trainerId: 'TR002',
      timing: '10:00 AM - 12:00 PM',
      room: 'Cyber Lab',
    ),
    BatchData(
      id: 'BT005',
      name: 'ETH-2026-A',
      courseId: 'CR005',
      trainerId: 'TR002',
      timing: '01:00 PM - 03:00 PM',
      room: 'Cyber Lab',
    ),
    BatchData(
      id: 'BT006',
      name: 'NETSEC-2026-A',
      courseId: 'CR006',
      trainerId: 'TR002',
      timing: '03:30 PM - 05:30 PM',
      room: 'Cyber Lab',
    ),
  ];

  final List<StudentData> students = [
    StudentData(
      id: 'ST001',
      fullName: 'Demo Student',
      email: 'demo@student.com',
      phone: '9876543210',
      username: 'Demo Student',
      password: 'demo123',
      admissionCompleted: false,
    ),
  ];

  final List<AttendanceRecordData> attendanceRecords = [];

  final List<StudyMaterialData> studyMaterials = [];

  final List<AssignmentData> assignments = [];

  final List<ExamData> exams = [];

  final List<ResultData> results = [];

  final List<NoticeData> notices = [];

  final List<CertificateData> certificates = [];

  final List<PlacementData> placements = [];

  StudentData? get currentStudentOrNull {
    if (currentStudentId == null) {
      return null;
    }

    return findStudentById(currentStudentId!);
  }

  FacultyData? get currentFacultyOrNull {
    if (currentFacultyId == null) {
      return null;
    }

    return findFacultyById(currentFacultyId!);
  }

  CourseData? get currentStudentCourse {
    final StudentData? student = currentStudentOrNull;

    if (student == null || student.courseId.isEmpty) {
      return null;
    }

    return getCourseById(student.courseId);
  }

  BatchData? get currentStudentBatch {
    final StudentData? student = currentStudentOrNull;

    if (student == null || student.batchId.isEmpty) {
      return null;
    }

    return getBatchById(student.batchId);
  }

  TrainerData? get currentStudentTrainer {
    final StudentData? student = currentStudentOrNull;

    if (student == null || student.trainerId.isEmpty) {
      return null;
    }

    return getTrainerById(student.trainerId);
  }

  String generateCourseId() {
    int number = 1;

    while (true) {
      final String courseId =
          'CR${number.toString().padLeft(3, '0')}';

      final bool exists = courses.any(
            (course) => course.id == courseId,
      );

      if (!exists) {
        return courseId;
      }

      number++;
    }
  }

  String generateBatchId() {
    int number = 1;

    while (true) {
      final String batchId =
          'BT${number.toString().padLeft(3, '0')}';

      final bool exists = batches.any(
            (batch) => batch.id == batchId,
      );

      if (!exists) {
        return batchId;
      }

      number++;
    }
  }

  String generateCourseModuleId(CourseData course) {
    int number = 1;

    while (true) {
      final String moduleId =
          'MD${number.toString().padLeft(3, '0')}';

      final bool exists = course.modules.any(
            (module) => module.id == moduleId,
      );

      if (!exists) {
        return moduleId;
      }

      number++;
    }
  }

  String generateFacultyId() {
    int number = 1;

    while (true) {
      final String facultyId =
          'FC${number.toString().padLeft(3, '0')}';

      final bool exists = facultyMembers.any(
            (faculty) => faculty.id == facultyId,
      );

      if (!exists) {
        return facultyId;
      }

      number++;
    }
  }

  String generateTrainerId() {
    int number = 1;

    while (true) {
      final String trainerId =
          'TR${number.toString().padLeft(3, '0')}';

      final bool exists = trainers.any(
            (trainer) => trainer.id == trainerId,
      );

      if (!exists) {
        return trainerId;
      }

      number++;
    }
  }

  String generateStudentId() {
    int number = 1;

    while (true) {
      final String studentId =
          'ST${number.toString().padLeft(3, '0')}';

      final bool exists = students.any(
            (student) => student.id == studentId,
      );

      if (!exists) {
        return studentId;
      }

      number++;
    }
  }

  String generateAttendanceId() {
    int number = 1;

    while (true) {
      final String attendanceId =
          'AT${number.toString().padLeft(4, '0')}';

      final bool exists = attendanceRecords.any(
            (record) => record.id == attendanceId,
      );

      if (!exists) {
        return attendanceId;
      }

      number++;
    }
  }

  String generateStudyMaterialId() {
    int number = 1;

    while (true) {
      final String materialId =
          'SM${number.toString().padLeft(4, '0')}';

      final bool exists = studyMaterials.any(
            (material) => material.id == materialId,
      );

      if (!exists) {
        return materialId;
      }

      number++;
    }
  }

  String generateAssignmentId() {
    int number = 1;

    while (true) {
      final String assignmentId =
          'AS${number.toString().padLeft(4, '0')}';

      final bool exists = assignments.any(
            (assignment) => assignment.id == assignmentId,
      );

      if (!exists) {
        return assignmentId;
      }

      number++;
    }
  }


  String generateExamId() {
    int number = 1;

    while (true) {
      final String examId =
          'EX${number.toString().padLeft(4, '0')}';

      final bool exists = exams.any(
            (exam) => exam.id == examId,
      );

      if (!exists) {
        return examId;
      }

      number++;
    }
  }


  String generateResultId() {
    int number = 1;

    while (true) {
      final String resultId =
          'RS${number.toString().padLeft(4, '0')}';

      final bool exists = results.any(
            (result) => result.id == resultId,
      );

      if (!exists) {
        return resultId;
      }

      number++;
    }
  }




  String generatePlacementId() {
    int number = 1;

    while (true) {
      final String placementId =
          'PL${number.toString().padLeft(4, '0')}';

      final bool exists = placements.any(
            (placement) => placement.id == placementId,
      );

      if (!exists) {
        return placementId;
      }

      number++;
    }
  }

  String generateCertificateId() {
    int number = 1;

    while (true) {
      final String certificateId =
          'CT${number.toString().padLeft(4, '0')}';

      final bool exists = certificates.any(
            (certificate) => certificate.id == certificateId,
      );

      if (!exists) {
        return certificateId;
      }

      number++;
    }
  }

  String generateNoticeId() {
    int number = 1;

    while (true) {
      final String noticeId =
          'NT${number.toString().padLeft(4, '0')}';

      final bool exists = notices.any(
            (notice) => notice.id == noticeId,
      );

      if (!exists) {
        return noticeId;
      }

      number++;
    }
  }

  bool isEmailAvailable(String email) {
    final String normalizedEmail = email.trim().toLowerCase();

    return !students.any(
          (student) =>
      student.email.trim().toLowerCase() == normalizedEmail,
    );
  }

  bool isStudentNameAvailable(String fullName) {
    final String normalizedName = fullName.trim().toLowerCase();

    return !students.any(
          (student) =>
      student.fullName.trim().toLowerCase() == normalizedName,
    );
  }

  bool studentNameExists(
      String fullName, {
        String? excludeStudentId,
      }) {
    final String normalizedName = fullName.trim().toLowerCase();

    return students.any(
          (student) =>
      student.id != excludeStudentId &&
          student.fullName.trim().toLowerCase() == normalizedName,
    );
  }

  bool studentEmailExists(
      String email, {
        String? excludeStudentId,
      }) {
    final String normalizedEmail = email.trim().toLowerCase();

    return students.any(
          (student) =>
      student.id != excludeStudentId &&
          student.email.trim().toLowerCase() == normalizedEmail,
    );
  }

  StudentData registerStudent({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) {
    final StudentData student = StudentData(
      id: generateStudentId(),
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      username: fullName.trim(),
      password: password,
      admissionCompleted: false,
    );

    students.add(student);

    currentStudentId = student.id;
    currentFacultyId = null;

    notifyListeners();

    return student;
  }

  StudentData createStudentLogin({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) {
    final StudentData student = StudentData(
      id: generateStudentId(),
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      username: fullName.trim(),
      password: password,
      admissionCompleted: false,
    );

    students.add(student);

    notifyListeners();

    return student;
  }

  StudentData? loginStudent({
    required String username,
    required String password,
  }) {
    final String normalizedName = username.trim().toLowerCase();

    for (final StudentData student in students) {
      final bool nameMatches =
          student.fullName.trim().toLowerCase() == normalizedName ||
              student.username.trim().toLowerCase() == normalizedName;

      if (nameMatches &&
          student.password == password &&
          student.isActive) {
        currentStudentId = student.id;
        currentFacultyId = null;

        notifyListeners();

        return student;
      }
    }

    return null;
  }

  StudentData? authenticateStudent({
    required String username,
    required String password,
  }) {
    return loginStudent(
      username: username,
      password: password,
    );
  }

  FacultyData? loginFaculty({
    required String username,
    required String password,
  }) {
    final String normalizedUsername =
    username.trim().toLowerCase();

    for (final FacultyData faculty in facultyMembers) {
      if (faculty.username.trim().toLowerCase() ==
          normalizedUsername &&
          faculty.password == password &&
          faculty.isActive) {
        currentFacultyId = faculty.id;
        currentStudentId = null;

        notifyListeners();

        return faculty;
      }
    }

    return null;
  }

  FacultyData? authenticateFaculty({
    required String username,
    required String password,
  }) {
    return loginFaculty(
      username: username,
      password: password,
    );
  }

  bool facultyUsernameExists(String username) {
    final String normalizedUsername =
    username.trim().toLowerCase();

    return facultyMembers.any(
          (faculty) =>
      faculty.username.trim().toLowerCase() ==
          normalizedUsername,
    );
  }

  FacultyData? createAdminLogin({
    required String fullName,
    required String username,
    required String password,
    required List<String> assignedCourseIds,
    required List<String> assignedBatchIds,
  }) {
    final String normalizedName = fullName.trim();
    final String normalizedUsername = username.trim();

    if (normalizedName.isEmpty ||
        normalizedUsername.isEmpty ||
        password.isEmpty ||
        assignedCourseIds.isEmpty ||
        assignedBatchIds.isEmpty) {
      return null;
    }

    if (facultyUsernameExists(normalizedUsername)) {
      return null;
    }

    final List<String> validCourseIds = assignedCourseIds
        .where(
          (courseId) => courses.any(
            (course) =>
        course.id == courseId &&
            course.isActive,
      ),
    )
        .toSet()
        .toList();

    if (validCourseIds.isEmpty) {
      return null;
    }

    final List<String> validBatchIds = assignedBatchIds
        .where(
          (batchId) => batches.any(
            (batch) =>
        batch.id == batchId &&
            batch.isActive &&
            validCourseIds.contains(batch.courseId),
      ),
    )
        .toSet()
        .toList();

    if (validBatchIds.isEmpty) {
      return null;
    }

    final String trainerId = generateTrainerId();

    final TrainerData trainer = TrainerData(
      id: trainerId,
      name: normalizedName,
      specialization: '',
    );

    final FacultyData faculty = FacultyData(
      id: generateFacultyId(),
      fullName: normalizedName,
      username: normalizedUsername,
      password: password,
      trainerId: trainerId,
      assignedCourseIds: validCourseIds,
      assignedBatchIds: validBatchIds,
    );

    trainers.add(trainer);
    facultyMembers.add(faculty);

    notifyListeners();

    return faculty;
  }

  List<CourseData> getCoursesForFaculty(String facultyId) {
    final FacultyData? faculty = findFacultyById(facultyId);

    if (faculty == null) {
      return <CourseData>[];
    }

    return courses
        .where(
          (course) =>
          faculty.assignedCourseIds.contains(course.id),
    )
        .toList();
  }

  List<BatchData> getBatchesForFaculty(String facultyId) {
    final FacultyData? faculty = findFacultyById(facultyId);

    if (faculty == null) {
      return <BatchData>[];
    }

    return batches
        .where(
          (batch) =>
      batch.isActive &&
          faculty.assignedBatchIds.contains(batch.id) &&
          faculty.assignedCourseIds.contains(batch.courseId),
    )
        .toList();
  }

  List<CourseData> get currentFacultyCourses {
    final FacultyData? faculty = currentFacultyOrNull;

    if (faculty == null) {
      return <CourseData>[];
    }

    return getCoursesForFaculty(faculty.id);
  }

  List<BatchData> get currentFacultyBatches {
    final FacultyData? faculty = currentFacultyOrNull;

    if (faculty == null) {
      return <BatchData>[];
    }

    return getBatchesForFaculty(faculty.id);
  }

  StudentData? findStudentById(String studentId) {
    for (final StudentData student in students) {
      if (student.id == studentId) {
        return student;
      }
    }

    return null;
  }

  StudentData? getStudentById(String studentId) {
    return findStudentById(studentId);
  }

  FacultyData? findFacultyById(String facultyId) {
    for (final FacultyData faculty in facultyMembers) {
      if (faculty.id == facultyId) {
        return faculty;
      }
    }

    return null;
  }

  FacultyData? getFacultyById(String facultyId) {
    return findFacultyById(facultyId);
  }

  void updateFacultyProfile({
    required String facultyId,
    required String fullName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String address,
    required String qualification,
    required String specialization,
    required String experience,
    required String bio,
  }) {
    final FacultyData? faculty = findFacultyById(facultyId);

    if (faculty == null) {
      return;
    }

    faculty.fullName = fullName.trim();
    faculty.email = email.trim();
    faculty.phone = phone.trim();
    faculty.dateOfBirth = dateOfBirth.trim();
    faculty.gender = gender.trim();
    faculty.address = address.trim();
    faculty.qualification = qualification.trim();
    faculty.specialization = specialization.trim();
    faculty.experience = experience.trim();
    faculty.bio = bio.trim();

    notifyListeners();
  }

  CourseData? getCourseById(String courseId) {
    for (final CourseData course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }

    return null;
  }

  CourseData? findCourseById(String courseId) {
    return getCourseById(courseId);
  }

  BatchData? getBatchById(String batchId) {
    for (final BatchData batch in batches) {
      if (batch.id == batchId) {
        return batch;
      }
    }

    return null;
  }

  BatchData? findBatchById(String batchId) {
    return getBatchById(batchId);
  }

  TrainerData? getTrainerById(String trainerId) {
    for (final TrainerData trainer in trainers) {
      if (trainer.id == trainerId) {
        return trainer;
      }
    }

    return null;
  }

  TrainerData? findTrainerById(String trainerId) {
    return getTrainerById(trainerId);
  }

  String getCourseName(String courseId) {
    if (courseId.trim().isEmpty) {
      return 'Not Assigned';
    }

    return getCourseById(courseId)?.name ?? 'Not Assigned';
  }

  String getBatchName(String batchId) {
    if (batchId.trim().isEmpty) {
      return 'Not Assigned';
    }

    return getBatchById(batchId)?.name ?? 'Not Assigned';
  }

  String getBatchTiming(String batchId) {
    if (batchId.trim().isEmpty) {
      return 'Not Assigned';
    }

    return getBatchById(batchId)?.timing ?? 'Not Assigned';
  }

  String getTrainerName(String trainerId) {
    if (trainerId.trim().isEmpty) {
      return 'Not Assigned';
    }

    return getTrainerById(trainerId)?.name ?? 'Not Assigned';
  }

  List<CourseData> getCoursesByTrainer(
      String trainerId,
      ) {
    return courses
        .where(
          (course) =>
      course.trainerId == trainerId &&
          course.isActive,
    )
        .toList();
  }

  List<BatchData> getBatchesByCourse(
      String courseId,
      ) {
    return batches
        .where(
          (batch) =>
      batch.courseId == courseId &&
          batch.isActive,
    )
        .toList();
  }

  List<BatchData> getBatchesByTrainer(
      String trainerId,
      ) {
    return batches
        .where(
          (batch) =>
      batch.trainerId == trainerId &&
          batch.isActive,
    )
        .toList();
  }

  CourseData addCourse({
    required String name,
    required String trainerId,
    required String duration,
    required String description,
    required String about,
    List<String>? whatYouWillLearn,
  }) {
    final CourseData course = CourseData(
      id: generateCourseId(),
      name: name.trim(),
      trainerId: trainerId.trim(),
      duration: duration.trim(),
      description: description.trim(),
      about: about.trim(),
      whatYouWillLearn: List<String>.from(
        whatYouWillLearn ?? <String>[],
      ),
    );

    courses.add(course);

    final FacultyData? currentFaculty = currentFacultyOrNull;

    if (currentFaculty != null &&
        !currentFaculty.assignedCourseIds.contains(course.id)) {
      currentFaculty.assignedCourseIds.add(course.id);
    }

    notifyListeners();

    return course;
  }

  void updateCourse({
    required String courseId,
    required String name,
    required String trainerId,
    required String duration,
    required String description,
    required String about,
    required List<String> whatYouWillLearn,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return;
    }

    course.name = name.trim();
    course.trainerId = trainerId.trim();
    course.duration = duration.trim();
    course.description = description.trim();
    course.about = about.trim();

    course.whatYouWillLearn = whatYouWillLearn
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    for (final BatchData batch in batches) {
      if (batch.courseId == course.id) {
        batch.trainerId = course.trainerId;
      }
    }

    for (final StudentData student in students) {
      if (student.courseId == course.id) {
        student.trainerId = course.trainerId;
      }
    }

    notifyListeners();
  }

  void updateCourseStatus({
    required String courseId,
    required bool isActive,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return;
    }

    course.isActive = isActive;
    notifyListeners();
  }

  bool deleteCourse(String courseId) {
    final bool hasAssignedStudent = students.any(
          (student) => student.courseId == courseId,
    );

    if (hasAssignedStudent) {
      return false;
    }

    final int oldLength = courses.length;

    batches.removeWhere(
          (batch) => batch.courseId == courseId,
    );

    courses.removeWhere(
          (course) => course.id == courseId,
    );

    if (courses.length == oldLength) {
      return false;
    }

    notifyListeners();

    return true;
  }

  CourseModuleData? addCourseModule({
    required String courseId,
    required String title,
    required String description,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return null;
    }

    final CourseModuleData module = CourseModuleData(
      id: generateCourseModuleId(course),
      title: title.trim(),
      description: description.trim(),
    );

    course.modules.add(module);
    notifyListeners();

    return module;
  }

  void updateCourseModule({
    required String courseId,
    required String moduleId,
    required String title,
    required String description,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return;
    }

    for (final CourseModuleData module in course.modules) {
      if (module.id == moduleId) {
        module.title = title.trim();
        module.description = description.trim();

        notifyListeners();
        return;
      }
    }
  }

  void updateCourseModuleStatus({
    required String courseId,
    required String moduleId,
    required bool isActive,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return;
    }

    for (final CourseModuleData module in course.modules) {
      if (module.id == moduleId) {
        module.isActive = isActive;

        notifyListeners();
        return;
      }
    }
  }

  void deleteCourseModule({
    required String courseId,
    required String moduleId,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return;
    }

    final int oldLength = course.modules.length;

    course.modules.removeWhere(
          (module) => module.id == moduleId,
    );

    if (course.modules.length != oldLength) {
      notifyListeners();
    }
  }

  void reorderCourseModules({
    required String courseId,
    required int oldIndex,
    required int newIndex,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null ||
        oldIndex < 0 ||
        oldIndex >= course.modules.length ||
        newIndex < 0 ||
        newIndex > course.modules.length) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex--;
    }

    final CourseModuleData module =
    course.modules.removeAt(oldIndex);

    course.modules.insert(newIndex, module);

    notifyListeners();
  }

  BatchData? addBatch({
    required String name,
    required String courseId,
    required String trainerId,
    required String timing,
    required String room,
    required String days,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return null;
    }

    final BatchData batch = BatchData(
      id: generateBatchId(),
      name: name.trim(),
      courseId: course.id,
      trainerId: trainerId.trim().isEmpty
          ? course.trainerId
          : trainerId.trim(),
      timing: timing.trim(),
      room: room.trim(),
      days: days.trim().isEmpty
          ? 'Monday - Saturday'
          : days.trim(),
    );

    batches.add(batch);
    notifyListeners();

    return batch;
  }

  void updateBatch({
    required String batchId,
    required String name,
    required String courseId,
    required String trainerId,
    required String timing,
    required String room,
    required String days,
  }) {
    final BatchData? batch = findBatchById(batchId);
    final CourseData? course = findCourseById(courseId);

    if (batch == null || course == null) {
      return;
    }

    batch.name = name.trim();
    batch.courseId = course.id;

    batch.trainerId = trainerId.trim().isEmpty
        ? course.trainerId
        : trainerId.trim();

    batch.timing = timing.trim();
    batch.room = room.trim();

    batch.days = days.trim().isEmpty
        ? 'Monday - Saturday'
        : days.trim();

    for (final StudentData student in students) {
      if (student.batchId == batch.id) {
        student.courseId = batch.courseId;
        student.trainerId = batch.trainerId;
      }
    }

    notifyListeners();
  }

  void updateBatchStatus({
    required String batchId,
    required bool isActive,
  }) {
    final BatchData? batch = findBatchById(batchId);

    if (batch == null) {
      return;
    }

    batch.isActive = isActive;
    notifyListeners();
  }

  bool deleteBatch(String batchId) {
    final bool hasAssignedStudent = students.any(
          (student) => student.batchId == batchId,
    );

    if (hasAssignedStudent) {
      return false;
    }

    final int oldLength = batches.length;

    batches.removeWhere(
          (batch) => batch.id == batchId,
    );

    if (batches.length == oldLength) {
      return false;
    }

    notifyListeners();

    return true;
  }

  List<AttendanceRecordData> getAttendanceByStudent(
      String studentId,
      ) {
    final List<AttendanceRecordData> records =
    attendanceRecords
        .where(
          (record) => record.studentId == studentId,
    )
        .toList();

    records.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return records;
  }

  AttendanceRecordData? findAttendanceRecord({
    required String studentId,
    required String date,
  }) {
    final String normalizedDate = date.trim();

    for (final AttendanceRecordData record
    in attendanceRecords) {
      if (record.studentId == studentId &&
          record.date == normalizedDate) {
        return record;
      }
    }

    return null;
  }

  AttendanceRecordData? addAttendanceRecord({
    required String studentId,
    required String date,
    required String status,
    String remarks = '',
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return null;
    }

    final String normalizedDate = date.trim();
    final String normalizedStatus = status.trim();

    final AttendanceRecordData? existingRecord =
    findAttendanceRecord(
      studentId: studentId,
      date: normalizedDate,
    );

    if (existingRecord != null) {
      existingRecord.status = normalizedStatus;
      existingRecord.remarks = remarks.trim();

      notifyListeners();

      return existingRecord;
    }

    final AttendanceRecordData record =
    AttendanceRecordData(
      id: generateAttendanceId(),
      studentId: studentId,
      date: normalizedDate,
      status: normalizedStatus,
      remarks: remarks.trim(),
    );

    attendanceRecords.add(record);

    notifyListeners();

    return record;
  }

  void updateAttendanceRecord({
    required String attendanceId,
    required String date,
    required String status,
    required String remarks,
  }) {
    for (final AttendanceRecordData record
    in attendanceRecords) {
      if (record.id == attendanceId) {
        record.date = date.trim();
        record.status = status.trim();
        record.remarks = remarks.trim();

        notifyListeners();
        return;
      }
    }
  }

  bool deleteAttendanceRecord(
      String attendanceId,
      ) {
    final int oldLength = attendanceRecords.length;

    attendanceRecords.removeWhere(
          (record) => record.id == attendanceId,
    );

    if (attendanceRecords.length == oldLength) {
      return false;
    }

    notifyListeners();

    return true;
  }

  StudyMaterialData? findStudyMaterialById(
      String materialId,
      ) {
    for (final StudyMaterialData material in studyMaterials) {
      if (material.id == materialId) {
        return material;
      }
    }

    return null;
  }

  List<StudyMaterialData> getStudyMaterialsByCourse(
      String courseId,
      ) {
    final List<StudyMaterialData> materials = studyMaterials
        .where(
          (material) => material.courseId == courseId,
    )
        .toList();

    materials.sort(
          (a, b) => b.uploadedDate.compareTo(a.uploadedDate),
    );

    return materials;
  }

  List<StudyMaterialData> getStudyMaterialsByBatch(
      String batchId,
      ) {
    final List<StudyMaterialData> materials = studyMaterials
        .where(
          (material) => material.batchId == batchId,
    )
        .toList();

    materials.sort(
          (a, b) => b.uploadedDate.compareTo(a.uploadedDate),
    );

    return materials;
  }

  List<StudyMaterialData> getStudyMaterialsForStudent(
      String studentId,
      ) {
    final StudentData? student = findStudentById(studentId);

    if (student == null ||
        student.courseId.isEmpty ||
        student.batchId.isEmpty) {
      return <StudyMaterialData>[];
    }

    final List<StudyMaterialData> materials = studyMaterials
        .where(
          (material) =>
      material.isActive &&
          material.courseId == student.courseId &&
          (material.batchId.isEmpty ||
              material.batchId == student.batchId),
    )
        .toList();

    materials.sort(
          (a, b) => b.uploadedDate.compareTo(a.uploadedDate),
    );

    return materials;
  }

  StudyMaterialData? addStudyMaterial({
    required String title,
    required String description,
    required String courseId,
    required String batchId,
    required String materialType,
    required String materialUrl,
    required String uploadedDate,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return null;
    }

    if (batchId.trim().isNotEmpty) {
      final BatchData? batch = findBatchById(batchId);

      if (batch == null || batch.courseId != course.id) {
        return null;
      }
    }

    final StudyMaterialData material = StudyMaterialData(
      id: generateStudyMaterialId(),
      title: title.trim(),
      description: description.trim(),
      courseId: course.id,
      batchId: batchId.trim(),
      materialType: materialType.trim(),
      materialUrl: materialUrl.trim(),
      uploadedDate: uploadedDate.trim(),
    );

    studyMaterials.add(material);
    notifyListeners();

    return material;
  }

  void updateStudyMaterial({
    required String materialId,
    required String title,
    required String description,
    required String courseId,
    required String batchId,
    required String materialType,
    required String materialUrl,
    required String uploadedDate,
  }) {
    final StudyMaterialData? material =
    findStudyMaterialById(materialId);
    final CourseData? course = findCourseById(courseId);

    if (material == null || course == null) {
      return;
    }

    if (batchId.trim().isNotEmpty) {
      final BatchData? batch = findBatchById(batchId);

      if (batch == null || batch.courseId != course.id) {
        return;
      }
    }

    material.title = title.trim();
    material.description = description.trim();
    material.courseId = course.id;
    material.batchId = batchId.trim();
    material.materialType = materialType.trim();
    material.materialUrl = materialUrl.trim();
    material.uploadedDate = uploadedDate.trim();

    notifyListeners();
  }

  void updateStudyMaterialStatus({
    required String materialId,
    required bool isActive,
  }) {
    final StudyMaterialData? material =
    findStudyMaterialById(materialId);

    if (material == null) {
      return;
    }

    material.isActive = isActive;
    notifyListeners();
  }

  bool deleteStudyMaterial(String materialId) {
    final int oldLength = studyMaterials.length;

    studyMaterials.removeWhere(
          (material) => material.id == materialId,
    );

    if (studyMaterials.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }

  AssignmentData? findAssignmentById(String assignmentId) {
    for (final AssignmentData assignment in assignments) {
      if (assignment.id == assignmentId) {
        return assignment;
      }
    }

    return null;
  }

  List<AssignmentData> getAssignmentsByCourse(String courseId) {
    final List<AssignmentData> result = assignments
        .where((assignment) => assignment.courseId == courseId)
        .toList();

    result.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));
    return result;
  }

  List<AssignmentData> getAssignmentsByBatch(String batchId) {
    final List<AssignmentData> result = assignments
        .where((assignment) => assignment.batchId == batchId)
        .toList();

    result.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));
    return result;
  }

  List<AssignmentData> getAssignmentsForStudent(String studentId) {
    final StudentData? student = findStudentById(studentId);

    if (student == null ||
        student.courseId.isEmpty ||
        student.batchId.isEmpty) {
      return <AssignmentData>[];
    }

    final List<AssignmentData> result = assignments
        .where(
          (assignment) =>
      assignment.isActive &&
          assignment.courseId == student.courseId &&
          (assignment.batchId.isEmpty ||
              assignment.batchId == student.batchId),
    )
        .toList();

    result.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));
    return result;
  }

  AssignmentData? addAssignment({
    required String title,
    required String description,
    required String courseId,
    required String batchId,
    required String assignedDate,
    required String dueDate,
    required String attachmentUrl,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return null;
    }

    if (batchId.trim().isNotEmpty) {
      final BatchData? batch = findBatchById(batchId);

      if (batch == null || batch.courseId != course.id) {
        return null;
      }
    }

    final AssignmentData assignment = AssignmentData(
      id: generateAssignmentId(),
      title: title.trim(),
      description: description.trim(),
      courseId: course.id,
      batchId: batchId.trim(),
      assignedDate: assignedDate.trim(),
      dueDate: dueDate.trim(),
      attachmentUrl: attachmentUrl.trim(),
    );

    assignments.add(assignment);
    notifyListeners();
    return assignment;
  }

  void updateAssignment({
    required String assignmentId,
    required String title,
    required String description,
    required String courseId,
    required String batchId,
    required String assignedDate,
    required String dueDate,
    required String attachmentUrl,
  }) {
    final AssignmentData? assignment =
    findAssignmentById(assignmentId);
    final CourseData? course = findCourseById(courseId);

    if (assignment == null || course == null) {
      return;
    }

    if (batchId.trim().isNotEmpty) {
      final BatchData? batch = findBatchById(batchId);

      if (batch == null || batch.courseId != course.id) {
        return;
      }
    }

    assignment.title = title.trim();
    assignment.description = description.trim();
    assignment.courseId = course.id;
    assignment.batchId = batchId.trim();
    assignment.assignedDate = assignedDate.trim();
    assignment.dueDate = dueDate.trim();
    assignment.attachmentUrl = attachmentUrl.trim();

    notifyListeners();
  }

  void updateAssignmentStatus({
    required String assignmentId,
    required bool isActive,
  }) {
    final AssignmentData? assignment =
    findAssignmentById(assignmentId);

    if (assignment == null) {
      return;
    }

    assignment.isActive = isActive;
    notifyListeners();
  }

  bool deleteAssignment(String assignmentId) {
    final int oldLength = assignments.length;

    assignments.removeWhere(
          (assignment) => assignment.id == assignmentId,
    );

    if (assignments.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }


  ExamData? findExamById(String examId) {
    for (final ExamData exam in exams) {
      if (exam.id == examId) {
        return exam;
      }
    }

    return null;
  }

  List<ExamData> getExamsByCourse(String courseId) {
    final List<ExamData> result = exams
        .where((exam) => exam.courseId == courseId)
        .toList();

    result.sort((a, b) => b.examDate.compareTo(a.examDate));
    return result;
  }

  List<ExamData> getExamsByBatch(String batchId) {
    final List<ExamData> result = exams
        .where((exam) => exam.batchId == batchId)
        .toList();

    result.sort((a, b) => b.examDate.compareTo(a.examDate));
    return result;
  }

  List<ExamData> getExamsForStudent(String studentId) {
    final StudentData? student = findStudentById(studentId);

    if (student == null ||
        student.courseId.isEmpty ||
        student.batchId.isEmpty) {
      return <ExamData>[];
    }

    final List<ExamData> result = exams
        .where(
          (exam) =>
      exam.isActive &&
          exam.courseId == student.courseId &&
          (exam.batchId.isEmpty || exam.batchId == student.batchId),
    )
        .toList();

    result.sort((a, b) => b.examDate.compareTo(a.examDate));
    return result;
  }

  ExamData? addExam({
    required String title,
    required String courseId,
    required String batchId,
    required String examType,
    required String examDate,
    required String startTime,
    required String duration,
    required String totalMarks,
    required String passingMarks,
    required String instructions,
  }) {
    final CourseData? course = findCourseById(courseId);

    if (course == null) {
      return null;
    }

    if (batchId.trim().isNotEmpty) {
      final BatchData? batch = findBatchById(batchId);

      if (batch == null || batch.courseId != course.id) {
        return null;
      }
    }

    final ExamData exam = ExamData(
      id: generateExamId(),
      title: title.trim(),
      courseId: course.id,
      batchId: batchId.trim(),
      examType: examType.trim(),
      examDate: examDate.trim(),
      startTime: startTime.trim(),
      duration: duration.trim(),
      totalMarks: totalMarks.trim(),
      passingMarks: passingMarks.trim(),
      instructions: instructions.trim(),
    );

    exams.add(exam);
    notifyListeners();
    return exam;
  }

  void updateExam({
    required String examId,
    required String title,
    required String courseId,
    required String batchId,
    required String examType,
    required String examDate,
    required String startTime,
    required String duration,
    required String totalMarks,
    required String passingMarks,
    required String instructions,
  }) {
    final ExamData? exam = findExamById(examId);
    final CourseData? course = findCourseById(courseId);

    if (exam == null || course == null) {
      return;
    }

    if (batchId.trim().isNotEmpty) {
      final BatchData? batch = findBatchById(batchId);

      if (batch == null || batch.courseId != course.id) {
        return;
      }
    }

    exam.title = title.trim();
    exam.courseId = course.id;
    exam.batchId = batchId.trim();
    exam.examType = examType.trim();
    exam.examDate = examDate.trim();
    exam.startTime = startTime.trim();
    exam.duration = duration.trim();
    exam.totalMarks = totalMarks.trim();
    exam.passingMarks = passingMarks.trim();
    exam.instructions = instructions.trim();

    notifyListeners();
  }

  void updateExamStatus({
    required String examId,
    required bool isActive,
  }) {
    final ExamData? exam = findExamById(examId);

    if (exam == null) {
      return;
    }

    exam.isActive = isActive;
    notifyListeners();
  }

  bool deleteExam(String examId) {
    final int oldLength = exams.length;

    exams.removeWhere((exam) => exam.id == examId);

    if (exams.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }


  ResultData? findResultById(String resultId) {
    for (final ResultData result in results) {
      if (result.id == resultId) {
        return result;
      }
    }

    return null;
  }

  ResultData? findResultByExamAndStudent({
    required String examId,
    required String studentId,
  }) {
    for (final ResultData result in results) {
      if (result.examId == examId &&
          result.studentId == studentId) {
        return result;
      }
    }

    return null;
  }

  List<ResultData> getResultsByExam(String examId) {
    final List<ResultData> examResults = results
        .where((result) => result.examId == examId)
        .toList();

    examResults.sort(
          (a, b) => a.studentId.compareTo(b.studentId),
    );

    return examResults;
  }

  List<ResultData> getResultsByStudent(String studentId) {
    final List<ResultData> studentResults = results
        .where((result) => result.studentId == studentId)
        .toList();

    studentResults.sort((a, b) {
      final ExamData? examA = findExamById(a.examId);
      final ExamData? examB = findExamById(b.examId);

      final String dateA = examA?.examDate ?? '';
      final String dateB = examB?.examDate ?? '';

      return dateB.compareTo(dateA);
    });

    return studentResults;
  }

  List<ResultData> getPublishedResultsForStudent(
      String studentId,
      ) {
    final List<ResultData> studentResults = results
        .where(
          (result) =>
      result.studentId == studentId &&
          result.isPublished,
    )
        .toList();

    studentResults.sort((a, b) {
      final ExamData? examA = findExamById(a.examId);
      final ExamData? examB = findExamById(b.examId);

      final String dateA = examA?.examDate ?? '';
      final String dateB = examB?.examDate ?? '';

      return dateB.compareTo(dateA);
    });

    return studentResults;
  }

  List<StudentData> getEligibleStudentsForExam(
      String examId,
      ) {
    final ExamData? exam = findExamById(examId);

    if (exam == null) {
      return <StudentData>[];
    }

    final List<StudentData> eligibleStudents = students
        .where(
          (student) =>
      student.isActive &&
          student.courseId == exam.courseId &&
          (exam.batchId.isEmpty ||
              student.batchId == exam.batchId),
    )
        .toList();

    eligibleStudents.sort(
          (a, b) => a.fullName.compareTo(b.fullName),
    );

    return eligibleStudents;
  }

  ResultData? addResult({
    required String examId,
    required String studentId,
    required String obtainedMarks,
    required String remarks,
    bool isPublished = false,
  }) {
    final ExamData? exam = findExamById(examId);
    final StudentData? student = findStudentById(studentId);

    if (exam == null || student == null) {
      return null;
    }

    final bool studentMatchesExam =
        student.courseId == exam.courseId &&
            (exam.batchId.isEmpty ||
                student.batchId == exam.batchId);

    if (!studentMatchesExam) {
      return null;
    }

    if (findResultByExamAndStudent(
      examId: examId,
      studentId: studentId,
    ) !=
        null) {
      return null;
    }

    final double? total =
    double.tryParse(exam.totalMarks.trim());
    final double? passing =
    double.tryParse(exam.passingMarks.trim());
    final double? obtained =
    double.tryParse(obtainedMarks.trim());

    if (total == null ||
        passing == null ||
        obtained == null ||
        total <= 0 ||
        passing < 0 ||
        obtained < 0 ||
        obtained > total) {
      return null;
    }

    final double percentageValue =
        (obtained / total) * 100;

    final String resultStatus =
    obtained >= passing ? 'Pass' : 'Fail';

    final ResultData result = ResultData(
      id: generateResultId(),
      examId: exam.id,
      studentId: student.id,
      courseId: exam.courseId,
      batchId: student.batchId,
      totalMarks: exam.totalMarks.trim(),
      obtainedMarks: formatResultNumber(obtained),
      percentage: percentageValue.toStringAsFixed(2),
      resultStatus: resultStatus,
      grade: calculateResultGrade(percentageValue),
      remarks: remarks.trim(),
      isPublished: isPublished,
    );

    results.add(result);
    notifyListeners();

    return result;
  }

  bool updateResult({
    required String resultId,
    required String examId,
    required String studentId,
    required String obtainedMarks,
    required String remarks,
  }) {
    final ResultData? result = findResultById(resultId);
    final ExamData? exam = findExamById(examId);
    final StudentData? student = findStudentById(studentId);

    if (result == null ||
        exam == null ||
        student == null) {
      return false;
    }

    final bool studentMatchesExam =
        student.courseId == exam.courseId &&
            (exam.batchId.isEmpty ||
                student.batchId == exam.batchId);

    if (!studentMatchesExam) {
      return false;
    }

    final ResultData? duplicate =
    findResultByExamAndStudent(
      examId: examId,
      studentId: studentId,
    );

    if (duplicate != null &&
        duplicate.id != result.id) {
      return false;
    }

    final double? total =
    double.tryParse(exam.totalMarks.trim());
    final double? passing =
    double.tryParse(exam.passingMarks.trim());
    final double? obtained =
    double.tryParse(obtainedMarks.trim());

    if (total == null ||
        passing == null ||
        obtained == null ||
        total <= 0 ||
        passing < 0 ||
        obtained < 0 ||
        obtained > total) {
      return false;
    }

    final double percentageValue =
        (obtained / total) * 100;

    result.examId = exam.id;
    result.studentId = student.id;
    result.courseId = exam.courseId;
    result.batchId = student.batchId;
    result.totalMarks = exam.totalMarks.trim();
    result.obtainedMarks =
        formatResultNumber(obtained);
    result.percentage =
        percentageValue.toStringAsFixed(2);
    result.resultStatus =
    obtained >= passing ? 'Pass' : 'Fail';
    result.grade =
        calculateResultGrade(percentageValue);
    result.remarks = remarks.trim();

    notifyListeners();
    return true;
  }

  void updateResultPublishStatus({
    required String resultId,
    required bool isPublished,
  }) {
    final ResultData? result = findResultById(resultId);

    if (result == null) {
      return;
    }

    result.isPublished = isPublished;
    notifyListeners();
  }

  bool deleteResult(String resultId) {
    final int oldLength = results.length;

    results.removeWhere(
          (result) => result.id == resultId,
    );

    if (results.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }

  String calculateResultGrade(double percentage) {
    if (percentage >= 90) {
      return 'A+';
    }

    if (percentage >= 80) {
      return 'A';
    }

    if (percentage >= 70) {
      return 'B+';
    }

    if (percentage >= 60) {
      return 'B';
    }

    if (percentage >= 50) {
      return 'C';
    }

    if (percentage >= 40) {
      return 'D';
    }

    return 'F';
  }

  String formatResultNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }




  PlacementData? findPlacementById(String placementId) {
    for (final PlacementData placement in placements) {
      if (placement.id == placementId) {
        return placement;
      }
    }

    return null;
  }

  List<PlacementData> getPlacementsForStudent(String studentId) {
    final StudentData? student = findStudentById(studentId);

    if (student == null || student.courseId.isEmpty) {
      return <PlacementData>[];
    }

    final List<PlacementData> studentPlacements = placements
        .where(
          (placement) =>
      placement.isActive &&
          placement.courseId == student.courseId &&
          (placement.batchId.isEmpty ||
              placement.batchId == student.batchId),
    )
        .toList();

    studentPlacements.sort(
          (a, b) => b.lastDate.compareTo(a.lastDate),
    );

    return studentPlacements;
  }

  PlacementData? addPlacement({
    required String companyName,
    required String jobRole,
    required String location,
    required String jobType,
    required String salary,
    required String eligibility,
    required String description,
    required String applyUrl,
    required String lastDate,
    required String courseId,
    required String batchId,
  }) {
    final CourseData? course = findCourseById(courseId.trim());

    if (course == null) {
      return null;
    }

    final String normalizedBatchId = batchId.trim();

    if (normalizedBatchId.isNotEmpty) {
      final BatchData? batch = findBatchById(normalizedBatchId);

      if (batch == null || batch.courseId != course.id) {
        return null;
      }
    }

    final PlacementData placement = PlacementData(
      id: generatePlacementId(),
      companyName: companyName.trim(),
      jobRole: jobRole.trim(),
      location: location.trim(),
      jobType: jobType.trim(),
      salary: salary.trim(),
      eligibility: eligibility.trim(),
      description: description.trim(),
      applyUrl: applyUrl.trim(),
      lastDate: lastDate.trim(),
      courseId: course.id,
      batchId: normalizedBatchId,
    );

    placements.add(placement);
    notifyListeners();

    return placement;
  }

  bool updatePlacement({
    required String placementId,
    required String companyName,
    required String jobRole,
    required String location,
    required String jobType,
    required String salary,
    required String eligibility,
    required String description,
    required String applyUrl,
    required String lastDate,
    required String courseId,
    required String batchId,
  }) {
    final PlacementData? placement = findPlacementById(placementId);
    final CourseData? course = findCourseById(courseId.trim());

    if (placement == null || course == null) {
      return false;
    }

    final String normalizedBatchId = batchId.trim();

    if (normalizedBatchId.isNotEmpty) {
      final BatchData? batch = findBatchById(normalizedBatchId);

      if (batch == null || batch.courseId != course.id) {
        return false;
      }
    }

    placement.companyName = companyName.trim();
    placement.jobRole = jobRole.trim();
    placement.location = location.trim();
    placement.jobType = jobType.trim();
    placement.salary = salary.trim();
    placement.eligibility = eligibility.trim();
    placement.description = description.trim();
    placement.applyUrl = applyUrl.trim();
    placement.lastDate = lastDate.trim();
    placement.courseId = course.id;
    placement.batchId = normalizedBatchId;

    notifyListeners();
    return true;
  }

  void updatePlacementStatus({
    required String placementId,
    required bool isActive,
  }) {
    final PlacementData? placement = findPlacementById(placementId);

    if (placement == null) {
      return;
    }

    placement.isActive = isActive;
    notifyListeners();
  }

  bool deletePlacement(String placementId) {
    final int oldLength = placements.length;

    placements.removeWhere(
          (placement) => placement.id == placementId,
    );

    if (placements.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }

  CertificateData? findCertificateById(String certificateId) {
    for (final CertificateData certificate in certificates) {
      if (certificate.id == certificateId) {
        return certificate;
      }
    }

    return null;
  }

  List<CertificateData> getCertificatesForStudent(String studentId) {
    final List<CertificateData> studentCertificates = certificates
        .where(
          (certificate) =>
      certificate.isActive &&
          certificate.studentId == studentId,
    )
        .toList();

    studentCertificates.sort(
          (a, b) => b.issueDate.compareTo(a.issueDate),
    );

    return studentCertificates;
  }

  CertificateData? addCertificate({
    required String studentId,
    required String title,
    required String certificateNumber,
    required String issueDate,
    required String description,
    required String certificateUrl,
  }) {
    final StudentData? student = findStudentById(studentId.trim());

    if (student == null || student.courseId.isEmpty) {
      return null;
    }

    final String normalizedCertificateNumber =
    certificateNumber.trim();

    final bool duplicateNumber = certificates.any(
          (certificate) =>
      certificate.certificateNumber.toLowerCase() ==
          normalizedCertificateNumber.toLowerCase(),
    );

    if (normalizedCertificateNumber.isEmpty || duplicateNumber) {
      return null;
    }

    final CertificateData certificate = CertificateData(
      id: generateCertificateId(),
      studentId: student.id,
      courseId: student.courseId,
      batchId: student.batchId,
      title: title.trim(),
      certificateNumber: normalizedCertificateNumber,
      issueDate: issueDate.trim(),
      description: description.trim(),
      certificateUrl: certificateUrl.trim(),
    );

    certificates.add(certificate);
    notifyListeners();

    return certificate;
  }

  bool updateCertificate({
    required String certificateId,
    required String studentId,
    required String title,
    required String certificateNumber,
    required String issueDate,
    required String description,
    required String certificateUrl,
  }) {
    final CertificateData? certificate =
    findCertificateById(certificateId);

    final StudentData? student = findStudentById(studentId.trim());

    if (certificate == null ||
        student == null ||
        student.courseId.isEmpty) {
      return false;
    }

    final String normalizedCertificateNumber =
    certificateNumber.trim();

    final bool duplicateNumber = certificates.any(
          (item) =>
      item.id != certificateId &&
          item.certificateNumber.toLowerCase() ==
              normalizedCertificateNumber.toLowerCase(),
    );

    if (normalizedCertificateNumber.isEmpty || duplicateNumber) {
      return false;
    }

    certificate.studentId = student.id;
    certificate.courseId = student.courseId;
    certificate.batchId = student.batchId;
    certificate.title = title.trim();
    certificate.certificateNumber = normalizedCertificateNumber;
    certificate.issueDate = issueDate.trim();
    certificate.description = description.trim();
    certificate.certificateUrl = certificateUrl.trim();

    notifyListeners();
    return true;
  }

  void updateCertificateStatus({
    required String certificateId,
    required bool isActive,
  }) {
    final CertificateData? certificate =
    findCertificateById(certificateId);

    if (certificate == null) {
      return;
    }

    certificate.isActive = isActive;
    notifyListeners();
  }

  bool deleteCertificate(String certificateId) {
    final int oldLength = certificates.length;

    certificates.removeWhere(
          (certificate) => certificate.id == certificateId,
    );

    if (certificates.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }

  NoticeData? findNoticeById(String noticeId) {
    for (final NoticeData notice in notices) {
      if (notice.id == noticeId) {
        return notice;
      }
    }

    return null;
  }

  List<NoticeData> getNoticesForStudent(String studentId) {
    final StudentData? student = findStudentById(studentId);

    if (student == null) {
      return <NoticeData>[];
    }

    final List<NoticeData> studentNotices = notices.where(
          (notice) {
        if (!notice.isActive) {
          return false;
        }

        if (notice.audience == 'All Students') {
          return true;
        }

        if (notice.audience == 'Course') {
          return student.courseId.isNotEmpty &&
              notice.courseId == student.courseId;
        }

        if (notice.audience == 'Batch') {
          return student.batchId.isNotEmpty &&
              notice.batchId == student.batchId;
        }

        return false;
      },
    ).toList();

    studentNotices.sort(
          (a, b) => b.publishedDate.compareTo(a.publishedDate),
    );

    return studentNotices;
  }

  NoticeData? addNotice({
    required String title,
    required String description,
    required String audience,
    required String courseId,
    required String batchId,
    required String publishedDate,
  }) {
    final String normalizedAudience = audience.trim();
    final String normalizedCourseId = courseId.trim();
    final String normalizedBatchId = batchId.trim();

    if (normalizedAudience == 'Course') {
      if (findCourseById(normalizedCourseId) == null) {
        return null;
      }
    }

    if (normalizedAudience == 'Batch') {
      final BatchData? batch = findBatchById(normalizedBatchId);

      if (batch == null) {
        return null;
      }
    }

    final NoticeData notice = NoticeData(
      id: generateNoticeId(),
      title: title.trim(),
      description: description.trim(),
      audience: normalizedAudience,
      courseId: normalizedAudience == 'Course'
          ? normalizedCourseId
          : '',
      batchId: normalizedAudience == 'Batch'
          ? normalizedBatchId
          : '',
      publishedDate: publishedDate.trim(),
    );

    notices.add(notice);
    notifyListeners();

    return notice;
  }

  bool updateNotice({
    required String noticeId,
    required String title,
    required String description,
    required String audience,
    required String courseId,
    required String batchId,
    required String publishedDate,
  }) {
    final NoticeData? notice = findNoticeById(noticeId);

    if (notice == null) {
      return false;
    }

    final String normalizedAudience = audience.trim();
    final String normalizedCourseId = courseId.trim();
    final String normalizedBatchId = batchId.trim();

    if (normalizedAudience == 'Course') {
      if (findCourseById(normalizedCourseId) == null) {
        return false;
      }
    }

    if (normalizedAudience == 'Batch') {
      if (findBatchById(normalizedBatchId) == null) {
        return false;
      }
    }

    notice.title = title.trim();
    notice.description = description.trim();
    notice.audience = normalizedAudience;
    notice.courseId = normalizedAudience == 'Course'
        ? normalizedCourseId
        : '';
    notice.batchId = normalizedAudience == 'Batch'
        ? normalizedBatchId
        : '';
    notice.publishedDate = publishedDate.trim();

    notifyListeners();
    return true;
  }

  void updateNoticeStatus({
    required String noticeId,
    required bool isActive,
  }) {
    final NoticeData? notice = findNoticeById(noticeId);

    if (notice == null) {
      return;
    }

    notice.isActive = isActive;
    notifyListeners();
  }

  bool deleteNotice(String noticeId) {
    final int oldLength = notices.length;

    notices.removeWhere(
          (notice) => notice.id == noticeId,
    );

    if (notices.length == oldLength) {
      return false;
    }

    notifyListeners();
    return true;
  }

  StudentData? findStudentForRecovery(
      String value,
      ) {
    final String normalizedValue =
    value.trim().toLowerCase();

    for (final StudentData student in students) {
      if (student.fullName.trim().toLowerCase() ==
          normalizedValue ||
          student.username.trim().toLowerCase() ==
              normalizedValue ||
          student.email.trim().toLowerCase() ==
              normalizedValue ||
          student.phone.trim() == value.trim()) {
        return student;
      }
    }

    return null;
  }

  bool resetStudentPassword({
    required String studentId,
    required String newPassword,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return false;
    }

    student.password = newPassword;

    notifyListeners();

    return true;
  }

  void updateStudentPassword({
    required String studentId,
    required String newPassword,
  }) {
    resetStudentPassword(
      studentId: studentId,
      newPassword: newPassword,
    );
  }

  void updateStudent({
    required String studentId,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required String courseId,
    required String batchId,
    required String trainerId,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    student.fullName = fullName.trim();
    student.username = fullName.trim();
    student.email = email.trim();
    student.phone = phone.trim();
    student.address = address.trim();
    student.courseId = courseId.trim();
    student.batchId = batchId.trim();
    student.trainerId = trainerId.trim();

    notifyListeners();
  }

  void updateStudentProfile({
    required String studentId,
    required String fullName,
    required String guardianName,
    required String dateOfBirth,
    required String gender,
    required String nationality,
    required String phone,
    required String parentPhone,
    required String address,
    required String email,
    required String city,
    required String state,
    required String pinCode,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    student.fullName = fullName.trim();
    student.username = fullName.trim();
    student.guardianName = guardianName.trim();
    student.dateOfBirth = dateOfBirth.trim();
    student.gender = gender.trim();
    student.nationality = nationality.trim();
    student.phone = phone.trim();
    student.parentPhone = parentPhone.trim();
    student.address = address.trim();
    student.email = email.trim();
    student.city = city.trim();
    student.state = state.trim();
    student.pinCode = pinCode.trim();

    notifyListeners();
  }

  void assignStudentAcademicDetails({
    required String studentId,
    required String rollNumber,
    required String courseId,
    required String batchId,
    required String trainerId,
    required String joiningDate,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    final BatchData? selectedBatch =
    findBatchById(batchId);

    if (selectedBatch == null) {
      return;
    }

    student.rollNumber = rollNumber.trim();
    student.courseId = selectedBatch.courseId;
    student.batchId = selectedBatch.id;
    student.trainerId = selectedBatch.trainerId;
    student.joiningDate = joiningDate.trim();

    notifyListeners();
  }

  void completeAdmission({
    required String studentId,
    required String fullName,
    required String guardianName,
    required String dateOfBirth,
    required String gender,
    required String nationality,
    required String phone,
    required String parentPhone,
    required String address,
    required String email,
    required String city,
    required String state,
    required String pinCode,
    required String highestQualification,
    required String streamSpecialization,
    required String institutionName,
    required String yearOfPassing,
    required String percentageCgpa,
    required String appliedCourse,
    required String trainingMode,
    required String batchPreference,
    required String courseDuration,
    required String preferredStartDate,
    required bool idProofCopy,
    required bool aadhaarCard,
    required bool panCard,
    required bool drivingLicense,
    required bool otherIdProof,
    required String otherIdProofName,
    required bool tenthCertificate,
    required bool twelfthCertificate,
    required bool collegeCertificate,
    required bool passportPhotoSubmitted,
    required bool declarationAccepted,
    required String studentSignature,
    required String guardianSignature,
    required String declarationDate,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    student.fullName = fullName.trim();
    student.username = fullName.trim();
    student.guardianName = guardianName.trim();
    student.dateOfBirth = dateOfBirth.trim();
    student.gender = gender.trim();
    student.nationality = nationality.trim();
    student.phone = phone.trim();
    student.parentPhone = parentPhone.trim();
    student.address = address.trim();
    student.email = email.trim();
    student.city = city.trim();
    student.state = state.trim();
    student.pinCode = pinCode.trim();

    student.highestQualification =
        highestQualification.trim();
    student.streamSpecialization =
        streamSpecialization.trim();
    student.institutionName =
        institutionName.trim();
    student.yearOfPassing =
        yearOfPassing.trim();
    student.percentageCgpa =
        percentageCgpa.trim();

    student.appliedCourse =
        appliedCourse.trim();
    student.trainingMode =
        trainingMode.trim();
    student.batchPreference =
        batchPreference.trim();
    student.courseDuration =
        courseDuration.trim();
    student.preferredStartDate =
        preferredStartDate.trim();

    student.idProofCopy = idProofCopy;
    student.aadhaarCard = aadhaarCard;
    student.panCard = panCard;
    student.drivingLicense = drivingLicense;
    student.otherIdProof = otherIdProof;
    student.otherIdProofName =
        otherIdProofName.trim();

    student.tenthCertificate =
        tenthCertificate;
    student.twelfthCertificate =
        twelfthCertificate;
    student.collegeCertificate =
        collegeCertificate;
    student.passportPhotoSubmitted =
        passportPhotoSubmitted;

    student.declarationAccepted =
        declarationAccepted;
    student.studentSignature =
        studentSignature.trim();
    student.guardianSignature =
        guardianSignature.trim();
    student.declarationDate =
        declarationDate.trim();

    student.identityProofSubmitted =
        idProofCopy ||
            aadhaarCard ||
            panCard ||
            drivingLicense ||
            otherIdProof;

    student.qualificationProofSubmitted =
        tenthCertificate ||
            twelfthCertificate ||
            collegeCertificate;

    student.photoSubmitted =
        passportPhotoSubmitted;

    student.declarationName =
        studentSignature.trim();

    student.admissionCompleted = true;

    notifyListeners();
  }

  void updateStudentAdmission({
    required String studentId,
    String? guardianName,
    String? dateOfBirth,
    String? gender,
    String? nationality,
    String? parentPhone,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? highestQualification,
    String? streamSpecialization,
    String? institutionName,
    String? yearOfPassing,
    String? percentageCgpa,
    String? appliedCourse,
    String? trainingMode,
    String? batchPreference,
    String? courseDuration,
    String? preferredStartDate,
    String? totalCourseFees,
    String? discountOffer,
    String? finalPayableFees,
    String? paymentMode,
    String? registrationAmount,
    String? installmentPlan,
    String? feeRemarks,
    bool? photoSubmitted,
    bool? identityProofSubmitted,
    bool? qualificationProofSubmitted,
    bool? addressProofSubmitted,
    bool? otherDocumentsSubmitted,
    bool? declarationAccepted,
    String? declarationName,
    String? declarationDate,
    String? officeRemarks,
    String? authorizedBy,
    String? authorizationDate,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    if (guardianName != null) {
      student.guardianName =
          guardianName.trim();
    }

    if (dateOfBirth != null) {
      student.dateOfBirth =
          dateOfBirth.trim();
    }

    if (gender != null) {
      student.gender = gender.trim();
    }

    if (nationality != null) {
      student.nationality =
          nationality.trim();
    }

    if (parentPhone != null) {
      student.parentPhone =
          parentPhone.trim();
    }

    if (address != null) {
      student.address = address.trim();
    }

    if (city != null) {
      student.city = city.trim();
    }

    if (state != null) {
      student.state = state.trim();
    }

    if (pinCode != null) {
      student.pinCode = pinCode.trim();
    }

    if (highestQualification != null) {
      student.highestQualification =
          highestQualification.trim();
    }

    if (streamSpecialization != null) {
      student.streamSpecialization =
          streamSpecialization.trim();
    }

    if (institutionName != null) {
      student.institutionName =
          institutionName.trim();
    }

    if (yearOfPassing != null) {
      student.yearOfPassing =
          yearOfPassing.trim();
    }

    if (percentageCgpa != null) {
      student.percentageCgpa =
          percentageCgpa.trim();
    }

    if (appliedCourse != null) {
      student.appliedCourse =
          appliedCourse.trim();
    }

    if (trainingMode != null) {
      student.trainingMode =
          trainingMode.trim();
    }

    if (batchPreference != null) {
      student.batchPreference =
          batchPreference.trim();
    }

    if (courseDuration != null) {
      student.courseDuration =
          courseDuration.trim();
    }

    if (preferredStartDate != null) {
      student.preferredStartDate =
          preferredStartDate.trim();
    }

    if (totalCourseFees != null) {
      student.totalCourseFees =
          totalCourseFees.trim();
    }

    if (discountOffer != null) {
      student.discountOffer =
          discountOffer.trim();
    }

    if (finalPayableFees != null) {
      student.finalPayableFees =
          finalPayableFees.trim();
    }

    if (paymentMode != null) {
      student.paymentMode =
          paymentMode.trim();
    }

    if (registrationAmount != null) {
      student.registrationAmount =
          registrationAmount.trim();
    }

    if (installmentPlan != null) {
      student.installmentPlan =
          installmentPlan.trim();
    }

    if (feeRemarks != null) {
      student.feeRemarks =
          feeRemarks.trim();
    }

    if (photoSubmitted != null) {
      student.photoSubmitted =
          photoSubmitted;
    }

    if (identityProofSubmitted != null) {
      student.identityProofSubmitted =
          identityProofSubmitted;
    }

    if (qualificationProofSubmitted != null) {
      student.qualificationProofSubmitted =
          qualificationProofSubmitted;
    }

    if (addressProofSubmitted != null) {
      student.addressProofSubmitted =
          addressProofSubmitted;
    }

    if (otherDocumentsSubmitted != null) {
      student.otherDocumentsSubmitted =
          otherDocumentsSubmitted;
    }

    if (declarationAccepted != null) {
      student.declarationAccepted =
          declarationAccepted;
    }

    if (declarationName != null) {
      student.declarationName =
          declarationName.trim();
    }

    if (declarationDate != null) {
      student.declarationDate =
          declarationDate.trim();
    }

    if (officeRemarks != null) {
      student.officeRemarks =
          officeRemarks.trim();
    }

    if (authorizedBy != null) {
      student.authorizedBy =
          authorizedBy.trim();
    }

    if (authorizationDate != null) {
      student.authorizationDate =
          authorizationDate.trim();
    }

    notifyListeners();
  }

  void setAdmissionCompleted({
    required String studentId,
    required bool completed,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    student.admissionCompleted = completed;

    notifyListeners();
  }

  void updateStudentStatus({
    required String studentId,
    required bool isActive,
  }) {
    final StudentData? student =
    findStudentById(studentId);

    if (student == null) {
      return;
    }

    student.isActive = isActive;

    notifyListeners();
  }

  void logoutStudent() {
    currentStudentId = null;
    notifyListeners();
  }

  void logoutFaculty() {
    currentFacultyId = null;
    notifyListeners();
  }

  void logoutAll() {
    currentStudentId = null;
    currentFacultyId = null;
    notifyListeners();
  }
}

