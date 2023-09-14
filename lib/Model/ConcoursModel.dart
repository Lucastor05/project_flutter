import 'package:mongo_dart/mongo_dart.dart';
import 'package:project_flutter/Model/UserModel.dart';

import 'Database.dart';

class ConcoursManager {

  static Future<bool> insertConcour(String nom, String adresse, String photo, DateTime date) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("concours");

    try {
      await collection.insertOne({
        'nom' : nom,
        'adresse' : adresse,
        'photo' : photo,
        'date' : date,
        'userList' : [],
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllConcours() async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("concours");
    var concours = await collection.find().toList();
    return concours;
  }

  static Future<Map<String, dynamic>?> getOneConcour(String idConcour) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return null;
    }

    var collection = db.collection("concours");
    var objectId = ObjectId.parse(idConcour);
    var concours = await collection.findOne(where.eq('_id', objectId));

    return concours;
  }

  static Future<bool> participate(String difficulty, String idConcour) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("concours");
    var objectId = ObjectId.parse(idConcour);

    // Obtenez l'ID de l'utilisateur actuellement connecté
    String userEmail = UserManager.currentUser!.email;

    // Recherchez le document complet
    var concoursDoc = await collection.findOne(where.eq('_id', objectId));

    if (concoursDoc != null) {
      // Obtenez la liste des utilisateurs
      var userList = concoursDoc['userList'] ?? [];

      // Recherchez l'index de l'utilisateur dans la liste
      int userIndex = userList.indexWhere((entry) => entry['userId'] == userEmail);

      if (userIndex != -1) {
        // L'utilisateur est déjà enregistré, mettez à jour la difficulté
        userList[userIndex]['difficulty'] = difficulty;

        // Mettez à jour la liste dans la base de données
        await collection.update(
          where.eq('_id', objectId),
          modify.set('userList', userList),
        );
      } else {
        // L'utilisateur n'est pas encore enregistré, ajoutez-le à la liste
        await collection.update(
          where.eq('_id', objectId),
          modify.push('userList', {
            'userId': userEmail,
            'difficulty': difficulty,
          }),
        );
      }

      return true;
    } else {
      return false; // La compétition n'a pas été trouvée
    }
  }






}