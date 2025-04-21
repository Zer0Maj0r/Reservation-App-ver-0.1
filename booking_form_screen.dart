import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../services/database_service.dart';
import 'booking_details_screen.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _additionalRequestsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _durationHours = 3;
  int _numberOfGuests = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _additionalRequestsController.dispose();
    super.dispose();
  }

  void _showBookingDetails() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final booking = BookingModel(
      name: _nameController.text,
      address: _addressController.text,
      phoneNo: _phoneController.text,
      email: _emailController.text,
      reservationDate: _selectedDate!,
      reservationTime: _selectedTime!,
      durationHours: _durationHours,
      additionalRequests: _additionalRequestsController.text,
      numberOfGuests: _numberOfGuests,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Booking Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Name: ${booking.name}'),
                  Text('Address: ${booking.address}'),
                  Text('Phone: ${booking.phoneNo}'),
                  Text('Email: ${booking.email}'),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy').format(booking.reservationDate)}',
                  ),
                  Text('Time: ${booking.reservationTime.format(context)}'),
                  Text('Duration: ${booking.durationHours} hours'),
                  Text('Guests: ${booking.numberOfGuests}'),
                  Text('Additional Requests: ${booking.additionalRequests}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await DatabaseService.instance.createBooking(booking);
                    if (mounted) {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  BookingDetailsScreen(booking: booking),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving booking: $e')),
                      );
                    }
                  }
                },
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Booking')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Reservation Date'),
              subtitle: Text(
                _selectedDate == null
                    ? 'Select date'
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 90)),
                  onConfirm: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Reservation Time'),
              subtitle: Text(
                _selectedTime == null
                    ? 'Select time'
                    : _selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () {
                DatePicker.showTimePicker(
                  context,
                  onConfirm: (time) {
                    setState(() {
                      _selectedTime = TimeOfDay.fromDateTime(time);
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _durationHours,
              decoration: const InputDecoration(
                labelText: 'Duration',
                border: OutlineInputBorder(),
              ),
              items:
                  [3, 4, 5].map((hours) {
                    return DropdownMenuItem<int>(
                      value: hours,
                      child: Text('$hours hours'),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _durationHours = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _additionalRequestsController,
              decoration: const InputDecoration(
                labelText: 'Additional Requests',
                hintText: 'e.g., Birthday Celebration, Special Decoration',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Number of Guests: '),
                IconButton(
                  onPressed: () {
                    if (_numberOfGuests > 1) {
                      setState(() {
                        _numberOfGuests--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('$_numberOfGuests'),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _numberOfGuests++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _showBookingDetails,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Review Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
