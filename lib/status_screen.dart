import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/action_logger.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    super.initState();
    // Log doctor status check when screen loads
    ActionLogger().logDoctorStatusCheck();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    // Responsive dimensions
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final titleFontSize = isKiosk ? 32.0 : (isTablet ? 28.0 : 24.0);
    final iconSize = isKiosk ? 28.0 : (isTablet ? 24.0 : 20.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Healthcare Team',
          style: TextStyle(fontSize: isKiosk ? 22.0 : 20.0),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: isKiosk ? 28.0 : 24.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              children: [
                Text(
                  'Doctor Availability',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(
                  Icons.notifications_active_outlined,
                  size: iconSize,
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildFirestoreDoctorsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFirestoreDoctorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
      builder: (context, snapshot) {
        final screenSize = MediaQuery.of(context).size;
        final screenWidth = screenSize.width;
        final screenHeight = screenSize.height;
        final isTablet = screenWidth > 600;
        final isKiosk = screenWidth > 1024;

        final iconSize = isKiosk ? 80.0 : (isTablet ? 72.0 : 64.0);
        final fontSize = isKiosk ? 20.0 : (isTablet ? 18.0 : 16.0);
        final buttonHeight = isKiosk ? 56.0 : (isTablet ? 52.0 : 48.0);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: isKiosk ? 4.0 : 3.0,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: iconSize,
                  color: Colors.red,
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Error loading doctors: ${snapshot.error}',
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(isKiosk ? 16.0 : 12.0),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: iconSize,
                  color: Colors.grey,
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'No doctors available at the moment',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        final doctors = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Doctor.fromFirestore(data);
        }).toList();

        final hasOfflineDoctors = doctors.any((d) => !d.isAvailable);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return _DoctorCard(doctor: doctor);
                },
              ),
            ),
            if (hasOfflineDoctors)
              Container(
                margin: EdgeInsets.all(screenWidth * 0.05),
                padding:
                    EdgeInsets.all(isKiosk ? 16.0 : (isTablet ? 14.0 : 12.0)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E6),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                  borderRadius: BorderRadius.circular(isKiosk ? 12.0 : 8.0),
                ),
                child: Text(
                  'Some doctors are currently offline. Don\'t worry! They\'ll be back online shortly.',
                  style: TextStyle(
                    color: const Color(0xFF805A00),
                    fontSize: isKiosk ? 16.0 : (isTablet ? 15.0 : 14.0),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final bool isAvailable;
  final String status;
  final String responseTime;

  Doctor({
    required this.name,
    required this.specialty,
    required this.isAvailable,
    required this.status,
    required this.responseTime,
  });

  factory Doctor.fromFirestore(Map<String, dynamic> data) {
    final isOnline = data['isOnline'] ?? false;
    final status = data['status'] ?? (isOnline ? 'Available Now' : 'Offline');
    final responseTime = data['responseTime'] ??
        (isOnline
            ? 'Avg response time: 2-3 minutes'
            : 'Returns tomorrow at 9:00 AM');

    return Doctor(
      name: data['name'] ?? 'Unknown Doctor',
      specialty: data['specialty'] ?? 'General Practitioner',
      isAvailable: isOnline,
      status: status,
      responseTime: responseTime,
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    final Color cardColor =
        doctor.isAvailable ? const Color(0xFFE8F5E8) : Colors.white;
    final Color borderColor =
        doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0);
    final Color statusColor =
        doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFF757575);

    final avatarRadius = isKiosk ? 40.0 : (isTablet ? 35.0 : 30.0);
    final cardPadding = isKiosk ? 20.0 : (isTablet ? 18.0 : 16.0);
    final borderRadius = isKiosk ? 16.0 : 12.0;
    final nameFontSize = isKiosk ? 20.0 : (isTablet ? 18.0 : 16.0);
    final specialtyFontSize = isKiosk ? 18.0 : (isTablet ? 16.0 : 14.0);
    final statusFontSize = isKiosk ? 18.0 : (isTablet ? 16.0 : 14.0);
    final responseFontSize = isKiosk ? 16.0 : (isTablet ? 14.0 : 12.0);
    final statusDotSize = isKiosk ? 10.0 : 8.0;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: const Color(0xFF2E7D8A),
            child: Text(
              doctor.name.split(' ').map((n) => n[0]).join(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isKiosk ? 20.0 : (isTablet ? 18.0 : 16.0),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: specialtyFontSize,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Container(
                      width: statusDotSize,
                      height: statusDotSize,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      doctor.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: statusFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  doctor.responseTime,
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: responseFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
