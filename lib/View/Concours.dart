import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/ConcoursController.dart';
import 'dart:io';

class Concours extends StatefulWidget {
  const Concours({super.key, required this.title});
  final String title;

  @override
  State<Concours> createState() => _ConcoursState();
}

class _ConcoursState extends State<Concours> {
  Future<List<Map<String, dynamic>>> concours = ConcoursController.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBar(routes: const ["home", "classes", "soiree", "horses", "cavalier"]),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Créer un cours',
            onPressed: () {
              Navigator.pushNamed(context, '/createConcours');
            },
          ),
        ],
      ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: concours,
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
                  return Card(
                    child: ListTile(
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.file(
                              File(coursData?[index]['photo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nom: ${coursData?[index]['nom'] ?? ''}'),
                                Text('Adresse: ${coursData?[index]['adresse'] ?? ''}'),
                                Text('Date : Le ${coursData?[index]['date']!.day}/${coursData?[index]['date']!.month}/${coursData?[index]['date']!.year} à ${coursData?[index]['date']!.hour}:${coursData?[index]['date']!.minute}'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/registerConcours', arguments: coursData?[index]['_id'].toHexString());
                                  },
                                  child: const Text('Participer'),
                                ),
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
