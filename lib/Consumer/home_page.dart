import 'package:flutter/material.dart';
import 'package:primecabs/Consumer/login_screen.dart';
import 'package:primecabs/Consumer/profile%20_page.dart';
 // Import your ProfilePage
import 'package:primecabs/provider/auth_provider.dart' as customAuthProvider;

class Booking extends StatelessWidget {
const Booking({super.key});

Future<void> _signOut(BuildContext context) async {
final authProvider = customAuthProvider.AuthProvider();
await authProvider.signOut();
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => const MyPhone()), // Navigate to the login page
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Booking"),
backgroundColor: Colors.grey,
elevation: 0,
toolbarHeight: 100,
actions: [
IconButton(
icon: const Icon(Icons.logout),
onPressed: () => _signOut(context),
),
],
),
body: content(context),
);
}

Widget content(BuildContext context) {
return Center(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 40),
locationInputField("From?", false),
const SizedBox(height: 20),
locationInputField("To?", false),
const SizedBox(height: 30),
const Text(
"History",
style: TextStyle(fontSize: 25),
),
/* Uncomment and update as needed
          const SizedBox(height: 10),
          locationInputField("No XX,XXXXX", true),
          SizedBox(height: 20),
          locationInputField("XXX Mall", true),
          SizedBox(height: 20),
          locationInputField("Garden XXX", true),
          SizedBox(height: 20),
          locationInputField("Texas Road XXX", true),
          SizedBox(height: 50),
          */
const SizedBox(height: 20),
GestureDetector(
child: Container(
height: 60,
width: 350,
decoration: BoxDecoration(
color: Colors.black,
borderRadius: BorderRadius.circular(20),
),
child: const Center(
child: Text(
"Confirm booking",
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
),
),
),
const SizedBox(height: 20),
TextButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder: (context) => const ProfilePage()), // Navigate to ProfilePage
);
},
child: const Text(
'Go to Profile',
style: TextStyle(
color: Colors.blue,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),
],
),
);
}
}

Widget locationInputField(String title, bool isHistory) {
return Container(
height: 60,
width: 350,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.5),
spreadRadius: 5,
blurRadius: 7,
offset: const Offset(0, 3),
)
],
),
child: Align(
alignment: Alignment.centerLeft,
child: Padding(
padding: const EdgeInsets.only(left: 20.0),
child: Row(
children: [
isHistory
? const Icon(
Icons.location_on,
color: Colors.green,
)
    : Icon(
Icons.location_searching_outlined,
color: title.contains('From') ? Colors.grey : Colors.blue,
),
const SizedBox(width: 20),
Text(
title,
style: TextStyle(
fontWeight: isHistory ? FontWeight.normal : FontWeight.bold,
fontSize: 20,
),
),
],
),
),
),
);
}
