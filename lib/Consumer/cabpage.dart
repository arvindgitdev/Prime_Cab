import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primecabs/Consumer/booking_page.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cabs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var drivers = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['isAvailable'] == true;
          }).toList();

          if (drivers.isEmpty) {
            return const Center(child: Text('No available cabs at the moment.'));
          }

          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              var driver = drivers[index];
              var data = driver.data() as Map<String, dynamic>;

              // Handle missing 'isAvailable' field
              bool isAvailable = data.containsKey('isAvailable') ? data['isAvailable'] : false;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    data['name'] ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Car No: ${data['carNo'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Text(
                    isAvailable ? 'Available' : 'Not Available',
                    style: TextStyle(
                      color: isAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: isAvailable ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(driverId: driver.id),
                      ),
                    );
                  } : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
