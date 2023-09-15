import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/Controller/HorseController.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'dart:io';

class UpdateHorse extends StatefulWidget {
  const UpdateHorse({super.key, required this.id});
  final String id;

  @override
  State<UpdateHorse> createState() => _UpdateHorseState();
}

class _UpdateHorseState extends State<UpdateHorse> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController robeController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController sexeController = TextEditingController();
  List<String> specialite = []; // Utilisez une liste de chaînes pour stocker les spécialités

  String? photoPath; // Stockez ici le chemin de la photo sélectionnée
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavBar(routes: const ["competition", "classes", "parties", "home", "cavalier"]),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Modifier les informations'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du cheval',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un nom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age du cheval',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un âge';
                    }
                    if (int.tryParse(value) == null) {
                      return 'L\'âge doit être un nombre entier';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: robeController,
                  decoration: const InputDecoration(
                    labelText: 'Robe du cheval',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir une robe';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: raceController,
                  decoration: const InputDecoration(
                    labelText: 'Race du cheval',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir la race';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: sexeController.text.isNotEmpty ? sexeController.text : null, // Assurez-vous que la valeur n'est pas vide ou définissez-la sur null
                  decoration: const InputDecoration(
                    labelText: 'Sexe du cheval',
                  ),
                  items: <String>['Masculin', 'Féminin']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      sexeController.text = newValue ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un sexe';
                    }
                    return null;
                  },
                ),

                const Padding(padding: EdgeInsets.only(bottom: 15)),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image, // Spécifiez que vous voulez des images
                    );
                    if (result != null && result.files.isNotEmpty) {
                      setState(() {
                        photoPath = result.files.first.path;
                        _imageFile = File(result.files.first.path!);
                      });
                    }
                  },
                  child: const Text("Sélectionner une image"),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                // Utilisez Wrap pour afficher les cases à cocher en deux par ligne
                Wrap(
                  children: [
                    CheckboxListTile(
                      title: const Text('Dressage'),
                      value: specialite.contains('Dressage'),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            specialite.add('Dressage');
                          } else {
                            specialite.remove('Dressage');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Saut d’obstacle'),
                      value: specialite.contains('Saut d’obstacle'),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            specialite.add('Saut d’obstacle');
                          } else {
                            specialite.remove('Saut d’obstacle');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Endurance'),
                      value: specialite.contains('Endurance'),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            specialite.add('Endurance');
                          } else {
                            specialite.remove('Endurance');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Complet'),
                      value: specialite.contains('Complet'),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            specialite.add('Complet');
                          } else {
                            specialite.remove('Complet');
                          }
                        });
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (photoPath != null) {
                        final success = await HorseController.update(
                          photoPath!,
                          nameController.text,
                          int.parse(ageController.text),
                          robeController.text,
                          raceController.text,
                          sexeController.text,
                          specialite,
                          widget.id
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Les informations ont été modifiés avec succes !')),
                          );
                          Navigator.pushNamed(context, '/descriptifHorse', arguments: widget.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur lors de la modification')),
                          );
                        }
                      } else {
                        print("Veuillez sélectionner une image");
                      }
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
