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


}