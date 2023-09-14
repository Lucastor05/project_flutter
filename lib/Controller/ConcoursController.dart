import 'package:project_flutter/Model/ConcoursModel.dart';

class ConcoursController {

  static Future<bool> set(String nom, String adresse, String photo, DateTime date) async {

    if (await ConcoursManager.insertConcour(nom, adresse, photo, date)){
      return true;
    } else {
      print('Erreur lors de l\'insertion de la classe dans la base de données.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> get() async{
    final concours = await ConcoursManager.getAllConcours();
    print(concours);
    return concours;
  }

  static Future<Map<String, dynamic>?> getOne(idConcour) async{
    final concours = await ConcoursManager.getOneConcour(idConcour);
    print(concours);
    return concours;
  }

  static Future<bool> participate(String difficulty, String idConcour) async{
    if(await ConcoursManager.participate(difficulty, idConcour)){
      return true;
    }
    return false;
  }


}