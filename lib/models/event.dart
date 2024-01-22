class Event {
  String id;
  String name;
  String description;
  String address;
  DateTime startDateTime;
  DateTime endDateTime;
  int availableTickets;

  Event({
    this.id = '',
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
      name: map['name'],
      description: map['description'],
      address: map['address'],
      startDateTime: map['startDateTime'].toDate(),
      endDateTime: map['endDateTime'].toDate(),
      availableTickets: map['availableTickets'],
    );
  }
}
