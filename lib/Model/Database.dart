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
      print("Connected to database ...");
    } catch (e) {
      print('Connection error : $e');
    }
  }

  static Future<void> close() async {
    if (_db != null && _db.isConnected) {
      await _db.close();
    }
  }
}
