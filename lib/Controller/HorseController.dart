import 'package:project_flutter/Model/HorsesModel.dart';

class HorseController {

  static Future<bool> set(String photoPath, String nom, int age, String robe, String race, String sexe, List<String> specialite) async {

    if (await HorsesManager.insertHorse(photoPath,nom, age, robe, race, sexe, specialite)){
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion de la classe dans la base de données.');
      return false;
    }
  }

  static Future<bool> update(String photoPath, String nom, int age, String robe, String race, String sexe, List<String> specialite, String id) async {

    if (await HorsesManager.updateHorse(photoPath,nom, age, robe, race, sexe, specialite, id)){
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion de la classe dans la base de données.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> get() async{
    final cours = await HorsesManager.getAllHorses();
    return cours;
  }



  static Future<bool> deleteHorse(String idHorse) async{
    if(await HorsesManager.deleteFromId(idHorse)){
      return true;
    }else{
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getOne(idConcour) async{
    final horse = await HorsesManager.getOneHorse(idConcour);
    print(horse);
    return horse;
  }

  static Future<void> updateOwner(String oldUsername, String newUsername) async {
    await HorsesManager.updateHorseOwner(oldUsername, newUsername);
  }

}