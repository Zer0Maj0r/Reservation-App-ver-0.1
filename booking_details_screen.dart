import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Name', booking.name),
                const Divider(),
                _buildDetailRow('Address', booking.address),
                const Divider(),
                _buildDetailRow('Phone', booking.phoneNo),
                const Divider(),
                _buildDetailRow('Email', booking.email),
                const Divider(),
                _buildDetailRow(
                  'Date',
                  DateFormat('dd/MM/yyyy').format(booking.reservationDate),
                ),
                const Divider(),
                _buildDetailRow(
                  'Time',
                  booking.reservationTime.format(context),
                ),
                const Divider(),
                _buildDetailRow('Duration', '${booking.durationHours} hours'),
                const Divider(),
                _buildDetailRow(
                  'Number of Guests',
                  booking.numberOfGuests.toString(),
                ),
                if (booking.additionalRequests.isNotEmpty) ...[
                  const Divider(),
                  _buildDetailRow(
                    'Additional Requests',
                    booking.additionalRequests,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
