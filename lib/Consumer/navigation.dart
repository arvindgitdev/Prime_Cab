import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:PrimeServices/Consumer/cabpage.dart';
import 'package:PrimeServices/Consumer/food.dart';
import 'package:PrimeServices/Consumer/profile%20_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  int _selectedIndex=0;
  void _navigate(int index){
    setState(() {
      _selectedIndex= index;
    });

  }
  final List< Widget> _pages = [
    const UserHomePage(),
    const QRCodePage(),
    const ProfilePage(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(

        gap: 5,
        onTabChange:_navigate ,
        tabs: const [
          GButton(icon: Icons.local_taxi_outlined, text: "Cab",iconSize: 30,),
          GButton(icon: Icons.restaurant,text: "Food",iconSize: 30,),
          GButton(icon: Icons.person,text: "Person",iconSize: 30,),
        ],
      ),
    );
  }

}
