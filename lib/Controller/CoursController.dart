import 'package:project_flutter/Model/CoursModel.dart';

class CoursController {

  static Future<bool> set(String terrain, DateTime date, String duree, String discipline) async {

    if (await CoursManager.insertClasse(terrain, date, duree, discipline)){
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion de la classe dans la base de données.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> get() async{
    final cours = await CoursManager.getAllCours();
    return cours;
  }

  static Future<bool> deleteCours(String id) async{
    if(await CoursManager.deleteFromId(id)){
      return true;
    }else{
      return false;
    }
  }



}