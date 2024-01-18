import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/firebase_options.dart';
import 'config/get_it_setup.dart';
import 'views/event_form_screen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(const QuickEntryApp());
}

class QuickEntryApp extends StatelessWidget {
  const QuickEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickEntry',
      home: EventFormScreen(),
    );
  }
}
