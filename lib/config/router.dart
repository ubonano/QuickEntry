import 'package:go_router/go_router.dart';

import '../views/event_detail_screen.dart';
import '../views/event_list_screen.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: '/event/:eventId',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId'] ?? '';
            return EventDetailsScreen(eventId: eventId, showBackButton: false);
          },
        ),
      ],
      debugLogDiagnostics: true,
    );
  }
}
