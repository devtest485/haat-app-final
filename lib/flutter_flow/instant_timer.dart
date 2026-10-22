import 'dart:async';

class InstantTimer implements Timer {
  factory InstantTimer.periodic({
    required Duration duration,
    required void Function(Timer timer) callback,
    bool startImmediately = true,
  }) {
    final myTimer = Timer.periodic(duration, callback);
    if (startImmediately) {
      Future.delayed(const Duration(seconds: 0), () => callback(myTimer));
    }
    return InstantTimer._(myTimer, startImmediately);
  }

  InstantTimer._(this._timer, this._startImmediately);
  final Timer _timer;
  final bool _startImmediately;

  @override
  void cancel() {
    _timer.cancel();
  }

  @override
  bool get isActive {
    return _timer.isActive;
  }

  @override
  int get tick {
    final t = _timer.tick;
    if (_startImmediately) {
      return t + 1;
    }
    return t;
  }
}
