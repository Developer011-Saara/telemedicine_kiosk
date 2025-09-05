import 'dart:async';

class MockBackendService {
  MockBackendService._internal();
  static final MockBackendService instance = MockBackendService._internal();

  final StreamController<bool> _doctorOnlineController =
      StreamController<bool>.broadcast();
  bool _currentOnline = true;

  Stream<bool> get doctorOnlineStream => _doctorOnlineController.stream;
  bool get currentOnline => _currentOnline;

  void startDemoToggler({Duration interval = const Duration(seconds: 8)}) {
    // Idempotent: if already has listeners, just emit current
    _doctorOnlineController.add(_currentOnline);
    _demoTimer ??= Timer.periodic(interval, (_) {
      setDoctorOnline(!_currentOnline);
    });
  }

  Timer? _demoTimer;

  void setDoctorOnline(bool online) {
    _currentOnline = online;
    _doctorOnlineController.add(_currentOnline);
  }

  Future<void> saveBooking(
      {required String name,
      required String type,
      required DateTime at}) async {
    // Simulate latency
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // No-op persistence (could be expanded to local storage)
  }

  void dispose() {
    _demoTimer?.cancel();
    _doctorOnlineController.close();
  }
}
