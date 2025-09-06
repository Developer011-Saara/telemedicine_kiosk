import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/action_logger.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: 'Guest');
  String _appointmentType = 'General';
  String? _selectedDoctorId;
  String? _selectedDoctorName;
  DateTime _preferredDateTime = DateTime.now().add(const Duration(minutes: 30));

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveBookingLocally({
    required String name,
    required String type,
    required String doctorId,
    required String doctorName,
    required DateTime at,
  }) async {
    // Simulate latency
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Log booking action to Firestore
    await ActionLogger().logAppointmentBooking(
      patientName: name,
      appointmentType: type,
      doctorId: doctorId,
      doctorName: doctorName,
      appointmentTime: at,
    );

    // Log booking details (could be extended to save to Firebase or local storage)
    print('Booking saved: $name - $type - $doctorName - ${at.toString()}');

    // TODO: Implement Firebase booking collection
    // await FirebaseFirestore.instance.collection('appointments').add({
    //   'name': name,
    //   'type': type,
    //   'doctorId': doctorId,
    //   'doctorName': doctorName,
    //   'appointmentTime': at,
    //   'createdAt': FieldValue.serverTimestamp(),
    // });
  }

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 0));
    final DateTime lastDate = now.add(const Duration(days: 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _preferredDateTime,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_preferredDateTime),
    );
    if (pickedTime == null) return;

    setState(() {
      _preferredDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();

    // Save booking locally (could be extended to save to Firebase)
    await _saveBookingLocally(
      name: _nameController.text.trim(),
      type: _appointmentType,
      doctorId: _selectedDoctorId ?? 'Unknown',
      doctorName: _selectedDoctorName ?? 'Unknown Doctor',
      at: _preferredDateTime,
    );
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _BookingConfirmation(
          name: _nameController.text.trim(),
          appointmentType: _appointmentType,
          doctorName: _selectedDoctorName ?? 'Not selected',
          dateTime: _preferredDateTime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Appointment Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Please enter a name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _appointmentType,
                        decoration: const InputDecoration(
                          labelText: 'Appointment Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'General', child: Text('General')),
                          DropdownMenuItem(
                              value: 'Follow-up', child: Text('Follow-up')),
                          DropdownMenuItem(
                              value: 'Prescription',
                              child: Text('Prescription')),
                        ],
                        onChanged: (val) =>
                            setState(() => _appointmentType = val ?? 'General'),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('doctors')
                            .where('isOnline', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Doctor',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                prefixIcon:
                                    Icon(Icons.medical_services_outlined),
                              ),
                              items: const [],
                              hint: const Text('Loading doctors...'),
                              onChanged: (value) {},
                            );
                          }

                          if (snapshot.hasError) {
                            return DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Doctor',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                prefixIcon:
                                    Icon(Icons.medical_services_outlined),
                              ),
                              items: const [],
                              hint: const Text('Error loading doctors'),
                              onChanged: (value) {},
                            );
                          }

                          final onlineDoctors = snapshot.data?.docs ?? [];

                          if (onlineDoctors.isEmpty) {
                            return DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Doctor',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                prefixIcon:
                                    Icon(Icons.medical_services_outlined),
                              ),
                              items: const [],
                              hint: const Text('No doctors available'),
                              onChanged: (value) {},
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: onlineDoctors
                                    .any((doc) => doc.id == _selectedDoctorId)
                                ? _selectedDoctorId
                                : null,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Select Doctor',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              prefixIcon: Icon(Icons.medical_services_outlined),
                            ),
                            items: onlineDoctors.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final doctorId = doc.id;
                              final doctorName =
                                  data['name'] ?? 'Unknown Doctor';
                              final specialty =
                                  data['specialty'] ?? 'General Practitioner';

                              return DropdownMenuItem<String>(
                                value: doctorId,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.medical_services,
                                      size: 18,
                                      color: Color(0xFF2E7D8A),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '$doctorName - $specialty',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (doctorId) async {
                              if (doctorId != null) {
                                final doctorDoc = onlineDoctors.firstWhere(
                                  (doc) => doc.id == doctorId,
                                );
                                final data =
                                    doctorDoc.data() as Map<String, dynamic>;
                                final doctorName =
                                    data['name'] ?? 'Unknown Doctor';

                                // Log doctor selection
                                await ActionLogger()
                                    .logDoctorSelection(doctorId, doctorName);

                                setState(() {
                                  _selectedDoctorId = doctorId;
                                  _selectedDoctorName = doctorName;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a doctor';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _pickDateTime,
                        icon: const Icon(Icons.schedule),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'Preferred Time: ${_preferredDateTime.toLocal().toString().substring(0, 16)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _confirmBooking,
                          icon:
                              const Icon(Icons.check_circle_outline, size: 26),
                          label: const Text('Confirm Booking',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingConfirmation extends StatefulWidget {
  const _BookingConfirmation({
    required this.name,
    required this.appointmentType,
    required this.doctorName,
    required this.dateTime,
  });

  final String name;
  final String appointmentType;
  final String doctorName;
  final DateTime dateTime;

  @override
  State<_BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<_BookingConfirmation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600))
    ..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale:
                CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
            child: const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFF2ECC71),
              child: Icon(Icons.check, color: Colors.white, size: 36),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Booking Confirmed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            '${widget.name} • ${widget.appointmentType}\nDoctor: ${widget.doctorName}\n${widget.dateTime.toLocal().toString().substring(0, 16)}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF7F8C8D)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          )
        ],
      ),
    );
  }
}
