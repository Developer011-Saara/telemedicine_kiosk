import 'package:flutter/material.dart';
import 'services/mock_backend.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool doctorOnline = MockBackendService.instance.currentOnline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TeleMed Kiosk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.person, size: 28),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Doctor Status',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: doctorOnline
                                ? const Color(0xFF2ECC71)
                                : const Color(0xFFE74C3C),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Green = online, Red = offline',
                      style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 12),
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: () {
                    final next = !doctorOnline;
                    MockBackendService.instance.setDoctorOnline(next);
                    setState(() => doctorOnline = next);
                  },
                  tooltip: 'Toggle status (demo)',
                )
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/booking');
              },
              icon: const Icon(Icons.calendar_month, size: 28),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('Book Appointment', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/status');
              },
              icon: const Icon(Icons.medical_information, size: 28),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('Doctor Status', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Choose an action to continue. You can check doctor availability or book an appointment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF7F8C8D)),
            )
          ],
        ),
      ),
    );
  }
}
