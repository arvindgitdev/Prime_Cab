import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:primecabs/Driver/accept_page.dart';
import 'package:primecabs/Driver/ride_detail.dart';

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isAvailable = false;
  int notificationCount = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _getAvailabilityStatus();
    _initializeNotifications();
    _listenForRideRequests();
  }

  void _initializeNotifications() {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ride_channel_id',
      'Ride Notifications',
      channelDescription: 'Notifications for new ride requests',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'ride_notification',
    );
  }

  void _getAvailabilityStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .get();

      setState(() {
        isAvailable = driverSnapshot['isAvailable'] ?? false;
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

  void _listenForRideRequests() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('rides')
          .where('driverId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            notificationCount = snapshot.docs.length;
          });

          _showNotification(
            'New Ride Request',
            'You have received a new ride request.',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Home'),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RideRequestsPage()),
                  );
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Available'),
            value: isAvailable,
            onChanged: (value) {
              setState(() {
                isAvailable = value;
              });
              toggleAvailability();
            },
          ),
          SizedBox(height: 20),
          Text(
            'Ride History',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rides')
                  .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No ride history available.'));
                }

                var rides = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    var ride = rides[index].data() as Map<String, dynamic>;

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
