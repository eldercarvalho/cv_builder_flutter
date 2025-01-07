import 'package:cv_builder/data/services/api/remote_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/services/local/local_service.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({required LocalService localService, required RemoteService remoteService})
      : _localService = localService,
        _remoteService = remoteService;

  late final LocalService _localService;
  late final RemoteService _remoteService;
  final _log = Logger('SplashViewModel');

  Future<void> generateGuestId() async {
    try {
      final id = const Uuid().v4();

      _log.fine('Generated guest id: $id');
      final guestId = await _localService.getGuestId();

      if (guestId != null) {
        await Future.delayed(const Duration(seconds: 2));
        return;
      }

      await _localService.saveGuestId(id);
      await _remoteService.saveGuestUser(id);
    } catch (e) {
      _log.severe('Error generating guest id', e);
    }
  }
}
