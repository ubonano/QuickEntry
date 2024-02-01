import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';
import '../widgets/event_form.dart';

class EventEditScreen extends StatelessWidget {
  final Event event;

  const EventEditScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final EventController eventController = Get.find<EventController>();
    bool isEditable = event.state == EventState.pending;

    TextEditingController nameController =
        TextEditingController(text: event.name);
    TextEditingController descriptionController =
        TextEditingController(text: event.description);
    TextEditingController addressController =
        TextEditingController(text: event.address);
    TextEditingController availableTicketsController =
        TextEditingController(text: event.availableTickets.toString());

    DateTime startDateTime = event.startDateTime;
    DateTime endDateTime = event.endDateTime;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar evento')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Estado del evento: ${event.state.value}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            EventForm(
              formKey: _formKey,
              fieldsControllers: {
                'name': nameController,
                'description': descriptionController,
                'address': addressController,
                'availableTickets': availableTicketsController,
              },
              onPickDateTime: isEditable
                  ? (bool isStart) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: isStart ? startDateTime : endDateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            isStart ? startDateTime : endDateTime),
                      );
                      if (date != null && time != null) {
                        return DateTime(date.year, date.month, date.day,
                            time.hour, time.minute);
                      }
                    }
                  : null,
              onSubmit: isEditable
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedEvent = Event(
                          id: event.id,
                          state: event.state,
                          name: nameController.text,
                          description: descriptionController.text,
                          address: addressController.text,
                          startDateTime: startDateTime,
                          endDateTime: endDateTime,
                          availableTickets:
                              int.tryParse(availableTicketsController.text) ??
                                  0,
                        );

                        await eventController.updateEvent(
                            event.id, updatedEvent);

                        Get.back();
                      }
                    }
                  : null,
              isSubmitting: false,
              startDateTime: startDateTime,
              endDateTime: endDateTime,
              isEditable: isEditable,
            ),
          ],
        ),
      ),
    );
  }
}
