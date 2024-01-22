import 'package:flutter/material.dart';

import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../widgets/event_form.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final EventController _eventController = getIt<EventController>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _availableTicketsController = TextEditingController();
  DateTime? _startDateTime;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear evento')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EventForm(
          formKey: _formKey,
          fieldsControllers: {
            'name': _nameController,
            'description': _descriptionController,
            'address': _addressController,
            'availableTickets': _availableTicketsController,
          },
          onPickDateTime: _pickDateTime,
          onSubmit: _submitForm,
          isSubmitting: _isSubmitting,
          startDateTime: _startDateTime,
        ),
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await _selectDate(context, _startDateTime);
    final time = await _selectTime(context, _startDateTime);

    if (date != null && time != null) {
      final selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      setState(() => _startDateTime = selectedDateTime);
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
      initialTime: TimeOfDay.fromDateTime(
        initialDateTime ?? DateTime.now(),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _validateDateTime()) {
      setState(() => _isSubmitting = true);
      final event = Event(
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        startDateTime: _startDateTime!,
        availableTickets: int.tryParse(_availableTicketsController.text) ?? 0,
      );

      try {
        await _eventController.createEvent(event);
        _showSuccessSnackbar('Evento creado con éxito.');

        await Future.delayed(const Duration(seconds: 2));

        Navigator.of(context).pop();
      } catch (e) {
        _showErrorSnackbar('Error al crear el evento');
        print(e.toString()); // TODO Cambiar por algun login
      }
      setState(() => _isSubmitting = false);
    }
  }

  bool _validateDateTime() {
    final now = DateTime.now();
    if (_startDateTime == null) {
      _showErrorSnackbar(
          'Por favor, selecciona la fecha y hora de inicio del evento.');
      return false;
    }
    if (_startDateTime!.isBefore(now)) {
      _showErrorSnackbar(
          'La fecha de inicio debe ser posterior a la fecha y hora actual.');
      return false;
    }
    return true;
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
