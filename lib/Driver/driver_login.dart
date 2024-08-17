import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primecabs/Driver/driver_reg.dart';
import 'package:primecabs/Driver/driver_home.dart'; // Import the Driver Home Page

class DLoginPage extends StatefulWidget {
  @override
  _DLoginPageState createState() => _DLoginPageState();
}

class _DLoginPageState extends State<DLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void loginDriver() async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      User? user = userCredential.user;

      if (user != null) {
        // Dismiss the loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Successful!'),
        ));

        // Navigate to the Driver Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverHomePage()), // Replace with your actual home page
        );
      }
    } catch (e) {
      // Dismiss the loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Failed. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 50),
              _header(context),
              const SizedBox(height: 50),
              _inputField(context),
              const SizedBox(height: 60),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 70),
          Text(
            'Prime Services',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
          obscureText: _obscureText,
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
            child: const Text(
              "Forgot password?",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: loginDriver,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.black,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 20),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DriverRegistrationPage(),
              ),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
