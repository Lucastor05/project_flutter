import 'package:mongo_dart/mongo_dart.dart';
import 'Database.dart';
class Event {
  String id;
  String eventType;
  String title;
  DateTime date;
  Event({
    required this.id,
    required this.eventType,
    required this.title,
    required this.date,
  });
  //Event({required this.event_type, required this.Date, required this.title});
  //Event({required this.event_type, required this.Date, required this.title});
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'].toString(),
      eventType: map['event_type'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }
}
class EventManager {
  static Future<bool> Eventregister(String id, String event_type, DateTime Date, String title) async {
    final db = await Database.connect();
    if (db == null) {
      print('La base de données n\'est pas connectée.');
      return false;
    }
    var collection = db.collection("events");
    bool isRegistered = false; // Initialisez la variable à false
    try {
      await collection.insert({
        'id': id,
        'event_type': event_type,
        'Date': Date,
        'title': title,
      });
      final event = Event(id:id,eventType: event_type, date: Date, title: title);
      isRegistered = true; // Mettez à jour la variable en cas de succès
    } catch (e) {
      print('Erreur lors de l\'insertion dans la base de données : $e');
    }
    return isRegistered; // Renvoyez la variable booléenne
  }
  static Future<List<Event>?> getEvents() async {
    final db = await Database.connect();
    await db?.open();
    final coll = db?.collection('events');
    if (coll != null) {
      final documents = await coll.find().toList();
      print('1');
      print(documents);
      final doc2 = documents.map((document) => Event.fromMap(document)).toList();
      //print(documents.map((document) => Event.fromMap(document)).toList());
      print('doc2');
      for(var x=1;x<doc2.length;x++) {
        for (var event in doc2) {
          print('Event ID: ${event.id}');
          print('Event Type: ${event.eventType}');
          print('Event Title: ${event.title}');
          print('Event Date: ${event.date}');
          print('-------------------------');
        }
      }
      return doc2;
    }
  }
}


