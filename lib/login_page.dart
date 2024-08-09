import 'package:flutter/material.dart';
import 'package:primecabs/login_screen.dart';

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPhone(),
                      )
                  );

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
                      "Continue With PrimeCabs",
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward,color: Colors.white,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
