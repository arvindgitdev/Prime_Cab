import 'package:flutter/material.dart';
import 'package:primecabs/Consumer/login_screen.dart';
import 'package:primecabs/Driver/driver_login.dart';
import 'package:primecabs/food_vendor/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/images/taxi-booking.png",
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.7), // Adjust this to move the button
              child: ElevatedButton(
                onPressed: () {
                  _showUserTypeDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Continue With PrimeServices",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserTypeDialog(BuildContext context) {
    String? selectedUserType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select User Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Driver"),
                value: "Driver",
                groupValue: selectedUserType,
                onChanged: (String? value) {
                  selectedUserType = value;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  DLoginPage(),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: const Text("Consumer"),
                value: "Consumer",
                groupValue: selectedUserType,
                onChanged: (String? value) {
                  selectedUserType = value;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPhone(),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: const Text("Food Vendor"),
                value: "Food Vendor",
                groupValue: selectedUserType,
                onChanged: (String? value) {
                  selectedUserType = value;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Phone(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
