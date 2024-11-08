import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/assets.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashScreenController spController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                AppTheme().instance.theme.primaryColor.withAlpha(150),
                AppTheme().instance.theme.primaryColor,
              ])),
          child: Center(
            child: SizedBox(
                width: Get.width * 0.3,
                height: Get.height * 0.1425,
                child: Stack(
                  children: [
                    ClipRRect(
                        child: Image.asset(
                      Assets.logo,
                    )),
                    SpinKitDualRing(
                      color: AppTheme().instance.theme.colorScheme.secondary,
                      size: 60.0,
                    ),
                  ],
                )),
          )),
    );
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
