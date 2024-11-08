import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashScreenController spController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme().instance.theme.splashColor,
        body: Center(
          child: VisibilityDetector(
              key: const Key('myKey'),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                debugPrint(
                    'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
              },
              child: Container(width: 100, height: 100, color: Colors.red)),
        ));
  }
}

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    HomeController homeController = Get.put(HomeController());
    homeController.items = await ScrappingService.getItems();
    Get.offAllNamed(Routes.home);
    super.onReady();
  }
}
