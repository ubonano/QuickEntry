import 'package:flutter/material.dart';

import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;
  final EventController _eventController = getIt<EventController>();

  EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.name),
          subtitle: Text(event.description),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDeletion(context, event),
          ),
        );
      },
    );
  }

  void _confirmDeletion(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: Text(
              "¿Estás seguro de querer eliminar el evento '${event.name}'?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Eliminar"),
              onPressed: () {
                _eventController.deleteEvent(event.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
