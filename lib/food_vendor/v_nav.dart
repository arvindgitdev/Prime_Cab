import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:primecabs/food_vendor/fv_home.dart';
import 'package:primecabs/food_vendor/daily_record_page.dart';
import 'package:primecabs/food_vendor/ven_profile.dart';


class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int _selectedIndex = 0;
  String? _scanResult;

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleScanResult(String result) {
    setState(() {
      _scanResult = result;
      _selectedIndex = 1; // Navigate to DailyRecordPage
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      MyCustomWidget(onScan: _handleScanResult),
      DailyRecordPage(scanResult: _scanResult),
      const SupplierProfilePage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        gap: 5,
        onTabChange: _navigate,
        tabs: [
          const GButton(icon: Icons.qr_code_scanner, text: "Scanner", iconSize: 30),
          const GButton(icon: Icons.edit_note_sharp, text: "Food", iconSize: 30),
          const GButton(icon: Icons.person, text: "Person", iconSize: 30),
        ],
      ),
    );
  }
}
