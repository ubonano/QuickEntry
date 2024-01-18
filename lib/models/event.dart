class Event {
  String name;
  String description;
  String address;
  DateTime startDateTime;
  DateTime endDateTime;
  int availableTickets;

  Event({
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
}
