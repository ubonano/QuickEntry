import 'package:get/get.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';
import '../utils/event_state_enum.dart';

class EventController extends GetxController {
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final RxList<Event> pendingAndOngoingEvents = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initPendingAndOngoingEventsStream();
  }

  void _initPendingAndOngoingEventsStream() {
    _eventRepository.getPendingAndOngoingEventsStream().listen((events) {
      pendingAndOngoingEvents.assignAll(events);
    });
  }

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
    Event? currentEvent = await _eventRepository.getEventById(eventId);
    if (currentEvent?.state == EventState.pending) {
      await _eventRepository.updateEvent(eventId, updatedEvent);
    }
  }

  Future<Event?> getEventById(String eventId) async {
    return await _eventRepository.getEventById(eventId);
  }

  Future<void> createEvent(Event event) async {
    await _eventRepository.createEvent(event);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventRepository.deleteEvent(eventId);
  }
}
