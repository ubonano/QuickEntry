import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_entry/views/event_edit_screen.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;

  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventTile(context, event, eventController);
      },
    );
  }

  ListTile _buildEventTile(
      BuildContext context, Event event, EventController eventController) {
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
      trailing: _buildTrailingIcons(context, event, eventController),
      onTap: () => Get.toNamed('/event/${event.id}'),
    );
  }

  Row _buildTrailingIcons(
      BuildContext context, Event event, EventController eventController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (event.state == EventState.pending)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () =>
                _confirmAction(context, event, eventController.startEvent),
          ),
        if (event.state == EventState.ongoing)
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () =>
                _confirmAction(context, event, eventController.endEvent),
          ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Get.to(EventEditScreen(event: event)),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDeletion(context, event, eventController),
        ),
      ],
    );
  }

  void _confirmAction(
      BuildContext context, Event event, Function(Event) action) {
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
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text("Confirmar"),
              onPressed: () async {
                await action(event);
                Get.back();
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

  void _confirmDeletion(
      BuildContext context, Event event, EventController eventController) {
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
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text("Eliminar"),
              onPressed: () async {
                await eventController.deleteEvent(event.id);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
