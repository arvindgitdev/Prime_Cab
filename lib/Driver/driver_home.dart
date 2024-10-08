import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:PrimeServices/Driver/ride_detail.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    _getAvailabilityStatus();
  }

  void _getAvailabilityStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .get();

      setState(() {
        isAvailable = driverSnapshot['isAvailable'] ?? false; // Provide default value if null
      });
    }
  }

  void toggleAvailability() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .update({'isAvailable': isAvailable});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home'),
        centerTitle: false,
       /* actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RideRequestsPage()), // Navigate to NotificationsPage
              );
            },
          ),
        ],*/
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Available'),
            value: isAvailable,
            onChanged: (value) {
              setState(() {
                isAvailable = value;
              });
              toggleAvailability();
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Ride History',
            style: TextStyle( fontSize: 20),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rides')
                  .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No ride history available.'));
                }

                var rides = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    var ride = rides[index].data() as Map<String, dynamic>;

                    // Safely access ride data with default values
                    final customerName = ride['customerName'] ?? 'Unknown';
                    String status = ride['status'] ?? 'Unknown';
                    bool completed = ride['completed'] ?? false;

                    return ListTile(
                      title: Text('Customer: $customerName'),
                      subtitle: Text('Status: $status'),
                      trailing: Text('Completed: ${completed ? 'Yes' : 'No'}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RideDetailsPage(
                              rideId: rides[index].id,
                            ),
                          ),
                        );
                      },
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
