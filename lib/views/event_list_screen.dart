import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../widgets/event_list.dart';
import 'event_create_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<EventController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: Obx(() {
        if (eventController.pendingAndOngoingEvents.isEmpty) {
          return const Center(child: Text('No hay eventos disponibles.'));
        }
        return EventsList(events: eventController.pendingAndOngoingEvents);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => EventCreateScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
