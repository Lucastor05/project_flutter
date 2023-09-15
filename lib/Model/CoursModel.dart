import 'package:mongo_dart/mongo_dart.dart';

import 'Database.dart';

class CoursManager {

  static Future<bool> insertClasse(String terrain, DateTime date, String duree, String discipline) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("cours");

    try {
      await collection.insertOne({
        'terrain': terrain,
        'date': date,
        'duree': duree,
        'discipline': discipline,
        'isValidated': false,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> validate(String id) async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    try{
      var collection = db.collection("cours");
      await collection.updateOne(where.eq("_id", ObjectId.parse(id)), modify.set("isValidated", true));
      return true;
    } catch (e){
      print("Erreur lors de la validation : $e");
      return false;
    }

  }

  static Future<List<Map<String, dynamic>>> getAllCours() async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("cours");
    var cours = await collection.find().toList();
    return cours;
  }

  static Future<bool> deleteFromId(String id) async{
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("cours");
    var objectId = ObjectId.parse(id);

    try {
      await collection.remove(where.eq('_id', objectId));
      print("Le cour a été supprimé");
      return true;
    } catch (e){
      print("Erreur lors de la suppression : $e");
      return false;
    }
  }
}