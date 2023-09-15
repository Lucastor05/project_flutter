import 'dart:ffi';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:project_flutter/Model/FeedModel.dart';
import 'dart:io';

class EventController {
/*final String id;
  final String event_type;
  final String Date;
  final String title;*/

  static Future<bool> RegisterEvent( String id, String event_type, DateTime Date,String title) async {
    //return true;
    if (await EventManager.Eventregister(id,event_type, Date, title)) {
      // Connecte automatiquement l'utilisateur après son inscription réussie
      return true;
    } else {
      print('Erreur lors de l\'insertion dans la base de données');
      return false;
    }
  }

  static Future<List<Event>> EventRecup() async{
      final events = await EventManager.getEvents();
      print("HERRRREEE -------------->>>> $events");
      print('Event ID: ${events?[0].id}');
      print('Event Type: ${events?[0].eventType}');
      print('Event Title: ${events?[0].title}');
      print('Event Date: ${events?[0].date}');
      print('-------------------------');
      print('Event ID: ${events?[1].id}');
      print('Event Type: ${events?[1].eventType}');
      print('Event Title: ${events?[1].title}');
      print('Event Date: ${events?[1].date}');

      return [];
  }
  /*void main() {
  var data = "2021-12-15T11:10:01.521Z";

  DateTime dateTime = getFormattedDateFromFormattedString(
      value: data,
      currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
      desiredFormat: "yyyy-MM-dd HH:mm:ss");

  print(dateTime); //2021-12-15 11:10:01.000
}

getFormattedDateFromFormattedString(
    {required value,
    required String currentFormat,
    required String desiredFormat,
    isUtc = false}) {
  DateTime? dateTime = DateTime.now();
  if (value != null || value.isNotEmpty) {
    try {
      dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
    } catch (e) {
      print("$e");
    }
  }
  return dateTime;
}*/
}