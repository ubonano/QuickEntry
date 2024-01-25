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

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  final EventController _eventController = getIt<EventController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'En Curso'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsList(
            _eventController.pendingEventsStream,
            'No hay eventos pendientes disponibles.',
          ),
          _buildEventsList(
            _eventController.ongoingEventsStream,
            'No hay eventos en curso disponibles.',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EventCreateScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventsList(Stream<List<Event>> stream, String emptyMessage) {
    return GenericStreamBuilder<List<Event>>(
      stream: stream,
      builder: (context, snapshot) => EventsList(events: snapshot.data!),
      errorMessage: 'Error al cargar los eventos.',
      emptyMessage: emptyMessage,
    );
  }
}
