import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:result_dart/result_dart.dart';

import '../../models/resume.dart';

class RemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RemoteService() {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  AsyncResult<List<ResumeModel>> getResumes(String userId) async {
    try {
      final resumesRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('resumes')
          .orderBy('updatedAt', descending: true)
          .get();
      final resumes = resumesRef.docs.map((e) => ResumeModel.fromJson(e.data())).toList();
      return Success(resumes);
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<ResumeModel> getResume(String userId, String resumeId) async {
    try {
      final resumeRef = _firestore.collection('users').doc(userId).collection('resumes').doc(resumeId);
      final resumeDoc = await resumeRef.get();
      final resumeModel = resumeDoc.data() as Map<String, dynamic>;
      return Success(ResumeModel.fromJson(resumeModel));
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<ResumeModel> saveResume(String userId, ResumeModel resume, File thumbnail) async {
    try {
      final createdResume = await _firestore.runTransaction((transation) async {
        ResumeModel newResume = resume;
        final resumesRef = _firestore.collection('users').doc(userId).collection('resumes');

        // Save photo from device
        if (resume.photo != null && !resume.photo!.startsWith('https')) {
          final profilePictureRef = _storage.ref().child('images/$userId/${newResume.id}/profile_picture');
          final storageRef = await profilePictureRef.putFile(File(newResume.photo!));
          final url = await storageRef.ref.getDownloadURL();
          newResume = newResume.copyWith(photo: url);
        }

        // Save photo from resume copy
        if (resume.photo != null && resume.photo!.startsWith('https') && resume.copyId != null) {
          final fileResult = downloadPhotoFromUrl(
            resumeId: resume.copyId!,
            url: 'images/$userId/${newResume.copyId}/profile_picture',
          );

          final file = await fileResult.getOrNull();

          if (file != null) {
            final profilePictureRef = _storage.ref().child('images/$userId/${newResume.id}/profile_picture');
            final storageRef = await profilePictureRef.putFile(file);
            final url = await storageRef.ref.getDownloadURL();
            newResume = newResume.copyWith(photo: url);
          }
        }

        // Save Thumbnail
        final thumbnailRef = _storage.ref().child('images/$userId/${newResume.id}/thumbnail');
        final storageRef = await thumbnailRef.putFile(thumbnail);
        final url = await storageRef.ref.getDownloadURL();
        newResume = newResume.copyWith(thumbnail: url);

        transation.set(resumesRef.doc(newResume.id), newResume.toJson());
        return newResume;
      });
      return Success(createdResume);
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    } catch (e) {
      final exception = RemoteException(e.toString(), 'unknown');
      return Failure(exception);
    }
  }

  AsyncResult<File> downloadPhotoFromUrl({required String resumeId, required String url}) async {
    try {
      String firebaseUrl = await _storage.ref(url).getDownloadURL();

      Directory dir = await getTemporaryDirectory();
      String filePath = "${dir.path}/$resumeId.png";

      Response<List<int>> response = await Dio().get<List<int>>(
        firebaseUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      File photoFile = File(filePath);
      await photoFile.writeAsBytes(response.data!);

      return Success(photoFile);
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    } on DioException catch (e) {
      final exception = RemoteException(e.message, e.error.toString());
      return Failure(exception);
    }
  }

  AsyncResult<Unit> deleteResume(String userId, ResumeModel resume) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('users').doc(userId).collection('resumes').doc(resume.id);
        final thumbnailRef = _storage.ref().child('images/$userId/${resume.id}/thumbnail');
        await thumbnailRef.delete();

        if (resume.photo != null) {
          final profilePictureRef = _storage.ref().child('images/$userId/${resume.id}/profile_picture');
          await profilePictureRef.delete();
        }

        transaction.delete(docRef);
        return const Success(unit);
      });
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<Unit> deleteResumes(String userId) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        final resumesRef = _firestore.collection('users').doc(userId).collection('resumes');
        final resumes = await resumesRef.get();

        for (final doc in resumes.docs) {
          final resume = ResumeModel.fromJson(doc.data());
          final thumbnailRef = _storage.ref().child('images/$userId/${resume.id}/thumbnail');
          await thumbnailRef.delete();

          if (resume.photo != null) {
            final profilePictureRef = _storage.ref().child('images/$userId/${resume.id}/profile_picture');
            await profilePictureRef.delete();
          }

          transaction.delete(doc.reference);
        }

        return const Success(unit);
      });
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }
}

class RemoteException implements Exception {
  final String? message;
  final String code;

  RemoteException(this.message, this.code);
}
