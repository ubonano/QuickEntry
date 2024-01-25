import 'package:rxdart/rxdart.dart';
import '../config/get_it_setup.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventController {
  final EventRepository _eventRepository = getIt<EventRepository>();

  final BehaviorSubject<List<Event>> _pendingEventsSubject =
      BehaviorSubject<List<Event>>();
  final BehaviorSubject<List<Event>> _ongoingEventsSubject =
      BehaviorSubject<List<Event>>();

  EventController() {
    _initPendingEventsStream();
    _initOngoingEventsStream();
  }

  void _initPendingEventsStream() {
    _eventRepository.getPendingEventsStream().listen((events) {
      _pendingEventsSubject.add(events);
    });
  }

  void _initOngoingEventsStream() {
    _eventRepository.getOngoingEventsStream().listen((events) {
      _ongoingEventsSubject.add(events);
    });
  }

  Stream<List<Event>> get pendingEventsStream => _pendingEventsSubject.stream;
  Stream<List<Event>> get ongoingEventsStream => _ongoingEventsSubject.stream;

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
    _pendingEventsSubject.close();
    _ongoingEventsSubject.close();
  }
}
