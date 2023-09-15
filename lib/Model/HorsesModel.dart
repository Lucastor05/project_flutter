import 'package:mongo_dart/mongo_dart.dart';

import 'Database.dart';
import 'UserModel.dart';

class HorsesManager {

  static Future<bool> insertHorse(String photoPath, String nom, int age, String robe, String race, String sexe, List<String> specialite) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("cheveaux");

    try {
      await collection.insertOne({
        'photo': photoPath,
        'nom': nom,
        'age': age,
        'robe': robe,
        'race': race,
        'sexe': sexe,
        'specialite': specialite,
        'proprietaire': UserManager.currentUser!.username
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> updateHorse(String photoPath, String nom, int age, String robe, String race, String sexe, List<String> specialite, String id) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("cheveaux");

    try {
      /*{
          'photo': photoPath,
          'nom': nom,
          'age': age,
          'robe': robe,
          'race': race,
          'sexe': sexe,
          'specialite': specialite,
          'proprietaire': UserManager.currentUser!.username
        }*/
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('nom', nom),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('age', age),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('robe', robe),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('race', race),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('sexe', sexe),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('specialite', specialite),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('proprietaire', UserManager.currentUser!.username),
      );
      await collection.updateOne(
        where.id(ObjectId.parse(id)), // Utilisez where.id pour spécifier l'ID du document à mettre à jour
        modify.set('photo', photoPath),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  static Future<List<Map<String, dynamic>>> getAllHorses() async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("cheveaux");
    var cours = await collection.find().toList();
    return cours;
  }


  static Future<bool> deleteFromId(String id) async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("cheveaux");
    var objectId = ObjectId.parse(id);

    try {
      await collection.remove(where.eq('_id', objectId));
      print("Le chheval a été supprimé");
      return true;
    } catch (e){
      print("Erreur lors de la suppression : $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getOneHorse(String idConcour) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return null;
    }

    var collection = db.collection("cheveaux");
    var objectId = ObjectId.parse(idConcour);
    var concours = await collection.findOne(where.eq('_id', objectId));

    return concours;
  }

  static Future<void> updateHorseOwner(String oldOwnerUsername, String newOwnerUsername) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return;
    }

    var collection = db.collection("cheveaux");

    try {
      await collection.updateMany(
        where.eq('proprietaire', oldOwnerUsername), // Sélectionnez tous les chevaux de l'ancien propriétaire
        modify.set('proprietaire', newOwnerUsername), // Mettez à jour le propriétaire avec le nouveau email
      );
    } catch (e) {
      print(e);
    }
  }
}