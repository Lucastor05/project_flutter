import 'package:flutter/material.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/CoursController.dart';


class Cours extends StatefulWidget {
  const Cours({super.key, required this.title});
  final String title;

  @override
  State<Cours> createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  Future<List<Map<String, dynamic>>> cours = CoursController.get();

  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  String? selectedTerrain;
  String? selectedDiscipline;

  final terrainController = TextEditingController();
  final disciplineController = TextEditingController();
  final heuresController = TextEditingController();
  final minutesController = TextEditingController();

  String _formatDuree(int heures, int minutes) {
    final heuresStr = heures > 0 ? '$heures heure${heures > 1 ? 's' : ''}' : '';
    final minutesStr = minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : '';

    if (heures > 0 && minutes > 0) {
      return '$heuresStr $minutesStr';
    } else if (heures > 0) {
      return heuresStr;
    } else if (minutes > 0) {
      return minutesStr;
    } else {
      return ''; // Aucune durée si les deux champs sont vides
    }
  }

  @override
  void dispose() {
    terrainController.dispose();
    disciplineController.dispose();
    heuresController.dispose();
    minutesController.dispose();
    super.dispose();
  }

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
      bottomNavigationBar: NavBar(routes: ["competition", "home", "parties", "horses"],),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Créer un cours',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Créer un cours"),
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        key: _formKey,
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedTerrain,
                            hint: Text('Sélectionnez un terrain'),
                            onChanged: (newValue) {
                              setState(() {
                                selectedTerrain = newValue;
                              });
                            },
                            items: <String>['Manège', 'Carrière'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez sélectionner un terrain';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Terrain',
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
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
                          DropdownButtonFormField<String>(
                            value: selectedDiscipline,
                            hint: Text('Sélectionnez une discipline'),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDiscipline = newValue;
                              });
                            },
                            items: <String>['Dressage', 'Saut d\’obstacle', 'Endurance'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez sélectionner une discipline';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Discipline',
                            ),
                          ),
                          const Row(children:[Text("Durée du cours")]),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: heuresController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Heures',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: minutesController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Minutes',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Ferme la boîte de dialogue
                            },
                            child: const Text("Annuler"),
                          ),
                          TextButton(
                            onPressed: () {
                              final heuresSaisies = heuresController.text.isNotEmpty ? int.parse(heuresController.text) : 0;
                              final minutesSaisies = minutesController.text.isNotEmpty ? int.parse(minutesController.text) : 0;

                              final duree = _formatDuree(heuresSaisies, minutesSaisies);

                              CoursController.set(selectedTerrain!, selectedDate!, duree, selectedDiscipline!);


                              Navigator.of(context).pop(); // Ferme la boîte de dialogue
                            },
                            child: const Text("Créer"),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Affichez un indicateur de chargement en attendant la résolution du Future
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
                    title: Text('Discipline: ${coursData?[index]['discipline'] ?? ''}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Terrain: ${coursData?[index]['terrain'] ?? ''}'),
                        Text('Date: ${coursData?[index]['date'] ?? ''}'),
                        Text('Durée du cours: ${coursData?[index]['duree'] ?? ''}'),
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

