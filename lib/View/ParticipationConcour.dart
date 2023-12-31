import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/ConcoursController.dart';
import 'package:project_flutter/Controller/UserController.dart';
import 'dart:io';

class ParticipationConcours extends StatefulWidget {
  const ParticipationConcours({super.key, required this.idConcour});
  final String idConcour;

  @override
  State<ParticipationConcours> createState() => _ParticipationConcoursState();
}

class _ParticipationConcoursState extends State<ParticipationConcours> {
  late Future<Map<String, dynamic>?> concours;
  late List<Map<String, dynamic>> userList = [];

  final _formKey = GlobalKey<FormState>();
  String? selectedDifficulty;

  @override
  void initState() {
    super.initState();
    // Initialisez le futur pour obtenir les informations du concours
    initConcours();
  }

  // Méthode pour initialiser la connexion à la base de données
  Future<void> initConcours() async {
    concours = ConcoursController.getOne(widget.idConcour);
    // Chargez la liste des utilisateurs inscrits dès le début
    await loadUserList();
  }

  // Méthode pour charger la liste des utilisateurs inscrits
  Future<void> loadUserList() async {
    final concoursData = await concours;
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Description du Concours'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: concours,
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

                      /* ----------- INFORMATION CONCOUR -----------*/

                      Text("Informations sur le concours :"),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.file(
                              File(concoursData?['photo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${concoursData['nom']}'),
                                Text('${concoursData['adresse']}'),
                                Text('Le ${concoursData?['date']!.day}/${concoursData?['date']!.month}/${concoursData?['date']!.year} à ${concoursData?['date']!.hour}:${concoursData?['date']!.minute}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),

                      /* ----------- INSCRIPTION CONCOUR -----------*/

                      DropdownButtonFormField<String>(
                        value: selectedDifficulty,
                        hint: const Text('Sélectionnez une difficulté'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedDifficulty = newValue;
                          });
                        },
                        items: <String>[
                          'Amateur',
                          'Club1',
                          'Club2',
                          'Club3',
                          'Club4'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner une difficulté';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Difficultés',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (await ConcoursController.participate(
                                selectedDifficulty!, widget.idConcour)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vous avez bien été enregistré')),
                              );
                              Navigator.pushNamed(context, '/competition');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Erreur lors de l\'enregistrement, veuillez réessayer plus tard')),
                              );
                            }
                          }
                        },
                        child: const Text("Participer"),
                      ),

                      /* ----------- LIST PARTICIPANT CONCOUR -----------*/
                      const Text("Utilisateurs inscrits :"),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      SizedBox(
                        height: 200, // Ajustez la hauteur en conséquence
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            final user = userList[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // Couleur de fond de chaque liste
                                borderRadius: BorderRadius.circular(10), // Bord arrondi
                              ),
                              margin: const EdgeInsets.only(bottom: 15),
                              child: ListTile(
                                title: Text(user['username']), // Nom d'utilisateur
                                subtitle: Text(user['email']), // Adresse e-mail
                                trailing: Text(concoursData['userList'][index]['difficulty']), // Difficulté
                              ),
                            );
                          },
                        ),
                      ),


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
