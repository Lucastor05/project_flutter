import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/Model/FeedModel.dart';
import 'package:project_flutter/Controller/Feed_controller.dart';
class Feed extends StatefulWidget {
  const Feed({super.key, required this.title});
  final String title;
  @override
  State<Feed> createState() => _FeedState();
}
class _FeedState extends State<Feed> {
  List<Event> events = [];
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }
  Future<void> _loadEvents() async {
    final eventsList = await EventController.EventRecup();
    setState(() {
      events = eventsList;
      print("HERRRREEE2 -------------->>>> $eventsList");
      print('${EventController.EventRecup()}');
      print('Event Type: ${eventsList?[0].eventType}');
      print('Event Title: ${eventsList?[0].title}');
      print('Event Date: ${eventsList?[0].date}');
      print('-------------------------');
      print('Event ID: ${eventsList?[1].id}');
      print('Event Type: ${eventsList?[1].eventType}');
      print('Event Title: ${eventsList?[1].title}');
      print('Event Date: ${eventsList?[1].date}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(events.isNotEmpty ? events[index].title : 'No Title'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(events.isNotEmpty ? events[index].eventType : 'No Event Type'),
              Text(events.isNotEmpty ? events[index].date.toString() : 'No Date'),
            ],
          ),
        ),
      ),
    );
  }
}