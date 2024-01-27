import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventForm extends StatelessWidget {
  const EventForm({
    Key? key,
    required this.formKey,
    required this.fieldsControllers,
    this.onPickDateTime,
    this.onSubmit,
    this.startDateTime,
    this.endDateTime,
    required this.isSubmitting,
    this.isEditable = true,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> fieldsControllers;
  final Function(bool)? onPickDateTime;
  final VoidCallback? onSubmit;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final bool isSubmitting;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildTextFormField(
              fieldsControllers['name']!,
              'Nombre',
              'Por favor ingrese un nombre',
            ),
            _buildTextFormField(
              fieldsControllers['description']!,
              'Descripción',
              'Por favor ingrese una descripcion',
            ),
            _buildTextFormField(
              fieldsControllers['address']!,
              'Dirección',
              'Por favor ingrese una dirección',
            ),
            _buildDateTimePicker(
              'Fecha y hora de inicio:',
              startDateTime,
              isEditable ? () => onPickDateTime!(true) : null,
            ),
            _buildDateTimePicker(
              'Fecha y hora de finalización:',
              endDateTime,
              isEditable ? () => onPickDateTime!(false) : null,
            ),
            _buildTextFormField(
              fieldsControllers['availableTickets']!,
              'Entradas disponible',
              'Por favor ingrese un numero valido',
              keyboardType: TextInputType.number,
              validator: _validateTickets,
            ),
            const SizedBox(height: 20),
            isSubmitting
                ? const CircularProgressIndicator()
                : isEditable
                    ? ElevatedButton(
                        onPressed: onSubmit,
                        child: const Text('Guardar'),
                      )
                    : const SizedBox.shrink(),
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
      enabled: isEditable, // Deshabilitar si no es editable
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
    String label,
    DateTime? selectedDate,
    VoidCallback? onTap,
  ) {
    return ListTile(
      title: Text(
          '$label ${selectedDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate) : ''}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap, // Deshabilitar si no es editable
    );
  }
}
