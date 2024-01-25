import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../utils/event_state_enum.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }

  Stream<List<Event>> getPendingEventsStream() {
    return _firestore
        .collection('events')
        .where('state', isEqualTo: EventState.pending.value)
        .orderBy('startDateTime', descending: false)
        .snapshots()
        .map((snapshot) => _mapSnapshotToEvents(snapshot));
  }

  Stream<List<Event>> getOngoingEventsStream() {
    return _firestore
        .collection('events')
        .where('state', isEqualTo: EventState.ongoing.value)
        .orderBy('startDateTime', descending: false)
        .snapshots()
        .map((snapshot) => _mapSnapshotToEvents(snapshot));
  }

  List<Event> _mapSnapshotToEvents(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data(), doc.id))
        .toList();
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
}
