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
      });
      return true;
    } catch (e) {
      print(e);
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
}