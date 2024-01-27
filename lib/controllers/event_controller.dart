import 'package:rxdart/rxdart.dart';
import '../config/get_it_setup.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventController {
  final EventRepository _eventRepository = getIt<EventRepository>();
  final BehaviorSubject<List<Event>> _combinedEventsSubject =
      BehaviorSubject<List<Event>>();

  Stream<List<Event>> get pendingAndOngoingEventsStream =>
      _combinedEventsSubject.stream;

  EventController() {
    _initPendingAndOngoingEventsStream();
  }

  void _initPendingAndOngoingEventsStream() {
    _eventRepository.getPendingAndOngoingEventsStream().listen((events) {
      _combinedEventsSubject.add(events);
    });
  }

  Future<void> createEvent(Event event) async {
    await _eventRepository.createEvent(event);
  }

  Future<void> updateEvent(String eventId, Event updatedEvent) async {
    await _eventRepository.updateEvent(eventId, updatedEvent);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventRepository.deleteEvent(eventId);
  }

  void dispose() {
    _combinedEventsSubject.close();
  }
}
