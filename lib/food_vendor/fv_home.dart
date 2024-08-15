import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({Key ? key}) : super(key: key);

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {

  var getResult = 'QR Code Result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
          backgroundColor: Colors.grey
      ),
      body: Center(
          child: Row(//Column(
            //mainAxisAlignment: MainAxisAlignment.center,
           children: [
              Row(
                children: [
                 Expanded(child:
                 ElevatedButton.icon(
                    icon: Icon(Icons.qr_code_scanner_outlined,color: Colors.white,size: 40,),
                      label: Text('Scan QR',style: TextStyle(color: Colors.white,fontSize: 20),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                     onPressed: () {
                      scanQRCode();
                    },
                   // style: ElevatedButton.styleFrom(),
                   // child:  Icon(Icons.qr_code_scanner_outlined,color: Colors.white,size: 40,),
                   // Text('Scan QR'),
                 ),
                  //SizedBox(height: 20.0,),
                  //Text(getResult),
                 ),
                // Expanded(child:
                     //ElevatedButton(onPressed: , child:)
                  // ElevatedButton.icon(
                    // Icon(Icons.qr_code_scanner_outlined,color: Colors.white,size: 40,),
    //),
                  // )

                ],
              ),
            ],
          )
     ),
    );
  }

  void scanQRCode() async {
    try{
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        getResult = qrCode;
      });
      print("QRCode_Result:--");
      print(qrCode);
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }

  }

}