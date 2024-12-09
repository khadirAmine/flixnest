import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../config/app_config.dart';
import '../config/theme.dart';

logger(String? message) {
  // ignore: avoid_print
  print('Logger : $message');
}

Future initServices() async {
  await AppConfig.init();
  await AppTheme.init();
}

Future<bool> checkConnectionStatus() async {
  InternetConnectionStatus connectionStatus =
      await InternetConnectionChecker().connectionStatus;
  return connectionStatus == InternetConnectionStatus.connected ? true : false;
}
