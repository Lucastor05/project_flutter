import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/UserController.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: (){
            UserController.logout();
            Navigator.pushNamed(context, '/');
          }, icon: Icon(Icons.logout_outlined)),
          IconButton(onPressed: (){
            Navigator.pushNamed(context, '/profile');
          }, icon: Icon(Icons.supervised_user_circle))
        ],
      ),
      bottomNavigationBar: NavBar(routes: ["competition", "classes", "soiree", "horses", "cavalier"]),
      body: Text(UserController.getCurrentUser()!.username),
    );
  }
}

