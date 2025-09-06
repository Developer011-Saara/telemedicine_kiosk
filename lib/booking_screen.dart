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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    // Responsive dimensions
    final maxWidth = isKiosk ? 800.0 : (isTablet ? 600.0 : 520.0);
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final cardPadding = isKiosk ? 24.0 : (isTablet ? 20.0 : 16.0);
    final borderRadius = isKiosk ? 16.0 : 12.0;
    final titleFontSize = isKiosk ? 24.0 : (isTablet ? 20.0 : 18.0);
    final buttonHeight = isKiosk ? 64.0 : (isTablet ? 60.0 : 56.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyle(fontSize: isKiosk ? 22.0 : 20.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle:
                              TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(borderRadius)),
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            size: isKiosk ? 24.0 : 20.0,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isKiosk ? 20.0 : 16.0,
                            vertical: isKiosk ? 18.0 : 14.0,
                          ),
                        ),
                        style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Please enter a name'
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      DropdownButtonFormField<String>(
                        value: _appointmentType,
                        decoration: InputDecoration(
                          labelText: 'Appointment Type',
                          labelStyle:
                              TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(borderRadius)),
                          ),
                          prefixIcon: Icon(
                            Icons.category_outlined,
                            size: isKiosk ? 24.0 : 20.0,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isKiosk ? 20.0 : 16.0,
                            vertical: isKiosk ? 18.0 : 14.0,
                          ),
                        ),
                        style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                        items: [
                          DropdownMenuItem(
                            value: 'General',
                            child: Text(
                              'General',
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Follow-up',
                            child: Text(
                              'Follow-up',
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Prescription',
                            child: Text(
                              'Prescription',
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                            ),
                          ),
                        ],
                        onChanged: (val) =>
                            setState(() => _appointmentType = val ?? 'General'),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('doctors')
                            .where('isOnline', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Doctor',
                                labelStyle:
                                    TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(borderRadius)),
                                ),
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  size: isKiosk ? 24.0 : 20.0,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isKiosk ? 20.0 : 16.0,
                                  vertical: isKiosk ? 18.0 : 14.0,
                                ),
                              ),
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              items: const [],
                              hint: Text(
                                'Loading doctors...',
                                style:
                                    TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              ),
                              onChanged: (value) {},
                            );
                          }

                          if (snapshot.hasError) {
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Doctor',
                                labelStyle:
                                    TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(borderRadius)),
                                ),
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  size: isKiosk ? 24.0 : 20.0,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isKiosk ? 20.0 : 16.0,
                                  vertical: isKiosk ? 18.0 : 14.0,
                                ),
                              ),
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              items: const [],
                              hint: Text(
                                'Error loading doctors',
                                style:
                                    TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              ),
                              onChanged: (value) {},
                            );
                          }

                          final onlineDoctors = snapshot.data?.docs ?? [];

                          if (onlineDoctors.isEmpty) {
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Doctor',
                                labelStyle:
                                    TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(borderRadius)),
                                ),
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  size: isKiosk ? 24.0 : 20.0,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isKiosk ? 20.0 : 16.0,
                                  vertical: isKiosk ? 18.0 : 14.0,
                                ),
                              ),
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              items: const [],
                              hint: Text(
                                'No doctors available',
                                style:
                                    TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              ),
                              onChanged: (value) {},
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: onlineDoctors
                                    .any((doc) => doc.id == _selectedDoctorId)
                                ? _selectedDoctorId
                                : null,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Select Doctor',
                              labelStyle:
                                  TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(borderRadius)),
                              ),
                              prefixIcon: Icon(
                                Icons.medical_services_outlined,
                                size: isKiosk ? 24.0 : 20.0,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isKiosk ? 20.0 : 16.0,
                                vertical: isKiosk ? 18.0 : 14.0,
                              ),
                            ),
                            style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
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
                                    Icon(
                                      Icons.medical_services,
                                      size: isKiosk ? 22.0 : 18.0,
                                      color: const Color(0xFF2E7D8A),
                                    ),
                                    SizedBox(width: isKiosk ? 12.0 : 8.0),
                                    Expanded(
                                      child: Text(
                                        '$doctorName - $specialty',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: isKiosk ? 18.0 : 14.0,
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
                      SizedBox(height: screenHeight * 0.015),
                      SizedBox(
                        height: buttonHeight,
                        child: OutlinedButton.icon(
                          onPressed: _pickDateTime,
                          icon: Icon(
                            Icons.schedule,
                            size: isKiosk ? 28.0 : 24.0,
                          ),
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015),
                            child: Text(
                              'Preferred Time: ${_preferredDateTime.toLocal().toString().substring(0, 16)}',
                              style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        height: buttonHeight,
                        child: ElevatedButton.icon(
                          onPressed: _confirmBooking,
                          icon: Icon(
                            Icons.check_circle_outline,
                            size: isKiosk ? 30.0 : 26.0,
                          ),
                          label: Text(
                            'Confirm Booking',
                            style: TextStyle(fontSize: isKiosk ? 20.0 : 18.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                          ),
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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isKiosk = screenWidth > 1024;

    final padding = isKiosk ? 32.0 : (isTablet ? 28.0 : 24.0);
    final avatarRadius = isKiosk ? 48.0 : (isTablet ? 42.0 : 36.0);
    final iconSize = isKiosk ? 48.0 : (isTablet ? 42.0 : 36.0);
    final titleFontSize = isKiosk ? 24.0 : (isTablet ? 20.0 : 18.0);
    final textFontSize = isKiosk ? 18.0 : (isTablet ? 16.0 : 14.0);
    final buttonHeight = isKiosk ? 56.0 : (isTablet ? 52.0 : 48.0);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale:
                CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: const Color(0xFF2ECC71),
              child: Icon(Icons.check, color: Colors.white, size: iconSize),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            'Booking Confirmed',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            '${widget.name} • ${widget.appointmentType}\nDoctor: ${widget.doctorName}\n${widget.dateTime.toLocal().toString().substring(0, 16)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF7F8C8D),
              fontSize: textFontSize,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isKiosk ? 16.0 : 12.0),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: isKiosk ? 18.0 : 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
