import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv_builder/data/models/resume.dart';
import 'package:cv_builder/domain/models/resume.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RemoteService();

  Future<void> deleteGuestUser(String id) async {
    try {
      _firestore.collection('users').doc(id).delete().catchError(
            (e) => print(e),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveGuestUser(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.set({'name': '', 'email': ''});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ResumeModel>> getResumes(String userId) async {
    try {
      final resumesRef = await _firestore.collection('users').doc(userId).collection('resumes').get();
      return resumesRef.docs.map((e) => ResumeModel.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResumeModel> getResume(String userId, String resumeId) async {
    try {
      final resumeRef = _firestore.collection('users').doc(userId).collection('resumes').doc(resumeId);
      final resume = await resumeRef.get();
      return ResumeModel.fromJson(resume.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveResume(String userId, Resume resume) async {
    try {
      final resumesRef = _firestore.collection('users').doc(userId).collection('resumes');
      final resumeModel = ResumeModel.fromDomain(resume);
      resumesRef.doc(resume.id).set(resumeModel.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteResume(String userId, Resume resume) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('users').doc(userId).collection('resumes').doc(resume.id);
        final thumbnailRef = _storage.ref().child('images/$userId/${resume.id}/thumbnail');
        await thumbnailRef.delete();
        transaction.delete(docRef);

        if (resume.photo != null) {
          final profilePictureRef = _storage.ref().child('images/$userId/${resume.id}/profile_picture');
          await profilePictureRef.delete();
        }
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> savePicture(String userId, String resumeId, File file) async {
    try {
      final ref = _storage.ref().child('images/$userId/$resumeId/profile_picture');
      final storageRef = await ref.putFile(file);
      final url = await storageRef.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveThumbnail(String userId, String resumeId, File file) async {
    try {
      final ref = _storage.ref().child('images/$userId/$resumeId/thumbnail');
      final storageRef = await ref.putFile(file);
      final url = await storageRef.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permissão negada para acessar os dados do usuário.');
      }
      rethrow;
    } catch (e) {
      rethrow;
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
