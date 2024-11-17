import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/scrapping_service.dart';

// ignore: must_be_immutable
class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});
  Map<String, dynamic> categorys = {};
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: AppTheme().instance.theme.colorScheme.secondary,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(children: [
            GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) => SizedBox(
                width: Get.width,
                height: Get.height * 0.1,
                child: Stack(
                  children: [
                    _buildWebView(controller),
                    Container(
                      color: AppTheme().instance.theme.colorScheme.secondary,
                      width: Get.width,
                      height: Get.height * 0.1,
                    )
                  ],
                ),
              ),
            ),
            GetBuilder<HomeController>(
                init: HomeController(),
                id: 'drawer',
                builder: (controller) => controller.drawerIsLoading
                    ? _loadingWidget()
                    : Container(
                        color: Colors.blue,
                        height: 200,
                        child: Text(categorys.toString())))
          ]),
        ));
  }

  InAppWebView _buildWebView(HomeController homeController) => InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri(AppConfig().instance.baseUrl)),
        initialSettings: InAppWebViewSettings(
          preferredContentMode: UserPreferredContentMode.DESKTOP,
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
          javaScriptEnabled: true,
          useOnLoadResource: true,
          loadsImagesAutomatically: false,
        ),
        onWebViewCreated: (controller) async {
          await controller.evaluateJavascript(source: """
  document.querySelector('meta[name="viewport"]').setAttribute('content', 'width=1280,height=280 initial-scale=1.0');
""");
        },
        onLoadStart: (controller, url) {
          homeController.drawerIsLoading = true;
          homeController.update(['drawer']);
        },
        onLoadStop: (controller, url) async {
          String? html = await controller.getHtml();
          categorys = await ScrappingService.getCategorys(html);
          homeController.drawerIsLoading = false;
          homeController.update(['drawer']);
        },
        onReceivedError: (controller, request, error) async {
          String? html = await controller.getHtml();
          categorys = await ScrappingService.getCategorys(html,
              hasError: true, error: error);
          homeController.drawerIsLoading = false;
          homeController.update(['drawer']);
        },
      );

  Widget _loadingWidget() => Container(
        alignment: Alignment.center,
        height: Get.height,
        child: SpinKitDualRing(
          color: AppTheme().instance.theme.primaryColor,
          size: ((Get.width + Get.height) / 2) * 0.06,
        ),
      );
}
