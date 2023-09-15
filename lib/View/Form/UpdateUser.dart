import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/Controller/UserController.dart';
import 'dart:io';

import '../../Controller/HorseController.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Map<String, dynamic>>> horses = HorseController.get();


  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? _imageFile = File(UserController.getCurrentUser()!.profilePicture);


  @override
  void initState() {
    super.initState();
    // Initialisez les contrôleurs avec les informations actuelles de l'utilisateur
    final currentUser = UserController.getCurrentUser();
    nameController.text = currentUser?.username ?? '';
    ageController.text = currentUser?.age.toString() ?? '';
    emailController.text = currentUser?.email ?? '';
    phoneController.text = currentUser?.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
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
                    labelText: 'Âge',
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
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir une adresse email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un téléphone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Mettez à jour les informations de l'utilisateur ici
                      final success = await UserController.updateUser(
                        _imageFile!.path,
                        nameController.text,
                        int.tryParse(ageController.text) ?? 0,
                        emailController.text,
                        phoneController.text,
                      );

                      if (success) {
                        Navigator.pushNamed(context, '/profile');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Les informations ont été mises à jour avec succès!'),
                          ),

                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur lors de la mise à jour des informations'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Mettre à jour'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
