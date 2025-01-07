import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

typedef CommandAction0<T extends Object> = Future<Result<T>> Function();
typedef CommandAction1<T extends Object, A> = Future<Result<T>> Function(A);
typedef CommandAction2<T extends Object, A, B> = Future<Result<T>> Function(A, B);
typedef CommandAction3<T extends Object, A, B, C> = Future<Result<T>> Function(A, B, C);

abstract class Command<T extends Object> extends ChangeNotifier {
  Command();

  bool _running = false;

  bool get running => _running;

  Result<T>? _result;

  bool get error => _result is Failure;

  bool get completed => _result is Success;

  Result? get result => _result;

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> _execute(CommandAction0<T> action) async {
    if (_running) return;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

class Command0<T extends Object> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  Future<void> execute() async {
    await _execute(() => _action());
  }
}

class Command1<T extends Object, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}

class Command2<T extends Object, A, B> extends Command<T> {
  Command2(this._action);

  final CommandAction2<T, A, B> _action;

  Future<void> execute(A arg1, B arg2) async {
    await _execute(() => _action(arg1, arg2));
  }
}
