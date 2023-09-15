import 'package:flutter/material.dart';
//mport 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/night_controller.dart';
import 'package:project_flutter/View/Form/Form_Night.dart';
import 'dart:io';

class Night extends StatefulWidget {
  const Night({super.key, required this.title});
  final String title;

  @override
  State<Night> createState() => _NightState();
}

class _NightState extends State<Night> {
  Future<List<Map<String, dynamic>>> night = NightController.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box),
              tooltip: 'Créer une soirée',
              onPressed: () {
                Navigator.pushNamed(context, '/createSoiree');
              },
            ),
          ],
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: night,
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
              return const Text('Aucune soirée disponible.');
            } else {
              final soireeData = snapshot.data;
              return ListView.builder(
                itemCount: soireeData?.length,
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
                              File(soireeData?[index]['photo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nom: ${soireeData?[index]['name'] ?? ''}'),
                                Text('Date : Le ${soireeData?[index]['date']!.day}/${soireeData?[index]['date']!.month}/${soireeData?[index]['date']!.year} à ${soireeData?[index]['date']!.hour}:${soireeData?[index]['date']!.minute}'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/registerSoiree', arguments: soireeData?[index]['_id'].toHexString());
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