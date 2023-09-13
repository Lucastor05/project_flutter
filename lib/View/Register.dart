import 'package:flutter/material.dart';
import 'package:project_flutter/Controller/IdentificationController.dart';
import 'package:file_picker/file_picker.dart';

import '../Model/UserModel.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.title});

  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  PlatformFile? _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              ElevatedButton(
                  onPressed: () async{
                    final result = await FilePicker.platform.pickFiles();
                    if(result == null) return;

                    _file = result.files.first;
                  },
                  child: const Text("Pick file")
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              Center(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    if (IdentificationController.RegisterUser(
                        emailController.text, usernameController.text,
                        passwordController.text)) {

                      Navigator.pushNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Erreur lors de l'enregistrement"),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}