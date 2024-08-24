import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primecabs/Driver/driver_home.dart';

class DriverRegistrationPage extends StatefulWidget {
  const DriverRegistrationPage({super.key});

  @override
  _DriverRegistrationPageState createState() => _DriverRegistrationPageState();
}

class _DriverRegistrationPageState extends State<DriverRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _carNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  File? _driverImage;
  File? _carImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDriverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _driverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCarImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _carImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Upload images to Firebase Storage
      String driverImageUrl = '';
      String carImageUrl = '';

      if (_driverImage != null) {
        driverImageUrl = await _uploadImage(_driverImage!, 'drivers');
      }

      if (_carImage != null) {
        carImageUrl = await _uploadImage(_carImage!, 'cars');
      }

      // Save driver details to Firestore
      await FirebaseFirestore.instance.collection('drivers').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneNoController.text.trim(),
        'carNo': _carNoController.text.trim(),
        'driverImageUrl': driverImageUrl,
        'carImageUrl': carImageUrl,
      });

      Navigator.of(context).pop(); // Close the loading dialog
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Driver successfully registered!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DriverHomePage()), // Replace with your actual home page
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.message}')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during registration')),
      );
    }
  }


  Future<String> _uploadImage(File image, String folder) async {
    final storageRef = FirebaseStorage.instance.ref().child('$folder/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'PrimeServices',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Let\'s Create your Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _pickDriverImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _driverImage != null ? FileImage(_driverImage!) : null,
                  child: _driverImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: Text('Upload Driver Image')),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: _phoneNoController,
                decoration: const InputDecoration(
                  labelText: 'Phone No.',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: _carNoController,
                decoration: const InputDecoration(
                  labelText: 'Car No.',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const UnderlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    )
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _pickCarImage,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _carImage == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : Image.file(_carImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: Text('Upload Car Image')),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _registerDriver,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


