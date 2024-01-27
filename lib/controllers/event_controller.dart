import 'package:rxdart/rxdart.dart';
import '../config/get_it_setup.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../utils/event_state_enum.dart';

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

  Future<void> startEvent(Event event) async {
    await _eventRepository.updateEvent(
      event.id,
      event.copyWith(state: EventState.ongoing),
    );
  }

  Future<void> endEvent(Event event) async {
    await _eventRepository.updateEvent(
      event.id,
      event.copyWith(state: EventState.completed),
    );
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
