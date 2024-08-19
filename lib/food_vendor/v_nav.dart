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
  int _selectedIndex=0;
  void _navigate(int index){
    setState(() {
      _selectedIndex= index;
    });

  }
  final List< Widget> _pages = [
    MyCustomWidget(onScan: (String ) {  },),
    DailyRecordPage(),
    const SupplierProfilePage(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(

        gap: 5,
        onTabChange:_navigate ,
        tabs: const [
          GButton(icon: Icons.qr_code_scanner_rounded, text: "Scanner",iconSize: 30,),
          GButton(icon: Icons.edit_note_rounded,text: "Record",iconSize: 30,),
          GButton(icon: Icons.person,text: "Person",iconSize: 30,),
        ],
      ),
    );
  }

}
