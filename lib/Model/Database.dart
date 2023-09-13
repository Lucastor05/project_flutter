import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'Constante.dart';

class Database {
  static late Db _db;

  static Future<void> connect() async {
    try {
      _db = await Db.create(MONGO_URL);
      await _db.open();
      inspect(_db);
      print("Database connected ...");
    } catch (e) {
      print('Erreur lors de la connexion à la base de données : $e');
    }
  }

  static Future<void> insert(String name, String phone, String mail) async {
    if (_db == null || !_db.isConnected) {
      print('La base de données n\'est pas connectée.');
      return;
    }

    try {
      var collection = _db.collection("users");
      await collection.insert({
        'email': name,
        'username': phone,
        'password': mail,
      });
      print("Insert successful !");
    } catch (e) {
      print('Erreur lors de la connexion à la base de données : $e');
    }
  }

  static Future<List<Object>> selectAll() async {
    if (_db == null || !_db.isConnected) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    try {
      var collection = _db.collection("users");
      var contacts = await collection.find().toList();
      return contacts;
    } catch (e) {
      print('Erreur lors de la connexion à la base de données : $e');
      return [];
    }
  }

  static Future<void> close() async {
    if (_db != null && _db.isConnected) {
      await _db.close();
    }
  }
}
