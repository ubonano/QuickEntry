import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';

class EventRepository extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }

  Stream<List<Event>> getPendingAndOngoingEventsStream() {
    return _firestore
        .collection('events')
        .where('state',
            whereIn: [EventState.pending.value, EventState.ongoing.value])
        .orderBy('startDateTime', descending: false)
        .snapshots()
        .map((snapshot) => _mapSnapshotToEvents(snapshot));
  }

  Future<Event?> getEventById(String eventId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _firestore.collection('events').doc(eventId).get();

    if (docSnapshot.exists) {
      return Event.fromMap(docSnapshot.data()!, docSnapshot.id);
    }
    return null; // Retorna null si el evento no se encuentra
  }

  Future<void> updateEvent(String eventId, Event updatedEvent) async {
    await _firestore
        .collection('events')
        .doc(eventId)
        .update(updatedEvent.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  List<Event> _mapSnapshotToEvents(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data(), doc.id))
        .toList();
  }
}
