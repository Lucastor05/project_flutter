import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'UserModel.dart';
import 'Database.dart';

class NightManager {

  static Future<bool> insertClasse(String name, String comment, DateTime date, String photo) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("soiree");

    try {
      await collection.insertOne({
        'name':name,
        'comment': comment,
        'date': date,
        'photo': photo,
        'userList': [],


      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllNight() async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("soiree");
    var night = await collection.find().toList();
    return night;
  }

  static Future<Map<String, dynamic>?> getOneSoiree(String idSoiree) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return null;
    }

    var collection = db.collection("soiree");
    var objectId = ObjectId.parse(idSoiree);
    var soirees = await collection.findOne(where.eq('_id', objectId));

    return soirees;
  }

  static Future<bool> participate(String idSoiree) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("soiree");
    var objectId = ObjectId.parse(idSoiree);

    // Obtenez l'ID de l'utilisateur actuellement connecté
    String userEmail = UserManager.currentUser!.email;

    // Recherchez le document complet
    var soireesDoc = await collection.findOne(where.eq('_id', objectId));

    if (soireesDoc != null) {
      // Obtenez la liste des utilisateurs
      var userList = soireesDoc['userList'] ?? [];

      // Recherchez l'index de l'utilisateur dans la liste
      int userIndex = userList.indexWhere((entry) => entry['userId'] == userEmail);

      if (userIndex != -1) {
        // L'utilisateur est déjà enregistré, mettez à jour la difficulté


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

          }),
        );
      }

      return true;
    } else {
      return false; // La compétition n'a pas été trouvée
    }
  }





}