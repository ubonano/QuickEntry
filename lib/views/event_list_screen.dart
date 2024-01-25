import 'package:flutter/material.dart';
import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../widgets/event_list.dart';
import '../widgets/generic_stream_builder.dart';
import 'event_create_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventController _eventController = getIt<EventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: GenericStreamBuilder<List<Event>>(
        stream: _eventController.upcomingEventsStream,
        builder: (context, snapshot) => EventsList(events: snapshot.data!),
        errorMessage: 'Error al cargar los eventos.',
        emptyMessage: 'No hay eventos disponibles.',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EventCreateScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
