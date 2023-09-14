import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';

import 'Database.dart';

class User {
  late String email;
  late String username;
  late String password;
  late String profilePicture;

  User({required this.email, required this.username, required this.password, required this.profilePicture});
}

class UserManager {
  static User? _currentUser; // Utilisateur actuellement connecté

  // Vérifie si un utilisateur est connecté
  static bool get isLoggedIn => _currentUser != null;

  // Récupère l'utilisateur actuellement connecté
  static User? get currentUser => _currentUser;

  // Connecte un utilisateur
  static void loginUser(User user) {
    _currentUser = user;
  }

  // Déconnecte l'utilisateur
  static Future<void> logoutUser() async {
    _currentUser = null;
  }

// Vérifie si l'email et le nom d'utilisateur existent déjà dans la base de données
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

  // Enregistre un nouvel utilisateur dans la base de données
  static Future<bool> register(String email, String username, String password, String profilePicturePath) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("users");
    bool isRegistered = false; // Initialisez la variable à false

    try {
      await collection.insert({
        'email': email,
        'username': username,
        'password': password,
        'profilePicture': profilePicturePath,
      });


      final user = User(email: email, username: username, password: password, profilePicture: profilePicturePath);
      UserManager.loginUser(user);

      isRegistered = true; // Mettez à jour la variable en cas de succès
    } catch (e) {
      print('Erreur lors de l\'insertion dans la base de données : $e');
    }

    return isRegistered; // Renvoyez la variable booléenne
  }

  // Connecte un utilisateur avec son nom d'utilisateur et son mot de passe
  static Future<bool> loginUserWithCredentials(String username, String password) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    final collection = db.collection("users");
    final result = await collection.findOne(where.eq('username', username).eq('password', password));

    if (result != null) {


      final user = User(
        email: result['email'],
        username: result['username'],
        password: result['password'],
        profilePicture: result['profilePicture'],
      );

      loginUser(user); // Connecte l'utilisateur après la connexion réussie
      return true;
    }
    return false; // Aucun utilisateur trouvé avec les informations de connexion fournies
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
