import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting datetime

class MyCustomWidget extends StatefulWidget {
  final Function(String) onScan;

  MyCustomWidget({required this.onScan});

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  String? _scanResult;

  Future<void> scanQRCode() async {
    try {
      String scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );

      if (scanResult != '-1') {
        setState(() {
          _scanResult = scanResult;
        });
        widget.onScan(scanResult); // Pass the result back
        await _showDetailsDialog(scanResult); // Show details in dialog
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Failed to scan QR code: $e';
      });
    }
  }

  Future<void> _showDetailsDialog(String scanResult) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final docRef = _firestore.collection('users').doc(scanResult);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data();

      // Check if the QR code was scanned within the last 2 hours
      final twoHoursAgo = DateTime.now().subtract(Duration(hours: 2));
      final querySnapshot = await _firestore
          .collection('food_distributions')
          .where('scan_code', isEqualTo: scanResult)
          .where('timestamp', isGreaterThan: Timestamp.fromDate(twoHoursAgo))
          .orderBy('timestamp', descending: true) // Order by latest scan
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there's a record within the last 2 hours, show a message
        final lastScanTimestamp = querySnapshot.docs.first['timestamp'].toDate();
        final nextAllowedTime = lastScanTimestamp.add(Duration(hours: 2));
        final formattedLastScan = DateFormat(' hh:mm a').format(lastScanTimestamp);
        final formattedNextAllowedTime = DateFormat(' hh:mm a').format(nextAllowedTime);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Duplicate Scan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('This user has already provided food within the last 2 hours.'),
                  SizedBox(height: 10),
                  Text('Last scan time: $formattedLastScan'),
                  SizedBox(height: 10),
                  Text('Next allowed time: $formattedNextAllowedTime'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If no record within the last 2 hours, proceed and add to Firestore
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('User Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Name: ${userData?['name'] ?? 'N/A'}'),
                  Text('Email: ${userData?['email'] ?? 'N/A'}'),
                  Text('Phone: ${userData?['phone'] ?? 'N/A'}'),
                  // Add more fields as needed
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Store details in Firestore
        await _firestore.collection('food_distributions').add({
          'scan_code': scanResult,
          'name': userData?['name'] ?? 'N/A',
          'email': userData?['email'] ?? 'N/A',
          'phone': userData?['phone'] ?? 'N/A',
          // Add more fields as needed
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      print("No such document!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scanQRCode,
              child: const Text('Start QR Code Scan'),
            ),
            const SizedBox(height: 20),
            if (_scanResult != null)
              Text(
                'Scan result: $_scanResult',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
