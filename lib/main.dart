import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'config/firebase_options.dart';
import 'config/get_it_setup.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/router.dart';

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickEntry',
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}
