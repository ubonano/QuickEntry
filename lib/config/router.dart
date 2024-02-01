import 'package:get/get.dart';

import '../views/event_detail_screen.dart';
import '../views/event_list_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const EventsScreen(),
    ),
    GetPage(
      name: '/event/:eventId',
      page: () {
        var eventId = Get.parameters['eventId'] ?? '';
        return EventDetailsScreen(eventId: eventId);
      },
    ),
  ];
}
