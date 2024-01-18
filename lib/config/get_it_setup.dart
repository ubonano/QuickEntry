import 'package:get_it/get_it.dart';

import '../controllers/event_controller.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => EventController());
}
