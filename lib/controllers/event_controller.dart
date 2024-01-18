import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }
}
