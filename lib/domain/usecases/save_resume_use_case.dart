// import 'dart:io';

// import 'package:result_dart/result_dart.dart';

// import '../../data/repositories/auth_repository/auth_repository.dart';
// import '../../data/repositories/resume_repository/resume_respository.dart';
// import '../models/resume.dart';

// class SaveResumeUseCase {

//   SaveResumeUseCase({
//     required ResumeRepository resumeRepository,
//     required AuthRepository authRepository,
//   }) : _resumeRepository = resumeRepository,
//   _authRepository = authRepository;

//   late final ResumeRepository _resumeRepository;
//   late final AuthRepository _authRepository;

//   AsyncResult<Unit> call(Resume resume) async {
//     return _authRepository.getCurrentUser()
//       .flatMap((user) => _resumeRepository.saveResume(userId: user.id, resume: resume));
//   }

//   AsyncResult<Resume> _savePicture(String userId, Resume resume) {
//     if (resume.photo != null && !resume.photo!.startsWith('https')) {
//         pictureUrl = await _.savePicture(userId, resume.id, File(resume.photo!));
//       }

//       return resume.copyWith(photo: pictureUrl);
      
//   }
// }