import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv_builder/data/models/resume.dart';
import 'package:cv_builder/domain/models/resume.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:result_dart/result_dart.dart';

class RemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RemoteService();

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

  AsyncResult<ResumeModel> saveResume(String userId, ResumeModel resume) async {
    try {
      final resumesRef = _firestore.collection('users').doc(userId).collection('resumes');
      resumesRef.doc(resume.id).set(resume.toJson());
      return Success(resume);
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<Unit> deleteResume(String userId, Resume resume) async {
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

  AsyncResult<String> savePicture(String userId, String resumeId, File file) async {
    try {
      final ref = _storage.ref().child('images/$userId/$resumeId/profile_picture');
      final storageRef = await ref.putFile(file);
      final url = await storageRef.ref.getDownloadURL();
      return Success(url);
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<String> saveThumbnail(String userId, String resumeId, File file) async {
    try {
      final ref = _storage.ref().child('images/$userId/$resumeId/thumbnail');
      final storageRef = await ref.putFile(file);
      final url = await storageRef.ref.getDownloadURL();
      return Success(url);
    } on FirebaseException catch (e) {
      final exception = RemoteException(e.message, e.code);
      return Failure(exception);
    }
  }

  Future<String> getPicture(String userId) async {
    try {
      final ref = _storage.ref().child('images/$userId/profile_picture');
      return ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

class RemoteException implements Exception {
  final String? message;
  final String code;

  RemoteException(this.message, this.code);
}
