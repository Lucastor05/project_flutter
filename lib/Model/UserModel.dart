import 'dart:ui';
import 'package:mongo_dart/mongo_dart.dart';

import 'Database.dart';

class User {
  static late String _email;
  static late String _password;
  static late String _username;
  static late Image _profilePicture;
  static bool _isConnected = false;

  User(String email, String username, String password) {
    _email = email;
    _username = username;
    _password = password;
    //_profilePicture = profilePicture;
    _isConnected = true;
  }

  bool get isConnected => _isConnected;

  static List getUserInfo(){
    return [_email, _username, _password];
  }

  static Future<void> register(String email, String username, String password) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return;
    }

    var collection = db.collection("users");
    await collection.insert({
      'email': email,
      'username': username,
      'password': password,
      //'profilePicture': profilePicture.toString(),
    });

    User(email, username, password);
  }

  static Future<bool> login(String username, String password) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("users");
    var users = await collection.find().toList();
    bool login = false;

    users.forEach((element) {
      if (element['username'] == username && element['password'] == password) {
        User(element['email'], element['username'], element['password']);
        login = true;
      }
    });

    if(login) {
      return true;
    } else {
      return false;
    }

  }

  static Future<void> logout() async {
    _email = '';
    _username = '';
    _password = '';
    _isConnected = false;
  }

  static Future<bool> checkUser(String email, String username) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("users");
    var users = await collection.find().toList();
    bool check = false;

    users.forEach((element) {
      if (element['email'] == email && element['username'] == username) {
        check = true;
      }
    });

    if(check) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> changePassword(String email, String username, String password) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("users");
    try {
      await collection.update(where.eq('email', email), modify.set('password', password));
      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour de la base de données : $e');
      return false;
    }

  }
}