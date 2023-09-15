import 'package:flutter/material.dart';
import 'package:project_flutter/Model/UserModel.dart';
import 'package:project_flutter/View/partials/NavBar.dart';
import 'package:project_flutter/Controller/UserController.dart';

class Cavalier extends StatefulWidget {
  const Cavalier({super.key, required this.title});
  final String title;

  @override
  State<Cavalier> createState() => _CavalierState();
}

class _CavalierState extends State<Cavalier> {
  Future<List<Map<String, dynamic>>> users = UserController.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBar(routes: const ["competition", "classes", "parties", "horses", "home"]),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: users,
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
                  final isGerant = UserController.isGerant(); // Vérifiez si l'utilisateur est un gérant

                  return Card(
                    child: ListTile(
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              coursData?[index]['profilePicture'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nom: ${coursData?[index]['username'] ?? ''}'),
                                Text('Email: ${coursData?[index]['email'] ?? ''}'),
                                if(coursData?[index]['phone'] != '')
                                  Text('Phone: ${coursData?[index]['phone'] ?? ''}'),

                                if(coursData?[index]['age'] != null)
                                  Text('Age: ${coursData?[index]['age'] ?? ''}'),
                                if (isGerant) // Affichez le bouton "Supprimer" uniquement si l'utilisateur est un gérant
                                  TextButton(
                                    onPressed: () async{
                                      if(await UserManager.deleteFromEmail(coursData?[index]['email'])){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Utilisateur supprimé')),
                                        );
                                        Navigator.pushNamed(context, '/cavalier');
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Erreur lors de la suppression de l\'utilisateur')),
                                        );
                                      }
                                    },
                                    child: const Text('Supprimer'),
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
