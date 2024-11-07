import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../config/app_config.dart';
import '../config/theme.dart';
import '../service/scrapping_service.dart';
import '../service/shared_preferences_service.dart';

logger(String? message) {
  // ignore: avoid_print
  print('Logger : $message');
}

Future initServices() async {
  await AppConfig.init();
  await AppTheme.initTheme();
  await SharedPreferencesService().instance.init();
  HomeController homeController = Get.put(HomeController());
  homeController.items = await ScrappingService.getItems();
}
