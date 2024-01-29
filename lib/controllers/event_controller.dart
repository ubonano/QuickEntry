import 'package:rxdart/rxdart.dart';
import '../config/get_it_setup.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../utils/event_state_enum.dart';

class EventController {
  final EventRepository _eventRepository = getIt<EventRepository>();
  final BehaviorSubject<List<Event>> _combinedEventsSubject =
      BehaviorSubject<List<Event>>();

  EventController() {
    _initPendingAndOngoingEventsStream();
  }

  void _initPendingAndOngoingEventsStream() {
    _eventRepository.getPendingAndOngoingEventsStream().listen((events) {
      _combinedEventsSubject.add(events);
    });
  }

  Stream<List<Event>> get pendingAndOngoingEventsStream =>
      _combinedEventsSubject.stream;

  Future<void> startEvent(Event event) async {
    if (event.state == EventState.pending) {
      await _eventRepository.updateEvent(
        event.id,
        event.copyWith(state: EventState.ongoing),
      );
    }
  }

  Future<void> endEvent(Event event) async {
    if (event.state == EventState.ongoing) {
      await _eventRepository.updateEvent(
        event.id,
        event.copyWith(state: EventState.completed),
      );
    }
  }

  Future<void> updateEvent(String eventId, Event updatedEvent) async {
    Event currentEvent = await _eventRepository.getEventById(eventId);
    if (currentEvent.state == EventState.pending) {
      await _eventRepository.updateEvent(eventId, updatedEvent);
    }
  }

  Future<Event> getEventById(String eventId) async {
    return await _eventRepository.getEventById(eventId);
  }

  Future<void> createEvent(Event event) async {
    await _eventRepository.createEvent(event);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventRepository.deleteEvent(eventId);
  }

  void dispose() {
    _combinedEventsSubject.close();
  }
}
