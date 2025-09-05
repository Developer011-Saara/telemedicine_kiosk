# TeleMedicine Kiosk App

A comprehensive Flutter-based telemedicine kiosk application designed for healthcare facilities. The app provides a complete patient journey from splash screen to appointment booking with real-time doctor status monitoring.

## 🏥 Features

### Core Functionality
- **Splash Screen** - Animated loading with fade transition to login
- **Secure Authentication** - Static login with credentials validation
- **Kiosk Mode** - Native Android lock task mode for dedicated kiosk use
- **Real-time Status** - Live doctor availability monitoring
- **Appointment Booking** - Complete booking flow with confirmation
- **Auto-launch** - Boots automatically after device restart

### User Interface
- **Healthcare-themed Design** - Medical color palette and friendly UI
- **Touch-friendly** - Large buttons and clear navigation for kiosk use
- **Responsive Layout** - Adapts to different screen sizes
- **Accessibility** - Clear typography and intuitive flow

## 🚀 App Flow

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
- Doctor status indicator (green/red dot)
- Two main action buttons:
  - **Book Appointment** - Navigate to booking form
  - **Doctor Status** - View healthcare team availability
- Real-time status toggle functionality

### 4. Appointment Booking
- **Form Fields**:
  - Name (pre-filled as "Guest")
  - Appointment type dropdown (General, Follow-up, Prescription)
  - Preferred date/time picker
- **Confirmation**:
  - Haptic feedback on booking
  - Animated confirmation dialog
  - Success animation with checkmark

### 5. Doctor Status Screen
- **Healthcare Team View**:
  - Dr. Sarah Johnson (Cardiologist) - Available Now
  - Dr. Michael Chen (General Practitioner) - In consultation
  - Dr. Emily Rodriguez (Pediatrician) - Offline
- **Visual Indicators**:
  - Green highlight for available doctors
  - Status dots and response times
  - Offline warning notifications

## 🛠 Technical Architecture

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
    └── mock_backend.dart    # Backend service simulation
```

### Android Integration
- **Kiosk Mode**: Native lock task implementation
- **Boot Receiver**: Auto-launch after device restart
- **Platform Channels**: Flutter ↔ Android communication
- **Permissions**: BOOT_COMPLETED for auto-start

### Dependencies
- `flutter` - Core framework
- `cupertino_icons` - iOS-style icons
- `google_fonts` - Typography (commented out for compatibility)

## 🔧 Setup & Installation

### Prerequisites
- Flutter SDK (3.5.4+)
- Android Studio
- Android device/emulator

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

3. **Run the application**
   ```bash
   flutter run
   ```

### Android Configuration
- **Min SDK**: 23 (Android 6.0+)
- **Kotlin Version**: 2.1.0
- **Gradle**: 8.1.0

## 📱 Kiosk Mode Setup

### For Production Deployment
1. **Set as Device Owner** (required for full kiosk mode)
2. **Enable Developer Mode** on Windows for symlinks
3. **Configure Auto-launch** via BootReceiver

### Testing
- App automatically enables kiosk mode on startup
- Use device back button to exit (if not in full kiosk mode)

## 🎨 Design System

### Color Palette
- **Primary**: `#2E7D8A` (Medical teal)
- **Success**: `#4CAF50` (Available status)
- **Warning**: `#FFB74D` (Offline alerts)
- **Background**: `#F8FBFF` (Light healthcare blue)

### Typography
- **Headers**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Captions**: Light, 12px

## 🔄 Future Enhancements

### Planned Features
- **Firebase Integration** - Real-time doctor status updates
- **User Management** - Patient profiles and history
- **Video Consultation** - Direct doctor-patient calls
- **Prescription Management** - Digital prescription handling
- **Multi-language Support** - Internationalization

### Backend Integration
- Replace mock backend with Firebase Firestore
- Real-time status updates via WebSocket
- User authentication with Firebase Auth
- Appointment scheduling with Cloud Functions

## 🐛 Known Issues

- Firebase integration temporarily disabled due to JDK compatibility
- Some layout overflow warnings on smaller screens
- Mock backend for demonstration purposes

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For technical support or questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation for troubleshooting

---

**Built with ❤️ for healthcare innovation**