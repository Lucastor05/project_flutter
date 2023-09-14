import 'package:project_flutter/Model/UserModel.dart';
import 'dart:io';

class IdentificationController {

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


}