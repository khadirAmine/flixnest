import '../config/app_config.dart';
import '../config/theme.dart';

logger(String? message) {
  // ignore: avoid_print
  print('Logger : $message');
}

Future initServices() async {
  await AppConfig.init();
  await AppTheme.initTheme();
}
