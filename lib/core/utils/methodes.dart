import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../config/app_config.dart';
import '../service/scrapping_service.dart';

logger(String? message) {
  // ignore: avoid_print
  print('Logger : $message');
}

Future initServices() async {
  HomeController homeController = Get.put(HomeController());
  await AppConfig.init();
  homeController.items = await ScrappingService.getItems();
}
