# TeleMedicine Kiosk App

A comprehensive Flutter-based telemedicine kiosk application designed for healthcare facilities. The app provides a complete patient journey from splash screen to appointment booking with real-time doctor status monitoring.

## Demo Credentials

For testing and demonstration purposes, use these credentials to access the app:

- **Username**: `Telemed`
- **Password**: `Telemed@1234`

> **Note**: These credentials are displayed on the login screen for easy reference during testing.

## Features

### Core Functionality
- **Splash Screen** - Animated loading with fade transition to login
- **Secure Authentication** - Static login with credentials validation
- **Kiosk Mode** - Native Android lock task mode for dedicated kiosk use
- **Real-time Status** - Live doctor availability monitoring via Firebase Firestore
- **Smart Appointment Booking** - Complete booking flow with doctor selection
- **Firebase Integration** - Real-time data synchronization and updates
- **Action Logging** - Comprehensive user interaction tracking and analytics
- **Auto-launch** - Boots automatically after device restart

### User Interface
- **Healthcare-themed Design** - Medical color palette and friendly UI
- **Touch-friendly** - Large buttons and clear navigation for kiosk use
- **Responsive Layout** - Adapts to different screen sizes
- **Accessibility** - Clear typography and intuitive flow

## App Flow

### 1. Splash Screen
- Displays kiosk branding image
- Shows loading spinner
- Auto-transitions to login after 5 seconds with fade animation

### 2. Authentication
- **Username**: `Telemed`
- **Password**: `Telemed@1234`
- Static validation with error handling
- Demo credentials displayed on screen

### 3. Home Dashboard
- **Real-time Doctor Status** - Live status indicator (green/red dot) from Firebase
- **Dynamic Status Updates** - Automatically updates when doctors come online/offline
- Two main action buttons:
  - **Book Appointment** - Navigate to smart booking form with doctor selection
  - **Doctor Status** - View complete healthcare team availability
- **Refresh Functionality** - Manual refresh button for status updates

### 4. Smart Appointment Booking
- **Form Fields**:
  - Name (pre-filled as "Guest")
  - Appointment type dropdown (General, Follow-up, Prescription)
  - **Doctor Selection** - Real-time dropdown showing only online doctors
  - Preferred date/time picker
- **Doctor Selection Features**:
  - Shows doctor name and specialty
  - Only displays doctors currently online
  - Real-time updates when doctor status changes
  - Form validation requires doctor selection
- **Confirmation**:
  - Haptic feedback on booking
  - Animated confirmation dialog with selected doctor
  - Success animation with checkmark

### 5. Real-time Doctor Status Screen
- **Live Healthcare Team View**:
  - Real-time data from Firebase Firestore
  - Dynamic doctor availability updates
  - Professional doctor cards with status indicators
- **Visual Indicators**:
  - Green highlight for available doctors
  - Status dots and response times
  - Offline warning notifications
- **Real-time Features**:
  - Automatic updates when doctor status changes
  - Loading states and error handling
  - Retry functionality for connection issues

## Technical Architecture

### Flutter Structure
```
lib/
├── main.dart                 # App entry point with routing
├── splash_screen.dart        # Animated splash with transition
├── loginpage.dart           # Authentication screen
├── home_screen.dart         # Main dashboard
├── booking_screen.dart      # Appointment booking form
├── status_screen.dart       # Doctor availability view
└── services/
    ├── native_bridge.dart   # Android kiosk mode integration
    └── action_logger.dart   # Firebase logging service
```

### Android Integration
- **Kiosk Mode**: Native lock task implementation
- **Boot Receiver**: Auto-launch after device restart
- **Platform Channels**: Flutter ↔ Android communication
- **Permissions**: BOOT_COMPLETED for auto-start

### Dependencies
- `flutter` - Core framework
- `cupertino_icons` - iOS-style icons
- `firebase_core` - Firebase core functionality
- `cloud_firestore` - Real-time database integration
- `google_fonts` - Typography (commented out for compatibility)

## Setup & Installation

### Prerequisites
- Flutter SDK (3.5.4+)
- Android Studio
- Android device/emulator
- Firebase project with Firestore enabled

### Installation Steps
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd telemedicine_kiosk
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Set up Firebase project
   - Enable Firestore database
   - Add `google-services.json` to `android/app/`
   - Deploy Firestore security rules (`firestore.rules`)
   - Add sample doctor data (see `FIRESTORE_SETUP.md`)

4. **Run the application**
   ```bash
   flutter run
   ```

### Android Configuration
- **Min SDK**: 23 (Android 6.0+)
- **Kotlin Version**: 2.1.0
- **Gradle**: 8.1.0

## Kiosk Mode Setup

### For Production Deployment
1. **Set as Device Owner** (required for full kiosk mode)
2. **Enable Developer Mode** on Windows for symlinks
3. **Configure Auto-launch** via BootReceiver

### Testing
- App automatically enables kiosk mode on startup
- Use device back button to exit (if not in full kiosk mode)

## Design System

### Color Palette
- **Primary**: `#2E7D8A` (Medical teal)
- **Success**: `#4CAF50` (Available status)
- **Warning**: `#FFB74D` (Offline alerts)
- **Background**: `#F8FBFF` (Light healthcare blue)

### Typography
- **Headers**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Captions**: Light, 12px

## Firebase Integration

### Current Implementation
- ✅ **Real-time Doctor Status** - Live updates from Firestore
- ✅ **Smart Doctor Selection** - Only shows online doctors in booking
- ✅ **Dynamic Status Updates** - Automatic UI updates when data changes
- ✅ **Error Handling** - Graceful handling of connection issues
- ✅ **Loading States** - Proper loading indicators and retry functionality

### Data Structure
- **Collection**: `doctors`
- **Fields**: `name`, `specialty`, `isOnline`, `status`, `responseTime`
- **Real-time**: StreamBuilder for live updates
- **Filtering**: Only online doctors shown in booking

### Action Logging System
- **Collection**: `logs`
- **Tracked Actions**: User logins, navigation, appointments, doctor selections, errors
- **Analytics**: Complete user interaction tracking for insights
- **Privacy**: No sensitive data logged, secure timestamp tracking
- **Fallback**: Console logging if Firestore unavailable

## Future Enhancements

### Planned Features
- **User Management** - Patient profiles and history
- **Video Consultation** - Direct doctor-patient calls
- **Prescription Management** - Digital prescription handling
- **Multi-language Support** - Internationalization
- **Push Notifications** - Appointment reminders and updates

### Advanced Backend Integration
- User authentication with Firebase Auth
- Appointment scheduling with Cloud Functions
- Real-time chat integration
- File upload for medical documents

## Recent Updates

### v2.0 - Action Logging & Analytics
- ✅ **Comprehensive Logging System** - Track all user interactions
- ✅ **Firebase Analytics Integration** - Real-time usage monitoring
- ✅ **Error Tracking** - Automatic error logging and reporting
- ✅ **Security Rules** - Proper Firestore permissions configuration
- ✅ **Navigation Safety** - Fixed null check operator errors

### v1.5 - Firebase Integration
- ✅ **Real-time Doctor Status** - Live Firestore integration
- ✅ **Smart Doctor Selection** - Dynamic dropdown with online doctors
- ✅ **Mock Data Removal** - Clean codebase without hardcoded data

## Known Issues

- Java version warnings (non-critical, safe to ignore)
- Some Android system warnings (harmless, related to device compatibility)
- Appointment persistence uses local storage (Firebase integration for doctor data only)

## Documentation

### Firebase Setup
- **FIRESTORE_SETUP.md** - Complete Firebase configuration guide
- **VERIFICATION_CHECKLIST.md** - Step-by-step testing checklist
- **ACTION_LOGGING.md** - Comprehensive logging system documentation
- **firestore.rules** - Security rules for Firestore collections
- **Sample Data** - Pre-configured doctor data structure

### Quick Start
1. Follow the Firebase setup guide
2. Deploy Firestore security rules
3. Add sample doctor data to Firestore
4. Test real-time functionality and logging
5. Customize doctor information

### Troubleshooting

#### Firestore Permission Denied
If you see "PERMISSION_DENIED" errors in logs:
1. Go to Firebase Console → Firestore Database → Rules
2. Deploy the provided `firestore.rules` file
3. Ensure rules allow read/write access to `logs` collection

#### Navigation Errors
- Fixed null check operator errors in navigation
- App now safely handles context disposal during async operations

## License

This project is available for educational and demonstration purposes.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support

For technical support or questions:
- Create an issue in the repository
- Contact manishpatil0311@gmail.com
- Check the documentation for troubleshooting

---

**Built with ❤️ for healthcare innovation**