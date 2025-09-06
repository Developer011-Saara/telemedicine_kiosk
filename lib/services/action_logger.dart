import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for logging user actions to Firebase Firestore
class ActionLogger {
  static final ActionLogger _instance = ActionLogger._internal();
  factory ActionLogger() => _instance;
  ActionLogger._internal();

  /// Log a user action to Firestore
  Future<void> logActionToFirestore(
      String action, Map<String, dynamic> details) async {
    try {
      await FirebaseFirestore.instance.collection('logs').add({
        'action': action,
        'details': details,
        'timestamp': FieldValue.serverTimestamp(),
        'deviceInfo': {
          'platform': 'android',
          'appVersion': '1.0.0',
        },
      });
    } catch (e) {
      // Fallback to console logging if Firestore fails
      print('Failed to log action to Firestore: $e');
      print('Action: $action, Details: $details');
    }
  }

  /// Log user login action
  Future<void> logLogin(String username) async {
    await logActionToFirestore('user_login', {
      'username': username,
      'loginMethod': 'static_credentials',
    });
  }

  /// Log appointment booking action
  Future<void> logAppointmentBooking({
    required String patientName,
    required String appointmentType,
    required String doctorId,
    required String doctorName,
    required DateTime appointmentTime,
  }) async {
    await logActionToFirestore('appointment_booking', {
      'patientName': patientName,
      'appointmentType': appointmentType,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'appointmentTime': appointmentTime.toIso8601String(),
    });
  }

  /// Log doctor status check action
  Future<void> logDoctorStatusCheck() async {
    await logActionToFirestore('doctor_status_check', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log navigation action
  Future<void> logNavigation(String screenName) async {
    await logActionToFirestore('navigation', {
      'screenName': screenName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log error action
  Future<void> logError(String errorType, String errorMessage,
      {Map<String, dynamic>? context}) async {
    await logActionToFirestore('error', {
      'errorType': errorType,
      'errorMessage': errorMessage,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log kiosk mode actions
  Future<void> logKioskAction(String action,
      {Map<String, dynamic>? details}) async {
    await logActionToFirestore('kiosk_action', {
      'action': action,
      'details': details ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log doctor selection action
  Future<void> logDoctorSelection(String doctorId, String doctorName) async {
    await logActionToFirestore('doctor_selection', {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log form validation errors
  Future<void> logFormValidationError(
      String formName, String fieldName, String errorMessage) async {
    await logActionToFirestore('form_validation_error', {
      'formName': formName,
      'fieldName': fieldName,
      'errorMessage': errorMessage,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
