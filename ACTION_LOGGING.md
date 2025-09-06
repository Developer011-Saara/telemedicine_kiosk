# Action Logging System

## Overview
The TeleMedicine Kiosk app includes a comprehensive action logging system that tracks user interactions and system events. All logs are stored in Firebase Firestore for analysis and monitoring.

## 🔥 Firebase Collection Structure

### Collection: `logs`

Each log entry contains the following structure:

```json
{
  "action": "user_login",
  "details": {
    "username": "Telemed",
    "loginMethod": "static_credentials"
  },
  "timestamp": "2024-01-15T10:30:00.000Z",
  "deviceInfo": {
    "platform": "android",
    "appVersion": "1.0.0"
  }
}
```

## 📊 Logged Actions

### 1. Authentication Actions
- **`user_login`** - Successful user login
- **`login_failed`** - Failed login attempts (with error details)

### 2. Navigation Actions
- **`navigation`** - Screen navigation events
  - `booking_screen` - User navigated to booking
  - `status_screen` - User navigated to doctor status

### 3. Appointment Actions
- **`appointment_booking`** - Complete appointment booking
  - Patient name, appointment type, doctor details, appointment time
- **`doctor_selection`** - Doctor selection in booking form

### 4. System Actions
- **`doctor_status_check`** - Doctor status screen access
- **`kiosk_action`** - Kiosk-specific actions
- **`error`** - System errors and exceptions
- **`form_validation_error`** - Form validation failures

## 🛠 Implementation

### ActionLogger Service
Located in `lib/services/action_logger.dart`, this singleton service provides methods for logging different types of actions:

```dart
// Basic action logging
await ActionLogger().logActionToFirestore('custom_action', {
  'key': 'value',
  'details': 'more info'
});

// Specific action methods
await ActionLogger().logLogin('username');
await ActionLogger().logAppointmentBooking(...);
await ActionLogger().logNavigation('screen_name');
await ActionLogger().logError('error_type', 'message');
```

### Integration Points

#### Login Screen (`lib/loginpage.dart`)
- Logs successful logins
- Logs failed login attempts with context

#### Booking Screen (`lib/booking_screen.dart`)
- Logs doctor selections
- Logs appointment bookings with full details

#### Home Screen (`lib/home_screen.dart`)
- Logs navigation to booking and status screens

#### Status Screen (`lib/status_screen.dart`)
- Logs doctor status checks

## 📈 Analytics and Monitoring

### Firestore Queries for Analysis

#### User Activity Summary
```javascript
// Get all user logins in the last 24 hours
db.collection('logs')
  .where('action', '==', 'user_login')
  .where('timestamp', '>=', new Date(Date.now() - 24*60*60*1000))
  .orderBy('timestamp', 'desc')
  .get()
```

#### Appointment Analytics
```javascript
// Get appointment bookings by type
db.collection('logs')
  .where('action', '==', 'appointment_booking')
  .get()
  .then(snapshot => {
    const appointments = snapshot.docs.map(doc => doc.data());
    // Analyze appointment types, doctors, times, etc.
  })
```

#### Error Monitoring
```javascript
// Get all errors in the last week
db.collection('logs')
  .where('action', '==', 'error')
  .where('timestamp', '>=', new Date(Date.now() - 7*24*60*60*1000))
  .orderBy('timestamp', 'desc')
  .get()
```

### Dashboard Metrics
- **Daily Active Users** - Count of unique logins per day
- **Appointment Volume** - Number of bookings per day/week
- **Popular Doctors** - Most selected doctors
- **Error Rate** - Percentage of error logs vs total logs
- **Screen Usage** - Most visited screens

## 🔒 Privacy and Security

### Data Protection
- No sensitive patient data is logged (only appointment metadata)
- Passwords are never logged (only masked indicators)
- All logs include timestamps for audit trails

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access to logs collection
    match /logs/{document} {
      allow read, write: if true; // Adjust based on your security needs
    }
  }
}
```

## 🚀 Future Enhancements

### Planned Features
- **Real-time Dashboard** - Live monitoring of kiosk usage
- **Alert System** - Notifications for errors or unusual activity
- **Export Functionality** - CSV/JSON export of logs
- **Advanced Analytics** - Machine learning insights
- **Performance Metrics** - App performance tracking

### Additional Log Types
- **Session Duration** - How long users spend on each screen
- **Touch Events** - Detailed interaction tracking
- **Performance Metrics** - App load times, response times
- **Device Information** - Hardware specs, OS version

## 📋 Usage Examples

### Basic Logging
```dart
// Log a custom action
await ActionLogger().logActionToFirestore('button_click', {
  'buttonName': 'refresh_status',
  'screenName': 'home_screen'
});
```

### Error Logging
```dart
// Log an error with context
await ActionLogger().logError('firebase_connection', 'Failed to connect to Firestore', 
  context: {
    'retryCount': 3,
    'lastSuccessfulConnection': '2024-01-15T10:00:00Z'
  }
);
```

### Kiosk Action Logging
```dart
// Log kiosk-specific actions
await ActionLogger().logKioskAction('screen_timeout', {
  'idleTime': '5 minutes',
  'lastActivity': 'button_click'
});
```

## 🔧 Configuration

### Environment Variables
Set up different logging levels for different environments:

```dart
// Development - Log everything
const bool enableDetailedLogging = true;

// Production - Log only important events
const bool enableDetailedLogging = false;
```

### Log Retention
Consider implementing log retention policies:
- Keep detailed logs for 30 days
- Keep summary logs for 1 year
- Archive old logs to cloud storage

---

**Note**: This logging system provides comprehensive insights into kiosk usage patterns, user behavior, and system performance, enabling data-driven improvements to the telemedicine experience.
