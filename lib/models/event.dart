import 'package:quick_entry/utils/event_state_enum.dart';

class Event {
  String id;
  EventState state;
  String name;
  String description;
  String address;
  DateTime startDateTime;
  DateTime endDateTime;
  int availableTickets;

  Event({
    this.id = '',
    required this.state,
    required this.name,
    required this.description,
    required this.address,
    required this.startDateTime,
    required this.endDateTime,
    required this.availableTickets,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'state': state.value,
      'description': description,
      'address': address,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'availableTickets': availableTickets,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      state: EventState.values.firstWhere(
        (e) => e.value == map['estado'],
        orElse: () =>
            EventState.pending, // Valor por defecto en caso de no coincidencia
      ),
      name: map['name'],
      description: map['description'],
      address: map['address'],
      startDateTime: map['startDateTime'].toDate(),
      endDateTime: map['endDateTime'].toDate(),
      availableTickets: map['availableTickets'],
    );
  }
}
