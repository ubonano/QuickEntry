import 'package:get_it/get_it.dart';

import '../controllers/event_controller.dart';
import '../repositories/event_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  //Repositories
  getIt.registerLazySingleton<EventRepository>(() => EventRepository());

  //Controllers
  getIt.registerLazySingleton(() => EventController());
}
