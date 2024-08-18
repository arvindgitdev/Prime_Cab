import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        await addFieldToDocuments(scanResult); // Add field to documents in Firestore
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Failed to scan QR code: $e';
      });
    }
  }

  Future<void> addFieldToDocuments(String scanResult) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final collectionRef = _firestore.collection('food_distributions');

    final querySnapshot = await collectionRef
        .where('scan_code', isEqualTo: scanResult) // Assuming you use scanResult to match documents
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'new_field': 'default_value', // Replace with your field name and default value
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: scanQRCode,
              child: Text('Start QR Code Scan'),
            ),
            SizedBox(height: 20),
            if (_scanResult != null)
              Text(
                'Scan result: $_scanResult',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
