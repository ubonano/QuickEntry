import 'package:flutter/material.dart';

import '../config/get_it_setup.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';
import '../widgets/event_form.dart';

class EventEditScreen extends StatefulWidget {
  final Event event;

  const EventEditScreen({super.key, required this.event});

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final EventController _eventController = getIt<EventController>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _availableTicketsController;
  late DateTime _startDateTime;
  late DateTime _endDateTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _addressController = TextEditingController(text: widget.event.address);
    _availableTicketsController =
        TextEditingController(text: widget.event.availableTickets.toString());
    _startDateTime = widget.event.startDateTime;
    _endDateTime = widget.event.endDateTime;
  }

  @override
  Widget build(BuildContext context) {
    bool isEditable = widget.event.state == EventState.pending;
    return Scaffold(
      appBar: AppBar(title: const Text('Editar evento')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Estado del evento: ${widget.event.state.value}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            EventForm(
              formKey: _formKey,
              fieldsControllers: {
                'name': _nameController,
                'description': _descriptionController,
                'address': _addressController,
                'availableTickets': _availableTicketsController,
              },
              onPickDateTime: isEditable ? _pickDateTime : null,
              onSubmit: isEditable ? _submitForm : null,
              isSubmitting: _isSubmitting,
              startDateTime: _startDateTime,
              endDateTime: _endDateTime,
              isEditable: isEditable,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date =
        await _selectDate(context, isStart ? _startDateTime : _endDateTime);
    final time =
        await _selectTime(context, isStart ? _startDateTime : _endDateTime);

    if (date != null && time != null) {
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      setState(
        () => isStart
            ? _startDateTime = selectedDateTime
            : _endDateTime = selectedDateTime,
      );
    }
  }

  Future<DateTime?> _selectDate(
    BuildContext context,
    DateTime? initialDate,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _selectTime(
    BuildContext context,
    DateTime? initialDateTime,
  ) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        initialDateTime ?? DateTime.now(),
      ),
    );
  }

  void _submitForm() async {
    if (widget.event.state != EventState.pending) {
      _showErrorSnackbar('Solo los eventos pendientes pueden ser modificados');
      return;
    }

    if (!_hasChanges()) {
      _showErrorSnackbar('No se han realizado cambios');
      return;
    }

    if (_formKey.currentState!.validate() && _validateDateTime()) {
      setState(() => _isSubmitting = true);

      final updatedEvent = Event(
        state: widget.event.state,
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        startDateTime: _startDateTime,
        endDateTime: _endDateTime,
        availableTickets: int.tryParse(_availableTicketsController.text) ?? 0,
      );

      try {
        await _eventController.updateEvent(widget.event.id, updatedEvent);
        _showSuccessSnackbar('Evento actualizado con éxito.');

        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();
      } catch (e) {
        _showErrorSnackbar('Error al actualizar el evento');
      }
      setState(() => _isSubmitting = false);
    }
  }

  bool _hasChanges() {
    return _nameController.text != widget.event.name ||
        _descriptionController.text != widget.event.description ||
        _addressController.text != widget.event.address ||
        _availableTicketsController.text !=
            widget.event.availableTickets.toString() ||
        _startDateTime != widget.event.startDateTime ||
        _endDateTime != widget.event.endDateTime;
  }

  bool _validateDateTime() {
    final now = DateTime.now();

    if (_startDateTime.isBefore(now)) {
      _showErrorSnackbar(
          'La fecha de inicio debe ser posterior a la fecha y hora actual.');
      return false;
    }

    if (_endDateTime.isBefore(_startDateTime)) {
      _showErrorSnackbar(
          'La fecha de finalización debe ser posterior a la fecha de inicio.');
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
