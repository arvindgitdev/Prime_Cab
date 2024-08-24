import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:primecabs/Consumer/navigation.dart'; // Ensure this import is correct

class UserInfoPage extends StatefulWidget {
  final User? user;
  final String? phone;

  const UserInfoPage({super.key, this.user, this.phone});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _profilePicture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      emailController.text = widget.user!.email ?? '';
      phoneController.text = widget.phone ?? ''; // Initialize with passed phone number

      // Load profile picture from Firebase Storage or URL
      _loadProfilePicture();
    }
  }

  Future<void> _loadProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final profilePictureUrl = data?['profile_picture'] as String?;
        if (profilePictureUrl != null) {
          setState(() {
            // Fetch image from network
            _profilePicture = null;
            // Use network image to display profile picture
          });
        }
      }
    }
  }

  Future<void> _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String? profilePictureUrl;

        if (_profilePicture != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_pictures')
              .child('${user.uid}.jpg');
          await storageRef.putFile(_profilePicture!);
          profilePictureUrl = await storageRef.getDownloadURL();
        } else if (widget.user?.photoURL != null) {
          // Use existing photoURL if no new picture is selected
          profilePictureUrl = widget.user!.photoURL;
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'profile_picture': profilePictureUrl,
        }, SetOptions(merge: true));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : (widget.user?.photoURL != null
                    ? NetworkImage(widget.user!.photoURL!)
                    : null),
                child: _profilePicture == null && widget.user?.photoURL == null
                    ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserInfo,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
