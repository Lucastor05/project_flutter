import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/HorseController.dart';
import 'package:project_flutter/Controller/UserController.dart';
import 'dart:io';

class DescriptifHorse extends StatefulWidget {
  const DescriptifHorse({super.key, required this.idConcour});
  final String idConcour;

  @override
  State<DescriptifHorse> createState() => _DescriptifHorseState();
}

class _DescriptifHorseState extends State<DescriptifHorse> {
  late Future<Map<String, dynamic>?> horse;
  late List<Map<String, dynamic>> userList = [];

  final _formKey = GlobalKey<FormState>();
  String? selectedDifficulty;

  @override
  void initState() {
    super.initState();
    // Initialisez le futur pour obtenir les informations du concours
    initHorse();
  }

  // Méthode pour initialiser la connexion à la base de données
  Future<void> initHorse() async {
    horse = HorseController.getOne(widget.idConcour);
    // Chargez la liste des utilisateurs inscrits dès le début
    await loadUserList();
  }

  // Méthode pour charger la liste des utilisateurs inscrits
  Future<void> loadUserList() async {
    final concoursData = await horse;
    if (concoursData != null) {
      final List<dynamic> users = concoursData['userList'];
      for (final user in users) {
        final userEmail = user['userId'];
        final userData = await UserController.getFromEmail(userEmail);
        if (userData.isNotEmpty) {
          userList.add(userData[0]);
        }
      }
      setState(() {}); // Rafraîchir l'interface graphique après le chargement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBar(routes: const ["home", "classes", "parties", "horses", "cavalier"]),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Description du Cheval'),

    ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: horse,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Aucune information sur le concours disponible.');
                } else {
                  final concoursData = snapshot.data!;
                  return Column(
                    children: [
                      if(concoursData['proprietaire'] == UserController.getCurrentUser()!.username)
                      IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/updateHorse', arguments: concoursData["_id"].toHexString());
                          },
                          icon: const Icon(Icons.mode_edit_outline_rounded)
                      ),
                      Expanded(
                        flex: 1,
                        child: ClipOval(
                          child: CircleAvatar(
                            radius: 80.0,
                            child: Image.file(
                              File(concoursData['photo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text('Nom : ${concoursData['nom']}'),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Text('Age : ${concoursData['age']}'),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Text('Robe : ${concoursData['robe']}'),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Text('Race : ${concoursData['race']}'),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Text('Sexe : ${concoursData['sexe']}'),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Text('Propriétaire : ${concoursData['proprietaire']}'),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Text('Spécialités : ${concoursData['specialite'].join(", ")}'),

                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
