import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  bool isNavBarVisible = false;

  void toggleNavBar() {
    setState(() {
      isNavBarVisible = !isNavBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("zibve");
  }
}