import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/UserController.dart';

import '../Controller/HorseController.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.title});
  final String title;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<List<Map<String, dynamic>>> horses = HorseController.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBar(routes: const ["competition", "classes", "parties", "horses", "cavalier"]),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/updateUser');
            },
            icon: const Icon(Icons.mode_edit_outline_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ClipOval(
                child: CircleAvatar(
                  radius: 80.0,
                  child: Image.file(
                    File(UserController.getCurrentUser()!.profilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text('Nom : ${UserController.getCurrentUser()!.username}'),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            Text('Email : ${UserController.getCurrentUser()!.email}'),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            if (UserController.getCurrentUser()!.age != null)
              Text("Age : ${UserController.getCurrentUser()!.age}"),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            if (UserController.getCurrentUser()!.phone != "")
              Text("Phone : ${UserController.getCurrentUser()!.phone}"),
            const Padding(padding: EdgeInsets.only(bottom: 15)),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: horses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Aucun cours disponible.');
                  } else {
                    final horsesData = snapshot.data;
                    return ListView.builder(
                      itemCount: horsesData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final isGerant = UserController.isGerant();
                        if (horsesData?[index]['proprietaire'] == UserController.getCurrentUser()!.username) {
                          return Card(
                            child: ListTile(
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(horsesData?[index]['photo']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 15)),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Nom: ${horsesData?[index]['nom'] ?? ''}'),
                                        Text('Age: ${horsesData?[index]['age'] ?? ''}'),
                                        
                                        /*GestureDetector(
  onTap: () {
    // Ouvrir le lien dans un navigateur
    launch('https://www.example.com');
  },
  child: Text(
    'https://www.example.com',
    style: TextStyle(
      decoration: TextDecoration.underline,
      color: Colors.blue,
    ),
  ),
),*/
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/descriptifHorse',
                                                  arguments: horsesData?[index]['_id'].toHexString(),
                                                );
                                              },
                                              child: const Text("Voir"),
                                            ),
                                            if (isGerant || horsesData?[index]['proprietaire'] == UserController.getCurrentUser()!.username)
                                              TextButton(
                                                onPressed: () async {
                                                  if (await HorseController.deleteHorse(horsesData?[index]['_id'].toHexString())) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Cheval supprimé')),
                                                    );
                                                    Navigator.pushNamed(context, '/horses');
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Erreur lors de la suppression de l\'utilisateur')),
                                                    );
                                                  }
                                                },
                                                child: const Text('Supprimer'),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(child:Text("Vous n'avez pas de cheveaux"));
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
