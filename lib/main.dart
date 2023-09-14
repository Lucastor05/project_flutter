import 'package:flutter/material.dart';
import 'package:project_flutter/View/Home.dart';
import 'package:project_flutter/View/Form/Login.dart';
import 'package:project_flutter/View/Form/Register.dart';
import 'package:project_flutter/View/Cours.dart';
import 'package:project_flutter/View/Concours.dart';
import 'package:project_flutter/View/Form/NewCour.dart';
import 'package:project_flutter/View/Form/NewConcour.dart';
import 'package:project_flutter/View/ParticipationConcour.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(title: 'Login'),
        '/register': (context) => const Register(title: 'Register'),
        '/home': (context) => const Home(title: 'Accueil'),
        '/competition': (context) => const Concours(title: 'Concours'),
        '/classes': (context) => const Cours(title: 'Cours'),
        '/parties': (context) => const Home(title: 'Soirées'),
        '/horses': (context) => const Home(title: 'Chevaux'),
        '/createConcours': (context) => const NewConcour(title: 'Créer un concour'),
        '/createCours': (context) => const NewCour(title: 'Créer un concour'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/registerConcours') {
          final String argument = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ParticipationConcours(idConcour: argument),
          );
        }
        return null;
      },
    );
  }
}