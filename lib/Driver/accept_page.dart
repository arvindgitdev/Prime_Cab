import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:PrimeServices/Driver/ride_detail.dart';
 // Import the RideDetailsPage

class RideRequestsPage extends StatelessWidget {
  const RideRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rides')
            .where('driverId', isEqualTo: user?.uid)
            .where('status', isEqualTo: 'pending') // Only show pending requests
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No ride requests available.'));
          }

          final rides = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              final rideId = ride.id;
              final customerName = ride['customerName'] ?? 'Unknown';
              final status = ride['status'] ?? 'unknown';
              final timestamp = ride['timestamp']?.toDate();
              final formattedTime = timestamp != null ? '${timestamp.hour}:${timestamp.minute}' : 'Unknown';

              return ListTile(
                title: Text('Ride ID: $rideId'),
                subtitle: Text('Customer: $customerName\nStatus: $status\nRequested at: $formattedTime'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('rides')
                        .doc(rideId)
                        .update({'status': 'accepted'});

                    await FirebaseFirestore.instance
                        .collection('drivers')
                        .doc(user!.uid)
                        .update({'isAvailable': false});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideDetailsPage(rideId: rideId), // Navigate to RideDetailsPage
                      ),
                    );
                  },
                  child: const Text('Accept'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
