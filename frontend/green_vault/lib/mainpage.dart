import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:green_vault/homepage.dart';
import 'package:green_vault/product_page.dart';
import 'package:green_vault/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> widgetList = <Widget>[
    const ProductPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: widgetList,
        ),
        bottomNavigationBar: Container(
          color: Colors.green.shade400,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
              child: GNav(
                  backgroundColor: Colors.green.shade400,
                  color: Colors.green.shade100,
                  tabBackgroundColor: Colors.green.shade400,
                  activeColor: Colors.black,
                  gap: 15,
                  padding: const EdgeInsets.all(8),
                  tabs: const [
                    GButton(
                      icon: Icons.shopping_bag_outlined,
                      text: "Products",
                    ),
                    GButton(
                      icon: Icons.person,
                      text: "Profile",
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  })),
        ));
  }
}
