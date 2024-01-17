import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_entry/views/home_screen.dart';
import 'firebase/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QuickEntryApp());
}

class QuickEntryApp extends StatelessWidget {
  const QuickEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QuickEntry',
      home: HomeScreen(),
    );
  }
}
