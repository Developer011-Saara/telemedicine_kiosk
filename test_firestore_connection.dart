import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Test script to verify Firestore connection and data structure
/// Run this with: dart test_firestore_connection.dart
Future<void> main() async {
  print('🔥 Initializing Firebase...');
  await Firebase.initializeApp();

  print('📡 Testing Firestore connection...');

  try {
    // Test reading from the doctors collection
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('doctors').get();

    print('✅ Successfully connected to Firestore!');
    print('📊 Found ${snapshot.docs.length} doctor documents');

    if (snapshot.docs.isEmpty) {
      print('⚠️  No doctors found in the collection.');
      print(
          '💡 Add some sample data using the Firebase Console or the sample data from FIRESTORE_SETUP.md');
    } else {
      print('\n📋 Doctor Data:');
      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final data = doc.data() as Map<String, dynamic>;
        print(
            '  ${i + 1}. ${data['name'] ?? 'Unknown'} - ${data['specialty'] ?? 'N/A'} (${data['isOnline'] == true ? 'Online' : 'Offline'})');
      }
    }

    // Test real-time listener
    print('\n🔄 Testing real-time listener...');
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection('doctors').snapshots();

    // Listen for 5 seconds to test real-time updates
    final subscription = stream.listen(
      (QuerySnapshot snapshot) {
        print('📡 Real-time update received: ${snapshot.docs.length} doctors');
      },
      onError: (error) {
        print('❌ Real-time listener error: $error');
      },
    );

    // Wait for 5 seconds to test the listener
    await Future.delayed(const Duration(seconds: 5));
    await subscription.cancel();

    print('✅ Real-time listener test completed');
    print('\n🎉 Firestore integration test successful!');
    print('💡 Your app should now display real-time doctor data.');
  } catch (e) {
    print('❌ Error connecting to Firestore: $e');
    print('\n🔧 Troubleshooting:');
    print('1. Make sure your Firebase project is set up correctly');
    print('2. Verify google-services.json is in android/app/');
    print('3. Check your Firestore security rules');
    print('4. Ensure you have internet connectivity');
  }
}
