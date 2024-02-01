import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';
import '../views/event_detail_screen.dart';
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
          Text('Estado: ${event.state.value}'),
        ],
      ),
      trailing: _buildTrailingIcons(context, event),
      onTap: () => _navigateToEventDetailsScreen(context, event.id),
    );
  }

  //TODO ver de modificar
  void _navigateToEventDetailsScreen(BuildContext context, String eventId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  Row _buildTrailingIcons(BuildContext context, Event event) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (event.state == EventState.pending)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () =>
                _confirmAction(context, event, _eventController.startEvent),
          ),
        if (event.state == EventState.ongoing)
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () =>
                _confirmAction(context, event, _eventController.endEvent),
          ),
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

  void _confirmAction(
    BuildContext context,
    Event event,
    Function(Event) action,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.state == EventState.pending
              ? "Iniciar Evento"
              : "Finalizar Evento"),
          content: Text(event.state == EventState.pending
              ? "¿Quieres iniciar este evento?"
              : "¿Quieres finalizar este evento?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Confirmar"),
              onPressed: () async {
                await action(event);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
