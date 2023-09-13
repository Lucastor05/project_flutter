import 'dart:ui';
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
}