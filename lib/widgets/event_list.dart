import 'package:flutter/material.dart';

import '../models/event.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;

  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.name),
          subtitle: Text(event.description),
        );
      },
    );
  }
}
