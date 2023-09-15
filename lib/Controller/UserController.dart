import 'package:project_flutter/Model/UserModel.dart';

class UserController {

  static Future<bool> RegisterUser(String email, String username, String password, String profilePicture) async {

    if (await UserManager.register(email, username, password, profilePicture)) {
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion dans la base de données');
      return false;
    }
  }

  static Future<bool> login(String username,String password) async{
    if(await UserManager.loginUserWithCredentials(username, password)){
      return true;
    } else {
      print('Erreur lors du login');
      return false;
    }
  }

  static Future<bool> changePassword(String email,String username, String password) async{
    bool userIsChecked = await UserManager.checkUser(email, username);

    if(userIsChecked){
      UserManager.changePassword(email, username, password);
      return true;
    } else {
      print('Erreur lors du changement de mot de passe');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getFromEmail(String email) async {
    return await UserManager.getFromEmail(email);
  }

  static Future<List<Map<String, dynamic>>> getFromUsername(String username) async {
    return await UserManager.getFromUsername(username);
  }

  static Future<bool> deleteFromEmail(String email) async {
    if(await UserManager.deleteFromEmail(email)){
      return true;
    }
    return false;
  }

  static void logout(){
    UserManager.logoutUser();
  }


  static Future<List<Map<String, dynamic>>> get() async {
    return await UserManager.get();
  }

  static bool isGerant(){
    return UserManager.currentUser?.role == "Gérant";
  }

  static User? getCurrentUser(){
    return UserManager.currentUser;
  }

  static Future<bool> updateUser(String photoPath, String name, int age, String email, String phone) async{
    if (await UserManager.updateUser(photoPath,name, age, email, phone)){
    // Connecte automatiquement l'utilisateur après son inscription réussie
    return true;
    } else {
    print('Erreur lors de l\'insertion de la classe dans la base de données.');
    return false;
    }
  }


}