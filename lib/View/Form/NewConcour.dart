import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/ConcoursController.dart';
import 'dart:io';


class NewConcour extends StatefulWidget {
  const NewConcour({super.key, required this.title});
  final String title;

  @override
  State<NewConcour> createState() => _NewConcourState();
}

class _NewConcourState extends State<NewConcour> {

  Future<List<Map<String, dynamic>>> concours = ConcoursController.get();

  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  DateTime? selectedDate;

  final nameController = TextEditingController();
  final adresseController = TextEditingController();

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
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBar(routes: const ["home", "classes", "parties", "horses"]),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(30), // Ajoute un padding de 10 pixels de tous les côtés
            child: Form(
              key: _formKey,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du concours',
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
                    controller: adresseController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse du concours',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir une adresse';
                      }
                      return null;
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 15)),


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



                  const Padding(padding: EdgeInsets.only(bottom: 15)),
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
                        if (await ConcoursController.set(
                          nameController.text,
                          adresseController.text,
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

            )
        ),
    );
  }
}

