import 'package:project_flutter/Model/NightModel.dart';

class NightController {

  static Future<bool> set(String name, DateTime date, String photo) async {

    if (await NightManager.insertClasse(name, date, photo)){
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion de la classe dans la base de données.');
      return false;
    }
  }

  static Future<bool> deleteSoiree(String id) async{
    if(await NightManager.deleteFromId(id)){
      return true;
    }else{
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> get() async{
    final night = await NightManager.getAllNight();
    print(night);
    return night;
  }

  static Future<Map<String, dynamic>?> getOne(idSoiree) async{
    final soirees = await NightManager.getOneSoiree(idSoiree);
    return soirees;
  }

  static Future<bool> participate(String idSoiree, String comment) async{
    if(await NightManager.participate( idSoiree, comment)){
      return true;
    }
    return false;
  }
}