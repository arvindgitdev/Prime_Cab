import 'package:flutter/material.dart';
import 'package:primecabs/Consumer/login_screen.dart';
import 'package:primecabs/Driver/driver_login.dart';

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
              alignment: Alignment(0.0, 0.7), // Adjust this to move the button
              child: ElevatedButton(
                onPressed: () {
                  _showUserTypeDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: Row(
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
    String? _selectedUserType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select User Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text("Driver"),
                value: "Driver",
                groupValue: _selectedUserType,
                onChanged: (String? value) {
                  _selectedUserType = value;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegScreen(),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: Text("Consumer"),
                value: "Consumer",
                groupValue: _selectedUserType,
                onChanged: (String? value) {
                  _selectedUserType = value;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPhone(),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: Text("Food Vendor"),
                value: "Food Vendor",
                groupValue: _selectedUserType,
                onChanged: (String? value) {
                  _selectedUserType = value;
                  Navigator.pop(context);
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPhone(),
                    ),
                  );*/
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
