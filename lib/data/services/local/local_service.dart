import 'dart:convert';

import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String guestId = 'guestId';

class LocalService {
  Future<void> clear() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
  }

  Future<void> saveGuestId(String id) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(guestId, id);
  }

  Future<String?> getGuestId() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(guestId);
  }

  AsyncResult<void> saveResume(Map<String, dynamic> resume) async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('resume', jsonEncode(resume));
      return const Success('OK');
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<Map<String, dynamic>> getResume(String id) async {
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      final result = sharedPrefs.getString('resume');
      return Success(jsonDecode(result!));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
