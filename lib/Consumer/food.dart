import 'package:flutter/material.dart';


class QrCodePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
   // Combine user data into a string

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Text("Your qrcode")
      ),
    );
  }
}