import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final bool showBackButton;

  const EventDetailsScreen(
      {super.key, required this.eventId, this.showBackButton = true});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Future<Event?> _eventFuture;

  @override
  void initState() {
    super.initState();
    _eventFuture = _loadEvent(widget.eventId);
  }

  Future<Event?> _loadEvent(String eventId) async {
    try {
      final EventController eventController = getIt<EventController>();
      return await eventController.getEventById(eventId);
    } catch (e) {
      // Manejo de errores o log
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Evento'),
        automaticallyImplyLeading: widget.showBackButton,
      ),
      body: FutureBuilder<Event?>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Evento no encontrado.'));
          } else {
            return _buildEventDetails(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildEventDetails(Event event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Nombre: ${event.name}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Descripción: ${event.description}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text('Dirección: ${event.address}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text(
              'Fecha y hora de inicio: ${_formatDateTime(event.startDateTime)}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text(
              'Fecha y hora de finalización: ${_formatDateTime(event.endDateTime)}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text('Entradas disponibles: ${event.availableTickets}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text('Estado: ${event.state.value}',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat(
            'd \'de\' MMMM \'del\' yyyy \'a las\' HH:mm \'hs\'', 'es_ES')
        .format(dateTime);
  }
}
