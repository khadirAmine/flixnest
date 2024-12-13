import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../config/app_config.dart';
import '../config/theme.dart';
import '../service/ads_service.dart';

logger(String? message) {
  // ignore: avoid_print
  print('Logger : $message');
}

Future initServices() async {
  await AppConfig.init();
  await AppTheme.init();
  await UnityAds.init(
    gameId: AdsService.gameId,
    onComplete: () => logger('init Unity ads'),
    onFailed: (error, message) =>
        logger('init Unity ads Failed: $error $message'),
  );
}

Future<bool> checkConnectionStatus() async {
  InternetConnectionStatus connectionStatus =
      await InternetConnectionChecker().connectionStatus;
  return connectionStatus == InternetConnectionStatus.connected ? true : false;
}
