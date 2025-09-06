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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthcare Team'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Doctor Availability',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.notifications_active_outlined, size: 20),
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading doctors: ${snapshot.error}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No doctors available at the moment',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return _DoctorCard(doctor: doctor);
                },
              ),
            ),
            if (hasOfflineDoctors)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E6),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Some doctors are currently offline. Don\'t worry! They\'ll be back online shortly.',
                  style: TextStyle(
                    color: Color(0xFF805A00),
                    fontSize: 14,
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
    final Color cardColor =
        doctor.isAvailable ? const Color(0xFFE8F5E8) : Colors.white;
    final Color borderColor =
        doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0);
    final Color statusColor =
        doctor.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFF757575);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF2E7D8A),
            child: Text(
              doctor.name.split(' ').map((n) => n[0]).join(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.responseTime,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
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
