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
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Aucun cours disponible.');
            } else {
              final coursData = snapshot.data;

              return ListView.builder(
                itemCount: coursData?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final isGerant = UserController.isGerant();
                  final cours = coursData?[index];

                  if (cours?['isValidated'] == true) {
                    return Card(
                      child: ListTile(
                        title: Text('Discipline: ${cours?['discipline'] ?? ''}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Terrain: ${cours?['terrain'] ?? ''}'),
                            Text('Date : Le ${cours?['date']!.day}/${cours?['date']!.month}/${cours?['date']!.year} à ${cours?['date']!.hour}:${cours?['date']!.minute}'),
                            Text('Durée du cours: ${cours?['duree'] ?? ''}'),
                            /*Row(
                              children: [
                                if (isGerant)
                                  TextButton(
                                    onPressed: () async {
                                      if (await CoursController.deleteCours(cours?['_id'].toHexString())) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Soirée supprimée')),
                                        );
                                        Navigator.pushNamed(context, '/soiree');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Erreur lors de la suppression de la soirée')),
                                        );
                                      }
                                    },
                                    child: const Text('Supprimer'),
                                  ),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                    );
                  }else if(isGerant  && !cours?['isValidated']){
                    if(isGerant){
                      return Card(
                        child: ListTile(
                          title: Text('Discipline: ${cours?['discipline'] ?? ''}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Terrain: ${cours?['terrain'] ?? ''}'),
                              Text('Date : Le ${cours?['date']!.day}/${cours?['date']!.month}/${cours?['date']!.year} à ${cours?['date']!.hour}:${cours?['date']!.minute}'),
                              Text('Durée du cours: ${cours?['duree'] ?? ''}'),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      if (await CoursController.validate(cours?['_id'].toHexString())) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Soirée supprimée')),
                                        );
                                        Navigator.pushNamed(context, '/classes');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Erreur lors de la suppression de la soirée')),
                                        );
                                      }
                                    },
                                    child: const Text('Valider'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await CoursController.deleteCours(cours?['_id'].toHexString())) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Soirée supprimée')),
                                        );
                                        Navigator.pushNamed(context, '/soiree');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Erreur lors de la suppression de la soirée')),
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
                    }
                  }
                  return const SizedBox();
                },
              );
            }
          },
        )


    );
  }
}

