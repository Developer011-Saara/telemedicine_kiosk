import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/mock_backend.dart';

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
  DateTime _preferredDateTime = DateTime.now().add(const Duration(minutes: 30));

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

    await MockBackendService.instance.saveBooking(
      name: _nameController.text.trim(),
      type: _appointmentType,
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
    required this.dateTime,
  });

  final String name;
  final String appointmentType;
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
            '${widget.name} • ${widget.appointmentType}\n${widget.dateTime.toLocal().toString().substring(0, 16)}',
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
