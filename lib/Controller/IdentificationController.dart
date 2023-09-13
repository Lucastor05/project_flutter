import 'package:project_flutter/Model/UserModel.dart';

class IdentificationController {

  static bool RegisterUser(String email, String username,String password){
    try{
      User.register(email, username, password);
      return true;
    } catch (e) {
      print('Erreur lors de l\'insertion dans la base de données : $e');
      return false;
    }

  }

  static Future<bool> login(String username,String password) async{
    if(await User.login(username, password)){
      return true;
    } else {
      print('Erreur lors du login');
      return false;
    }
  }

  static Future<bool> changePassword(String email,String username, String password) async{
    bool userIsChecked = await User.checkUser(email, username);

    if(userIsChecked){
      User.changePassword(email, username, password);
      return true;
    } else {
      print('Erreur lors du changement de mot de passe');
      return false;
    }
  }


}