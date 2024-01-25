import 'package:rxdart/rxdart.dart';
import '../config/get_it_setup.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventController {
  final EventRepository _eventRepository = getIt<EventRepository>();

  final BehaviorSubject<List<Event>> _upcomingEventsSubject =
      BehaviorSubject<List<Event>>();
  final BehaviorSubject<List<Event>> _ongoingEventsSubject =
      BehaviorSubject<List<Event>>();

  EventController() {
    _initUpcomingEventsStream();
    _initOngoingEventsStream();
  }

  void _initUpcomingEventsStream() {
    _eventRepository.getUpcomingEventsStream().listen((events) {
      _upcomingEventsSubject.add(events);
    });
  }

  void _initOngoingEventsStream() {
    _eventRepository.getOngoingEventsStream().listen((events) {
      _ongoingEventsSubject.add(events);
    });
  }

  Stream<List<Event>> get upcomingEventsStream => _upcomingEventsSubject.stream;
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
    _upcomingEventsSubject.close();
    _ongoingEventsSubject.close();
  }
}
