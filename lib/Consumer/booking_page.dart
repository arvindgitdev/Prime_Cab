import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String driverId;

  const BookingPage({super.key, required this.driverId});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? rideId;
  Map<String, dynamic>? driverDetails;

  @override
  void initState() {
    super.initState();
    _fetchDriverDetails();
  }

  Future<void> _fetchDriverDetails() async {
    try {
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(widget.driverId)
          .get();

      if (!driverSnapshot.exists) {
        throw Exception("Driver not found in Firestore.");
      }

      setState(() {
        driverDetails = driverSnapshot.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch driver details: $e'),
      ));
    }
  }

  Future<void> bookCab(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userSnapshot.exists) {
          throw Exception("User not found in Firestore.");
        }

        String userName = userSnapshot['name'] ?? 'Unknown';
        String userPhone = userSnapshot['phone'] ?? 'Unknown';

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

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ride request created successfully! Ride ID: $rideId'),
        ));

        rideRef.snapshots().listen((rideSnapshot) {
          if (rideSnapshot.exists && rideSnapshot['status'] == 'accepted') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Ride Accepted by Driver!'),
            ));
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to book cab: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No user is currently signed in.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Cab'),
      ),
      body: Center(
        child: driverDetails == null
            ? const CircularProgressIndicator() // Show loading indicator while fetching
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Driver Photo
              CircleAvatar(
                radius: 50,
                backgroundImage: driverDetails?['driverImageUrl'] != null && driverDetails!['driverImageUrl'].isNotEmpty
                    ? NetworkImage(driverDetails!['driverImageUrl'])
                    : null,
                child: driverDetails?['driverImageUrl'] == null || driverDetails!['driverImageUrl'].isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 20),
              // Driver Details
              const Text(
                'Driver Details:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Name: ${driverDetails?['name'] ?? 'N/A'}', style: const TextStyle(fontSize: 20)),
              Text('Phone: ${driverDetails?['phone'] ?? 'N/A'}', style: const TextStyle(fontSize: 20)),
              Text('Email: ${driverDetails?['email']?.toString() ?? 'N/A'}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              // Car Details
              const Text(
                'Car Details:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Car No.: ${driverDetails?['carNo'] ?? 'N/A'}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              // Car Photo
              if (driverDetails?['carImageUrl'] != null && driverDetails!['carImageUrl'].isNotEmpty)
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(driverDetails!['carImageUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                const Icon(Icons.directions_car, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              // Book Now Button
              ElevatedButton(
                onPressed: () {
                  bookCab(context);
                },
                child: const Text('Book Now', style: TextStyle(fontSize: 18)),
              ),
              if (rideId != null) // Show ride ID if available
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Your Ride ID: $rideId',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
