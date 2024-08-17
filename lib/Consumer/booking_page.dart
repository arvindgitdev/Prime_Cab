import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String driverId;

  BookingPage({required this.driverId});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? rideId;

  Future<void> bookCab(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Fetch user details from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userSnapshot.exists) {
          throw Exception("User not found in Firestore.");
        }

        String userName = userSnapshot['name'] ?? 'Unknown';
        String userPhone = userSnapshot['phone'] ?? 'Unknown';

        // Create a ride request with user details
        DocumentReference rideRef = await FirebaseFirestore.instance.collection('rides').add({
          'driverId': widget.driverId,
          'customerId': user.uid,
          'customerName': userName,
          'customerPhone': userPhone,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          rideId = rideRef.id; // Store the ride ID
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ride request created successfully! Ride ID: $rideId'),
        ));

        // Listen for updates on the ride status
        rideRef.snapshots().listen((rideSnapshot) {
          if (rideSnapshot.exists && rideSnapshot['status'] == 'accepted') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Ride Accepted by Driver!'),
            ));
          }
        });
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to book cab: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No user is currently signed in.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Cab'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                bookCab(context);
              },
              child: Text('Book Now'),
            ),
            if (rideId != null) // Show ride ID if available
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Your Ride ID: $rideId',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
