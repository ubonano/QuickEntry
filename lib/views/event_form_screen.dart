import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFormScreen extends StatefulWidget {
  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _availableTicketsController = TextEditingController();
  DateTime? _startDateTime;
  DateTime? _endDateTime;

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
            'availableTickets': _availableTicketsController
          },
          onPickDateTime: _pickDateTime,
          onSubmit: _validateAndSubmit,
          startDateTime: _startDateTime,
          endDateTime: _endDateTime,
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
      final selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      setState(() => isStart
          ? _startDateTime = selectedDateTime
          : _endDateTime = selectedDateTime);
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

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate() && _validateDateTime()) {
      // Aquí puedes manejar los datos del formulario
      print(
          'Form data: ${_nameController.text}, ${_descriptionController.text}, ${_addressController.text}, $_startDateTime, $_endDateTime, ${_availableTicketsController.text}');
    }
  }

  bool _validateDateTime() {
    if (_startDateTime == null || _endDateTime == null) {
      _showErrorSnackbar(
          'Por favor, selecciona las fechas de inicio y finalización del evento.');
      return false;
    }
    if (_endDateTime!.isBefore(_startDateTime!)) {
      _showErrorSnackbar(
          'La fecha de finalización debe ser posterior a la fecha de inicio.');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}

class EventForm extends StatelessWidget {
  const EventForm({
    Key? key,
    required this.formKey,
    required this.fieldsControllers,
    required this.onPickDateTime,
    required this.onSubmit,
    this.startDateTime,
    this.endDateTime,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> fieldsControllers;
  final Function(bool) onPickDateTime;
  final VoidCallback onSubmit;
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildTextFormField(fieldsControllers['name']!, 'Nombre',
                'Por favor ingrese un nombre'),
            _buildTextFormField(fieldsControllers['description']!,
                'Descripción', 'Por favor ingrese una descripcion'),
            _buildTextFormField(fieldsControllers['address']!, 'Dirección',
                'Por favor ingrese una dirección'),
            _buildDateTimePicker('Fecha y hora de inicio:', startDateTime,
                () => onPickDateTime(true)),
            _buildDateTimePicker('Fecha y hora de finalización:', endDateTime,
                () => onPickDateTime(false)),
            _buildTextFormField(
              fieldsControllers['availableTickets']!,
              'Entradas disponible',
              'Por favor ingrese un numero valido',
              keyboardType: TextInputType.number,
              validator: _validateTickets,
            ),
            ElevatedButton(onPressed: onSubmit, child: const Text('Crear')),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label,
    String errorMessage, {
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: validator ??
          (value) => (value == null || value.isEmpty) ? errorMessage : null,
    );
  }

  String? _validateTickets(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un numero valido';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Por favor ingrese un numero mayor a 0';
    }
    return null;
  }

  Widget _buildDateTimePicker(
      String label, DateTime? selectedDate, VoidCallback onTap) {
    return ListTile(
      title: Text(
          '$label ${selectedDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate) : ''}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap,
    );
  }
}
