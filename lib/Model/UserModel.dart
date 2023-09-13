import 'dart:ui';
import 'Database.dart';

class User{
  static late String _email;
  static late String _password;
  static late String _username;
  static late Image _profilePicture;

  User(String email, String username, String password, Image profilePicture){
    _email = email;
    _username = username;
    _password = password;
    _profilePicture = profilePicture;
  }

  /*static Future<void> insert(String email, String username, String password, Image profilePicture) async {
    final db = Database();
    if (db == null || !db.isConnected) {
      print('La base de données n\'est pas connectée.');
      return;
    }

    try {
      var collection = _db.collection("users");
      await collection.insert({
        'email': email,
        'username': username,
        'password': password,
        'profilePicture': profilePicture,
      });

      User(email, username, password, profilePicture);
      print("Insert successful !");
    } catch (e) {
      print('Erreur lors de la connexion à la base de données : $e');
    }
  }*/

}