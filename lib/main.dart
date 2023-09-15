import 'package:flutter/material.dart';
import 'package:project_flutter/Model/Database.dart';
import 'package:project_flutter/View/Login.dart';
import 'package:project_flutter/View/Register.dart';
import 'package:project_flutter/View/Home.dart';
import 'package:project_flutter/View/Night_event_form.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Database.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'project_flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade900),
        useMaterial3: true,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const Night(title: 'Form'),
        '/register': (context) => const Register(title: 'Register'),
      },
      /*onGenerateRoute: (settings) {
        if (settings.name == '/register') {
          final String argument = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => Register(title: argument),
          );
        }
        return null;
      },*/
    );
  }
}