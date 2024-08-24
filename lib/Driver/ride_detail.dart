import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RideDetailsPage extends StatefulWidget {
  final String rideId;

  const RideDetailsPage({super.key, required this.rideId});

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  late Future<Map<String, dynamic>> rideDetailsFuture;
  Timer? _cancelTimer;
  Timer? _startRideTimer;

  @override
  void initState() {
    super.initState();
    rideDetailsFuture = fetchRideDetails();
  }

  Future<Map<String, dynamic>> fetchRideDetails() async {
    try {
      DocumentSnapshot rideSnapshot = await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .get();

      if (rideSnapshot.exists) {
        return rideSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Ride not found");
      }
    } catch (e) {
      print('Error fetching ride details: $e');
      rethrow;
    }
  }

  void _startCancelTimer() {
    _cancelTimer = Timer(const Duration(minutes: 10), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('rides')
              .doc(widget.rideId)
              .update({
            'status': 'cancelled',
          });

          await FirebaseFirestore.instance
              .collection('drivers')
              .doc(user.uid)
              .update({'isAvailable': true});

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ride automatically cancelled due to inactivity.'),
          ));
          Navigator.pop(context); // Return to the previous page
        } catch (e) {
          print('Error cancelling ride: $e');
        }
      }
    });
  }

  void startRideTimer() {
    _startRideTimer = Timer(const Duration(minutes: 10), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('rides')
              .doc(widget.rideId)
              .update({
            'status': 'cancelled',
          });

          await FirebaseFirestore.instance
              .collection('drivers')
              .doc(user.uid)
              .update({'isAvailable': true});

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ride automatically cancelled due to inactivity.'),
          ));
          Navigator.pop(context); // Return to the previous page
        } catch (e) {
          print('Error cancelling ride: $e');
        }
      }
    });
  }

  void completeRide(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('rides')
            .doc(widget.rideId)
            .update({
          'status': 'completed',
          'completed': true,
        });

        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(user.uid)
            .update({'isAvailable': true});

        _cancelTimer?.cancel();
        _startRideTimer?.cancel();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ride marked as completed.'),
        ));
        Navigator.pop(context); // Return to the previous page
      } catch (e) {
        print('Error completing ride: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to complete ride: $e'),
        ));
      }
    }
  }

  void startRide(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('rides')
            .doc(widget.rideId)
            .update({
          'status': 'started',
        });

        _startRideTimer?.cancel(); // Cancel the start ride timer if already started

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ride started.'),
        ));
        setState(() {}); // Refresh UI to show the "Mark as Completed" button
      } catch (e) {
        print('Error starting ride: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to start ride: $e'),
        ));
      }
    }
  }

  void acceptRide(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('rides')
            .doc(widget.rideId)
            .update({
          'status': 'accepted',
        });

        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(user.uid)
            .update({'isAvailable': false});

        _startCancelTimer(); // Start the timer for ride cancellation if not started

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ride accepted.'),
        ));
        Navigator.pop(context); // Return to the previous page
      } catch (e) {
        print('Error accepting ride: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to accept ride: $e'),
        ));
      }
    }
  }

  void cancelRide(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('rides')
            .doc(widget.rideId)
            .update({
          'status': 'cancelled',
        });

        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(user.uid)
            .update({'isAvailable': true});

        _cancelTimer?.cancel();
        _startRideTimer?.cancel();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ride cancelled.'),
        ));
        Navigator.pop(context); // Return to the previous page
      } catch (e) {
        print('Error cancelling ride: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to cancel ride: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: rideDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final rideDetails = snapshot.data!;
          final status = rideDetails['status'] ?? 'unknown';
          final customerName = rideDetails['customerName'] ?? 'Unknown';
          final customerPhone = rideDetails['customerPhone'] ?? 'Unknown';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride Details',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text('Customer Name: $customerName'),
                Text('Customer Phone: $customerPhone'),
                Text('Status: $status'),
                const SizedBox(height: 24),
                if (status == 'pending') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          acceptRide(context);
                        },
                        child: const Text('Accept Ride'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cancelRide(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red color for cancel button
                        ),
                        child: const Text('Cancel Ride'),
                      ),
                    ],
                  ),
                ] else if (status == 'accepted') ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        startRide(context);
                      },
                      child: const Text('Start Ride'),
                    ),
                  ),
                ] else if (status == 'started') ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        completeRide(context);
                      },
                      child: const Text('Mark as Completed'),
                    ),
                  ),
                ] else if (status == 'cancelled') ...[
                  const Center(
                    child: Text(
                      'This ride is cancelled.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ]
                else ...[
                  const Center(
                    child: Text(
                      'This ride is already completed.',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
