import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'config/firebase_options.dart';
import 'config/get_it_setup.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/event_detail_screen.dart';
import 'views/event_list_screen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: true,
  );

  setupLocator();

  setPathUrlStrategy();

  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const QuickEntryApp());
  });

  runApp(const QuickEntryApp());
}

class QuickEntryApp extends StatelessWidget {
  const QuickEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickEntry',
      routes: {
        '/': (context) => EventsScreen(),
        '/event': (context) => EventDetailsScreen(eventId: ''),
      },
      onGenerateRoute: (RouteSettings settings) {
        Uri uri = Uri.parse(settings.name ?? '/');

        // Verifica si el primer segmento es 'event'
        if (uri.pathSegments.length > 1 && uri.pathSegments.first == 'event') {
          String eventId = uri.pathSegments[1];

          return MaterialPageRoute(
            builder: (context) =>
                EventDetailsScreen(eventId: eventId, showBackButton: false),
          );
        }

        switch (uri.path) {
          case '/':
            return MaterialPageRoute(builder: (context) => EventsScreen());
          // Otros casos de rutas fijas
          default:
            // Ruta no encontrada
            return MaterialPageRoute(builder: (context) => EventsScreen());
        }
      },
    );
  }
}
