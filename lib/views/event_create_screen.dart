import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_entry/utils/event_state_enum.dart';

import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../widgets/event_form.dart';

class EventCreateScreen extends StatelessWidget {
  EventCreateScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final EventController _eventController = Get.find<EventController>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _availableTicketsController = TextEditingController();
  final Rx<DateTime?> _startDateTime = Rx<DateTime?>(null);
  final Rx<DateTime?> _endDateTime = Rx<DateTime?>(null);
  final RxBool _isSubmitting = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear evento')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => EventForm(
              formKey: _formKey,
              fieldsControllers: {
                'name': _nameController,
                'description': _descriptionController,
                'address': _addressController,
                'availableTickets': _availableTicketsController,
              },
              onPickDateTime: _pickDateTime,
              onSubmit: _isSubmitting.value ? null : _submitForm,
              isSubmitting: _isSubmitting.value,
              startDateTime: _startDateTime.value,
              endDateTime: _endDateTime.value,
            )),
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await _selectDate(
        Get.context!, isStart ? _startDateTime.value : _endDateTime.value);
    final time = await _selectTime(
        Get.context!, isStart ? _startDateTime.value : _endDateTime.value);

    if (date != null && time != null) {
      final selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      isStart
          ? _startDateTime.value = selectedDateTime
          : _endDateTime.value = selectedDateTime;
    }
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _selectTime(
      BuildContext context, DateTime? initialDateTime) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _validateDateTime()) {
      _isSubmitting.value = true;
      final event = Event(
        state: EventState.pending,
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        startDateTime: _startDateTime.value!,
        endDateTime: _endDateTime.value!,
        availableTickets: int.tryParse(_availableTicketsController.text) ?? 0,
      );

      try {
        await _eventController.createEvent(event);
        _showSuccessSnackbar('Evento creado con éxito.');

        await Future.delayed(const Duration(seconds: 2));

        Get.back();
      } catch (e) {
        _showErrorSnackbar('Error al crear el evento');
        print(e.toString()); // TODO Cambiar por algun login
      }
      _isSubmitting.value = false;
    }
  }

  bool _validateDateTime() {
    final now = DateTime.now();
    if (_startDateTime.value == null || _endDateTime.value == null) {
      _showErrorSnackbar(
          'Por favor, selecciona las fechas de inicio y finalización del evento.');
      return false;
    }
    if (_startDateTime.value!.isBefore(now)) {
      _showErrorSnackbar(
          'La fecha de inicio debe ser posterior a la fecha y hora actual.');
      return false;
    }
    if (_endDateTime.value!.isBefore(_startDateTime.value!)) {
      _showErrorSnackbar(
          'La fecha de finalización debe ser posterior a la fecha de inicio.');
      return false;
    }
    return true;
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar('Éxito', message,
        backgroundColor: Colors.green, duration: const Duration(seconds: 2));
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, duration: const Duration(seconds: 2));
  }
}
