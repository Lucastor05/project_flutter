import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'Constante.dart';

class Database {
  static Db? _db;

  static Future<Db?> connect() async {
    try {
      _db = await Db.create(MONGO_URL);
      await _db!.open();
      inspect(_db);
      print("Connected to database ...");
      return _db;
    } catch (e) {
      print('Connection error : $e');
      return null;
    }
  }
}
