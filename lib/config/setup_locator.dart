import 'package:get/get.dart';

import '../controllers/event_controller.dart';
import '../repositories/event_repository.dart';

void setupLocator() {
  Get.lazyPut(() => EventRepository());

  Get.lazyPut(() => EventController());
}
