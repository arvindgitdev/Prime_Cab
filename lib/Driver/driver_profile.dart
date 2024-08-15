import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle save action
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const AssetImage('assets/default_profile.jpg'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Handle change profile picture
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: 'Name',
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
              // onChanged: (value) {}, // Handle username change
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: 'Phone',
              decoration: const InputDecoration(
                labelText: 'phone',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
              // onChanged: (value) {}, // Handle name change
            ),

            const SizedBox(height: 12),
            TextFormField(
              initialValue: 'Email',
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
              // onChanged: (value) {}, // Handle website change
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: 'Car Detials',
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Car Details',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
              // onChanged: (value) {}, // Handle bio change
            ),
          ],
        ),
      ),
    );
  }
}
