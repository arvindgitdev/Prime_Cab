import 'package:PrimeServices/Driver/accept_page.dart';
import 'package:PrimeServices/Driver/driver_home.dart';
import 'package:PrimeServices/Driver/driver_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class   DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  int _selectedIndex=0;
  void _navigate(int index){
    setState(() {
      _selectedIndex= index;
    });

  }
  final List< Widget> _pages = [
    const DriverHomePage(),
    const RideRequestsPage(),
    const ProfilePage()

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(

        gap: 5,
        onTabChange:_navigate ,
        tabs: const [
          GButton(icon: Icons.home, text: "Home",iconSize: 30,),
          GButton(icon: Icons.notification_add_outlined,text: "Notification",iconSize: 30),
          GButton(icon: Icons.person,text: "Person",iconSize: 30,),
        ],
      ),
    );
  }

}
