import 'package:PrimeServices/Driver/driver_nav.dart';
import 'package:flutter/material.dart';
import 'package:PrimeServices/Consumer/navigation.dart';
import 'package:PrimeServices/food_vendor/v_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define the animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Start the animation
    _controller.forward();

    // Display the splash screen for a moment before navigating
    Future.delayed(const Duration(seconds: 2), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString('userType');  // Retrieve the stored user type

    if (userType == 'Driver') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DriverHome()),  // Navigate to Driver home screen
      );
    } else if (userType == 'Consumer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),  // Navigate to Consumer home screen
      );
    } else if (userType == 'Food Vendor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VendorHome()),  // Navigate to Food Vendor home screen
      );
    } else {
      // If no user type is stored, navigate to the Login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const Text(
            'PrimeServices',
            style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
