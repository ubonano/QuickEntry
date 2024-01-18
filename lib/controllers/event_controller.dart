import 'package:cloud_firestore/cloud_firestore.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Map<String, dynamic> eventData) async {
    await _firestore.collection('events').add(eventData);
  }
}
