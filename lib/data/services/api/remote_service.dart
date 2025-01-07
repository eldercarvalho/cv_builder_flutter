import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv_builder/data/models/resume.dart';
import 'package:cv_builder/domain/models/resume.dart';

class RemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
