import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../views/event_edit_screen.dart';

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
        return _buildEventTile(context, event);
      },
    );
  }

  ListTile _buildEventTile(BuildContext context, Event event) {
    final formattedStartDateTime = _formatDateTime(event.startDateTime);
    final formattedEndDateTime = _formatDateTime(event.endDateTime);

    return ListTile(
      title: Text(event.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.description),
          Text('Inicio: $formattedStartDateTime'),
          Text('Finalización: $formattedEndDateTime'),
          Text('Entradas totales: ${event.availableTickets}'),
        ],
      ),
      trailing: _buildTrailingIcons(context, event),
    );
  }

  Row _buildTrailingIcons(BuildContext context, Event event) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _navigateToEditScreen(context, event),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDeletion(context, event),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('d \'de\' MMMM \'del\' y \'a las\' HH:mm \'hs\'', 'es_ES')
        .format(dateTime);
  }

  void _navigateToEditScreen(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EventEditScreen(event: event)),
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
              onPressed: () => Navigator.of(context).pop(),
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
