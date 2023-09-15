import 'package:flutter/material.dart';
import 'dart:io';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/HorseController.dart';
import 'package:project_flutter/Controller/UserController.dart';

class Horses extends StatefulWidget {
  const Horses({super.key, required this.title});
  final String title;

  @override
  State<Horses> createState() => _HorsesState();
}

class _HorsesState extends State<Horses> {
  Future<List<Map<String, dynamic>>> horses = HorseController.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBar(routes: const ["competition", "classes", "parties", "home", "cavalier"]),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box),
              tooltip: 'Créer un cours',
              onPressed: (){
                Navigator.pushNamed(context, '/createHorse');
              },
            ),
          ],
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: horses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  )
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
                  final isGerant = UserController.isGerant(); // Vérifiez si l'utilisateur est un gérant

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
                                Text('Propriétaire: ${horsesData?[index]['proprietaire'] ?? ''}'),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pushNamed(context, '/descriptifHorse', arguments: horsesData?[index]['_id'].toHexString(),);
                                        },
                                        child: const Text("Voir")
                                    ),
                                    if (isGerant || horsesData?[index]['proprietaire'] == UserController.getCurrentUser()!.username) // Affichez le bouton "Supprimer" uniquement si l'utilisateur est un gérant
                                      TextButton(
                                        onPressed: () async{
                                          if(await HorseController.deleteHorse(horsesData?[index]['_id'].toHexString())){
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Cheval supprimé')),
                                            );
                                            Navigator.pushNamed(context, '/horses');
                                          }else{
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

                },
              );
            }
          },
        )
    );
  }
}
