import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isNavBarVisible = false;

  void toggleNavBar() {
    setState(() {
      isNavBarVisible = !isNavBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: toggleNavBar,
        child: const Icon(Icons.menu),
      ),

      // Intégrer la barre de navigation ici conditionnellement en fonction de isNavBarVisible
      body: isNavBarVisible ? const NavBar() : Container(),
    );
  }
}

