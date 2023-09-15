import 'package:flutter/cupertino.dart';
import 'package:project_flutter/Model/night_model.dart';
import 'dart:io';

class NightController {

  static Future<bool> set(String name, String comment, DateTime date, String photo) async {

    if (await NightManager.insertClasse(name, comment, date, photo)){
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion de la classe dans la base de données.');
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
    print(soirees);
    return soirees;
  }

  static Future<bool> participate(String idSoiree) async{
    if(await NightManager.participate( idSoiree)){
      return true;
    }
    return false;
  }

/*'comment': comment,
        'date': date,
        'photo': photo,
        'userList': userList,*/
}