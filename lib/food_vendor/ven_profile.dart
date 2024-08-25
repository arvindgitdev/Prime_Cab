import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:PrimeServices/provider/auth_provider.dart' as custom_auth_provider; // Import your AuthProvider

class SupplierProfilePage extends StatefulWidget {
  const SupplierProfilePage({super.key});

  @override
  State<SupplierProfilePage> createState() => _SupplierProfilePageState();
}

class _SupplierProfilePageState extends State<SupplierProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _name;
  String? _email;
  String? _phone;
  String? _profilePictureUrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSupplierData();
  }

  Future<void> _loadSupplierData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final docSnapshot = await _firestore.collection('vendors').doc(user.uid).get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            _name = data?['name'];
            _email = data?['email'];
            _phone = data?['phone'];
            _profilePictureUrl = data?['profile_picture'];
            _loading = false;
          });
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load supplier data: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Vendor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              Provider.of<custom_auth_provider.AuthProvider>(context, listen: false).signOut(context);
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePictureUrl != null
                    ? NetworkImage(_profilePictureUrl!)
                    : null,
                child: _profilePictureUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text('Name: ${_name ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${_email ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone: ${_phone ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
