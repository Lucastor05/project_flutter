import 'package:mongo_dart/mongo_dart.dart';
import 'package:project_flutter/Controller/HorseController.dart';
import 'Database.dart';

class User {
  late String email;
  late String username;
  late String password;
  late String profilePicture;
  late String role;
  late String phone;
  late int? age;


  User({required this.role, required this.email, required this.username, required this.password, required this.profilePicture, required this.phone, required this.age});
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

    // Vérifiez d'abord si un utilisateur avec le même email ou le même nom d'utilisateur existe déjà
    if (await UserManager.checkUser(email, username)) {
      print('Un utilisateur avec le même email ou nom d\'utilisateur existe déjà.');
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
        'phone': "",
        'age': null,
        'role': 'Cavalier'
      });

      final user = User(role: "Cavalier",email: email, username: username, password: password, profilePicture: profilePicturePath, phone: "", age: null);
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
        role: result['role'],
        email: result['email'],
        username: result['username'],
        password: result['password'],
        profilePicture: result['profilePicture'],
        phone: result['phone'],
        age: result['age'],
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

  static Future<List<Map<String, dynamic>>> get() async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("users");
    var users = await collection.find().toList();
    return users;
  }

  static Future<List<Map<String, dynamic>>> getFromEmail(String email) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("users");
    var user = await collection.find(where.eq('email', email)).toList();
    return user;
  }

  static Future<List<Map<String, dynamic>>> getFromUsername(String username) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return [];
    }

    var collection = db.collection("users");
    var user = await collection.find(where.eq('username', username)).toList();
    return user;
  }

  static Future<bool> deleteFromEmail(String email) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    if(email == currentUser!.email){
      return false;
    }

    var collection = db.collection("users");
    try {
      await collection.remove(where.eq('email', email));
      print("L'utilisateur a été supprimé");
      return true;
    } catch (e){
      print("Erreur lors de la suppression : $e");
      return false;
    }
  }

  static Future<bool> updateUser(String photoPath, String name, int? age, String email, String phone) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }

    var collection = db.collection("users");

    try {
      await collection.update(
        where.eq('email',  _currentUser!.email), // Utilisez where.eq pour spécifier le champ à mettre à jour
        modify.set('username', name),
      );
      await collection.update(
        where.eq('email', _currentUser!.email), // Utilisez where.eq pour spécifier le champ à mettre à jour
        modify.set('email', email),
      );
      await collection.update(
        where.eq('email',  _currentUser!.email), // Utilisez where.eq pour spécifier le champ à mettre à jour
        modify.set('age', age),
      );
      await collection.update(
        where.eq('email',  _currentUser!.email), // Utilisez where.eq pour spécifier le champ à mettre à jour
        modify.set('phone', phone),
      );
      await collection.update(
        where.eq('email',  _currentUser!.email), // Utilisez where.eq pour spécifier le champ à mettre à jour
        modify.set('profilePicture', photoPath),
      );

      HorseController.updateOwner(_currentUser!.username, name);

      // Mettez à jour la session de l'utilisateur
      _currentUser?.username = name;
      _currentUser?.email = email;
      _currentUser?.age = age;
      _currentUser?.phone = phone;
      _currentUser?.profilePicture = photoPath;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
