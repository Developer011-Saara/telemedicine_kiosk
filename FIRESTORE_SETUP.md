# Firebase Firestore Setup for TeleMedicine Kiosk

## Overview
This document explains how to set up Firebase Firestore for the TeleMedicine Kiosk application to replace the mock data with real-time database integration.

## Firestore Collection Structure

### Collection: `doctors`

Each document in the `doctors` collection should have the following structure:

```json
{
  "name": "Dr. Sarah Johnson",
  "specialty": "Cardiologist", 
  "isOnline": true,
  "status": "Available Now",
  "responseTime": "Avg response time: 2-3 minutes"
}
```

#### Field Descriptions:
- `name` (string): Doctor's full name
- `specialty` (string): Medical specialty (e.g., "Cardiologist", "General Practitioner", "Pediatrician")
- `isOnline` (boolean): Whether the doctor is currently available for consultations
- `status` (string): Current status message (e.g., "Available Now", "In consultation", "Offline")
- `responseTime` (string): Expected response time or availability information

## Sample Data

Here are some sample doctor documents you can add to your Firestore collection:

### Document 1:
```json
{
  "name": "Dr. Sarah Johnson",
  "specialty": "Cardiologist",
  "isOnline": true,
  "status": "Available Now",
  "responseTime": "Avg response time: 2-3 minutes"
}
```

### Document 2:
```json
{
  "name": "Dr. Michael Chen", 
  "specialty": "General Practitioner",
  "isOnline": false,
  "status": "In consultation",
  "responseTime": "Available in ~15 minutes"
}
```

### Document 3:
```json
{
  "name": "Dr. Emily Rodriguez",
  "specialty": "Pediatrician", 
  "isOnline": false,
  "status": "Offline",
  "responseTime": "Returns tomorrow at 9:00 AM"
}
```

## Firebase Configuration

1. **Firebase Project Setup**: Ensure your Firebase project is properly configured
2. **google-services.json**: Make sure the `google-services.json` file is in the correct location (`android/app/`)
3. **Firestore Rules**: Set up appropriate security rules for the `doctors` collection

### Example Firestore Security Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to doctors collection
    match /doctors/{document} {
      allow read: if true;
      allow write: if request.auth != null; // Only authenticated users can write
    }
  }
}
```

## Testing the Integration

1. **Add Sample Data**: Use the Firebase Console to add the sample doctor documents
2. **Test Real-time Updates**: 
   - Change the `isOnline` field of a doctor document
   - Observe the app updating in real-time
3. **Test Error Handling**: 
   - Temporarily disable internet connection
   - Observe error states and retry functionality

## Features Implemented

✅ **Real-time Doctor Status**: The app now listens to Firestore changes in real-time
✅ **Error Handling**: Graceful handling of connection errors and empty states  
✅ **Loading States**: Proper loading indicators while data is being fetched
✅ **Retry Functionality**: Users can retry failed requests
✅ **Responsive UI**: The interface adapts to different data states

## Next Steps

1. Set up your Firebase project and add the sample data
2. Test the real-time functionality
3. Customize the doctor data according to your needs
4. Consider adding more fields like doctor photos, consultation fees, etc.
