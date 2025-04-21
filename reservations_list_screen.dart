import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../models/booking_model.dart';
import 'booking_details_screen.dart';

class ReservationsListScreen extends StatelessWidget {
  const ReservationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reservations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseService.instance.getAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No reservations yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final timeparts = (booking['reservationTime'] as String).split(
                ':',
              );
              final bookingModel = BookingModel(
                name: booking['name'] as String,
                address: booking['address'] as String,
                phoneNo: booking['phoneNo'] as String,
                email: booking['email'] as String,
                reservationDate: DateTime.parse(
                  booking['reservationDate'] as String,
                ),
                reservationTime: TimeOfDay(
                  hour: int.parse(timeparts[0]),
                  minute: int.parse(timeparts[1]),
                ),
                durationHours: booking['durationHours'] as int,
                additionalRequests: booking['additionalRequests'] as String,
                numberOfGuests: booking['numberOfGuests'] as int,
              );

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      bookingModel.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    bookingModel.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${DateFormat('dd/MM/yyyy').format(bookingModel.reservationDate)} at ${bookingModel.reservationTime.format(context)}\n${bookingModel.numberOfGuests} guests • ${bookingModel.durationHours} hours',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                BookingDetailsScreen(booking: bookingModel),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
