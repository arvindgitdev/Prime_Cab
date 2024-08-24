import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? qrData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _generateQRCode();
  }

  Future<void> _generateQRCode() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // You can store the user's ID or any other relevant data
        qrData = user.uid;

        // Save the QR data to Firestore under the user's document
        await _firestore.collection('users').doc(user.uid).update({
          'qr_code': qrData,
        });

        setState(() {
          _loading = false;
        });
      } catch (e) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate QR code: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (qrData != null)
                    QrImageView(
                          data: qrData!,
                          version: QrVersions.auto,
                          size: 300.0,
                        ) else const Text('No QR Code available'),
                  const SizedBox(height: 30),
                  const Text(
                    'Scan this code to access your details',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
