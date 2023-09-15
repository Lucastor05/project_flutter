import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/Controller/night_controller.dart';
//import 'package:project_flutter/View/partials/NavBar.dart';
import 'dart:io';
//import 'package:file_picker/file_picker.dart';
//import 'dart:io';

class Night extends StatefulWidget {
  const Night({super.key, required this.title});
  final String title;
  @override
  State<Night> createState() => _NightState();
}

class _NightState extends State<Night> {

  Future<List<Map<String, dynamic>>> night = NightController.get();

  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  DateTime? selectedDate;

  final NameController=TextEditingController();
  final CommmentController = TextEditingController();

  @override

  Future<void> _selectDate(BuildContext context) async {

    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ))!;
    if (pickedDate != null) {
      final TimeOfDay pickedTime = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ))!;
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          selectedDate = pickedDateTime;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //bottomNavigationBar: NavBar(routes: ["competition", "home", "parties", "horses"],),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box),
              tooltip: 'Créer une soirée',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Créer une soirée"),
                      content: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          key: _formKey,
                          children: [
                            TextFormField(
                              controller: NameController,
                              decoration: const InputDecoration(
                                labelText: 'Nom de la soirée',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir un nom';
                                }
                                return null;
                              },
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 15)),
                            TextFormField(
                              controller: CommmentController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some Name text';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(labelText: 'Comment for users'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_imageFile != null)
                                  Image.file(
                                    _imageFile!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                const Padding(padding: EdgeInsets.only(right: 15)),
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await FilePicker.platform.pickFiles(
                                    type: FileType.image, // Spécifiez que vous voulez des images
                                    );
                                    if (result == null) return;

                                    setState(() {
                                      if (result != null && result.files.isNotEmpty) {
                                        _imageFile = File(result.files.first.path!);
                                      }
                                    });
                                  },
                                  child: const Text("Sélectionner une image"),
                                ),
                              ],
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} à ${selectedDate!.hour}:${selectedDate!.minute}"
                                  : "",
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                              decoration: const InputDecoration(
                                labelText: "Sélectionner une date",
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please choose a date';
                                }
                                return null;
                              },
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 15)),
                            TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (await NightController.set(
                                    NameController.text,
                                    CommmentController.text,
                                    _imageFile!.path,
                                    selectedDate!,
                                  )) {
                                    Navigator.pushNamed(context, '/competition');
                                  } else {
                                    print("error pendant l'enregistrement");
                                  }
                                } else {
                                  print("error pendant la validation");
                                }
                              },
                              child: const Text("Créer"),
                            ),
                          ],
                        ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        /*body: FutureBuilder<List<Map<String, dynamic>>>(
          future: night,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Affichez un indicateur de chargement en attendant la résolution du Future
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Aucune soirée disponible.');
            } else {
              final night = snapshot.data;
              return Text('tempo');
              return ListView.builder(
                itemCount: night?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text('Discipline: ${night?[index]['name'] ?? ''}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('comment: ${nightData?[index]['comment'] ?? ''}'),
                          Text('date: ${nightData?[index]['date'] ?? ''}'),
                          Text('photo: ${nightData?[index]['photo'] ?? ''}'),
                          //Text('userList: ${nightData?[index]['userList'] ?? ''}'),
                        ],
                      ),
                    ),
                  );


                },
              );
            }
          },
        )*/

    );
  }
}