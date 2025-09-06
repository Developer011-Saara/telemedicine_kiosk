import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/action_logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool doctorOnline = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    // Responsive dimensions
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.02; // 2% of screen height
    final buttonHeight = isKiosk ? 64.0 : (isTablet ? 60.0 : 56.0);
    final iconSize = isKiosk ? 32.0 : (isTablet ? 30.0 : 28.0);
    final fontSize = isKiosk ? 20.0 : (isTablet ? 18.0 : 16.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TeleMed Kiosk',
          style: TextStyle(fontSize: isKiosk ? 24.0 : 20.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // Check if any doctor is online
                  final hasOnlineDoctor = snapshot.data!.docs.any((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['isOnline'] == true;
                  });
                  doctorOnline = hasOnlineDoctor;
                }

                return Row(
                  children: [
                    CircleAvatar(
                      radius: isKiosk ? 36.0 : (isTablet ? 32.0 : 28.0),
                      child: Icon(Icons.person, size: iconSize),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Doctor Status',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: isKiosk ? 12.0 : 10.0,
                                height: isKiosk ? 12.0 : 10.0,
                                decoration: BoxDecoration(
                                  color: doctorOnline
                                      ? const Color(0xFF2ECC71)
                                      : const Color(0xFFE74C3C),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            doctorOnline
                                ? 'Doctors are available'
                                : 'No doctors online',
                            style: TextStyle(
                              color: const Color(0xFF7F8C8D),
                              fontSize:
                                  isKiosk ? 16.0 : (isTablet ? 14.0 : 12.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: isKiosk ? 28.0 : 24.0,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                      tooltip: 'Refresh status',
                    )
                  ],
                );
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ActionLogger().logNavigation('booking_screen');
                  Navigator.of(context).pushNamed('/booking');
                },
                icon: Icon(Icons.calendar_month, size: iconSize),
                label: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isKiosk ? 16.0 : 12.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ActionLogger().logNavigation('status_screen');
                  Navigator.of(context).pushNamed('/status');
                },
                icon: Icon(Icons.medical_information, size: iconSize),
                label: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: Text(
                    'Doctor Status',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isKiosk ? 16.0 : 12.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'Choose an action to continue. You can check doctor availability or book an appointment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF7F8C8D),
                fontSize: isKiosk ? 16.0 : (isTablet ? 14.0 : 12.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
