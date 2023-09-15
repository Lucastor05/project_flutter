import 'package:flutter/material.dart';
import 'package:project_flutter/Controller/NightController.dart';
import 'package:project_flutter/Controller/UserController.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'dart:io';

class ParticipationNight extends StatefulWidget {
  const ParticipationNight({super.key, required this.idNight});
  final String idNight;

  @override
  State<ParticipationNight> createState() => _ParticipationNightState();
}

class _ParticipationNightState extends State<ParticipationNight> {
  late Future<Map<String, dynamic>?> night;
  late List<Map<String, dynamic>> userList = [];

  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initNight();
  }

  Future<void> initNight() async {
    night = NightController.getOne(widget.idNight);
    await loadUserList();
  }

  Future<void> loadUserList() async {
    final nightData = await night;
    if (nightData != null) {
      final List<dynamic> users = nightData['userList'];
      for (final user in users) {
        final userEmail = user['userId'];
        final userData = await UserController.getFromEmail(userEmail);
        if (userData.isNotEmpty) {
          userList.add(userData[0]);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBar(routes: const ["home", "classes", "soiree", "horses", "cavalier"]),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Description de la soirée'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: night,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Aucune information sur la soirée disponible.');
                } else {
                  final nightData = snapshot.data!;
                  return Column(
                    children: [
                      Text("Informations sur la soirée :"),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.file(
                              File(nightData['photo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${nightData['name']}'),
                                Text('Le ${nightData['date'].day}/${nightData['date'].month}/${nightData['date'].year} à ${nightData['date'].hour}:${nightData['date'].minute}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                      TextFormField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          labelText: 'Commentaire sur la soirée',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please write a comment';
                          }
                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (await NightController.participate(widget.idNight, commentController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vous avez bien été enregistré')),
                              );
                              Navigator.pushNamed(context, '/registerSoiree', arguments: widget.idNight);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erreur lors de l\'enregistrement, veuillez réessayer plus tard'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Participer"),
                      ),
                      const Text("Utilisateurs inscrits :"),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            final user = userList[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(bottom: 15),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['username']), // Nom d'utilisateur
                                    Text(user['email']), // Adresse e-mail
                                  ],
                                ),
                                subtitle: Flexible(
                                  child: Text(nightData['userList'][index]['comment'] ?? 'Aucun commentaire'),
                                ),
                              )



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
