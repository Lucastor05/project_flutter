import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/CoursController.dart';

import '../Controller/UserController.dart';


class Cours extends StatefulWidget {
  const Cours({super.key, required this.title});
  final String title;

  @override
  State<Cours> createState() => _CoursState();
}

class _CoursState extends State<Cours> {

  Future<List<Map<String, dynamic>>> cours = CoursController.get();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(routes: ["competition", "home", "soiree", "horses", "cavalier"],),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Créer un cours',
            onPressed: (){
              Navigator.pushNamed(context, '/createCours');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cours,
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
            final coursData = snapshot.data;
            return ListView.builder(
              itemCount: coursData?.length,
              itemBuilder: (BuildContext context, int index) {
                final isGerant = UserController.isGerant();
                return Card(
                  child: ListTile(
                    title: Text('Discipline: ${coursData?[index]['discipline'] ?? ''}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Terrain: ${coursData?[index]['terrain'] ?? ''}'),
                        Text('Date : Le ${coursData?[index]['date']!.day}/${coursData?[index]['date']!.month}/${coursData?[index]['date']!.year} à ${coursData?[index]['date']!.hour}:${coursData?[index]['date']!.minute}'),
                        Text('Durée du cours: ${coursData?[index]['duree'] ?? ''}'),
                        Row(
                          children: [
                            if (isGerant) // Affichez le bouton "Supprimer" uniquement si l'utilisateur est un gérant
                              TextButton(
                                onPressed: () async{
                                  if(await CoursController.deleteCours(coursData?[index]['_id'].toHexString())){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Soiree supprimé')),
                                    );
                                    Navigator.pushNamed(context, '/soiree');
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Erreur lors de la suppression de la soiree')),
                                    );
                                  }
                                },
                                child: const Text('Supprimer'),
                              ),
                          ],
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

