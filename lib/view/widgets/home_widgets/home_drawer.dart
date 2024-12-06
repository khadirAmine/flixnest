import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/scrapping_service.dart';
import '../shared/custom_circular_progress.dart';
import '../shared/error_widget.dart';
import '../shared/no_wifi_widget.dart';

// ignore: must_be_immutable
class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  bool isLoading = false;

  InAppWebViewController? _webViewController;

  final ThemeData _appTheme = AppTheme().instance.theme;

  Map<String, dynamic>? categorysData = {};

  late String modeDesc;

  late bool switchValue;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        initState: (state) {
          isLoading = true;
          modeDesc = AppTheme().instance.themeMode == ThemeMode.dark
              ? 'تفعيل الوضع النهاري'
              : 'تفعيل الوضع الليلي';
          switchValue = AppTheme().instance.themeMode == ThemeMode.light;
        },
        dispose: (state) {
          isLoading = false;
          _webViewController = null;
          _webViewController?.dispose();
        },
        builder: (controller) => Container(
              width: Get.width * 0.7,
              height: Get.height,
              decoration: BoxDecoration(
                  color: _appTheme.colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(children: [
                    _buildHeader(controller),
                    GetBuilder<HomeController>(
                      id: 'drawerBody',
                      builder: (bodyController) => isLoading
                          ? _loadingWidget()
                          : _buildBody(bodyController),
                    )
                  ])),
            ));
  }

  Widget _buildHeader(HomeController controller) => SizedBox(
        width: Get.width,
        height: Get.height * 0.1,
        child: Stack(
          children: [
            _buildWebView(controller),
            Container(
                alignment: Alignment.center,
                width: Get.width,
                height: Get.height * 0.1,
                decoration: BoxDecoration(
                    color: _appTheme.colorScheme.secondary,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(15))),
                child: Image.asset(AppAsset().images.logo))
          ],
        ),
      );

  Widget _buildBody(HomeController controller) {
    return categorysData?['connectionStatus'] == false
        ? SizedBox(
            height: Get.height,
            child: NoWifiWidget(
              onTapRetry: () async {
                isLoading = true;
                controller.update(['drawerBody']);
                await _webViewController?.reload();
                isLoading = false;
                controller.update(['drawerBody']);
              },
            ),
          )
        : categorysData?['error']?['status'] == true
            ? SizedBox(
                height: Get.height,
                child: ErrorBodyWidget(
                  onTapRetry: () async {
                    isLoading = true;
                    controller.update(['drawerBody']);
                    await _webViewController?.reload();
                    isLoading = false;
                    controller.update(['drawerBody']);
                  },
                  statusCode: categorysData?['statusCode'],
                ))
            : Column(children: [
                SizedBox(height: Get.height * 0.1),
                ...List.generate(
                    categorysData?['body']?['categorys'].length ?? 0,
                    (i) => _buildButtonList(
                        categorysData?['body']['categorys'].elementAt(i),
                        controller)),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.only(right: Get.width * 0.05),
                  margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
                  decoration: BoxDecoration(
                      color: _appTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _appTheme.shadowColor)),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Get.height * 0.01),
                      child: Row(children: [
                        Text(modeDesc, style: const TextStyle(fontSize: 20)),
                        const Spacer(),
                        GetBuilder<HomeController>(
                            id: 'switch',
                            builder: (controller) => Switch(
                                  value: switchValue,
                                  onChanged: (value) async {
                                    Get.defaultDialog(
                                      backgroundColor:
                                          _appTheme.scaffoldBackgroundColor,
                                      title:
                                          'الانتقال الى الوضع ${switchValue ? 'الليلي' : 'النهاري'}',
                                      middleText:
                                          'المرجوا اعادة تشغيل التطبيق للانتقال الى الوضع ${switchValue ? 'الليلي' : 'النهاري'}',
                                      textConfirm: 'تغيير',
                                      textCancel: 'الغاء',
                                      onCancel: () => Get.back(),
                                      onConfirm: () async {
                                        switchValue = !switchValue;
                                        controller.update(['switch']);
                                        await AppTheme()
                                            .instance
                                            .changeThemeMode(switchValue
                                                ? ThemeMode.light
                                                : ThemeMode.dark);
                                        Get.back();
                                        exit(1);
                                      },
                                    );
                                  },
                                )),
                        SizedBox(width: Get.width * 0.01)
                      ])),
                ),
              ]);
  }

  Widget _buildButtonList(
          Map<String, dynamic> items, HomeController homeController) =>
      InkWell(
        onTap: () async {
          Get.back();
          ScrappingService().instance.baseUrl = items['href'];
          await homeController.reTry();
        },
        child: Container(
          width: Get.width,
          padding: EdgeInsets.only(right: Get.width * 0.05),
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
          decoration: BoxDecoration(
              color: items['isSellected']
                  ? _appTheme.colorScheme.secondary
                  : _appTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _appTheme.shadowColor)),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              child: Text(items['name'], style: const TextStyle(fontSize: 20))),
        ),
      );

  Widget _buildWebView(HomeController homeController) => InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri(ScrappingService().instance.baseUrl)),
        initialSettings: InAppWebViewSettings(
          preferredContentMode: UserPreferredContentMode.DESKTOP,
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
          javaScriptEnabled: true,
          useOnLoadResource: true,
          loadsImagesAutomatically: false,
        ),
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          await controller.evaluateJavascript(source: """
  document.querySelector('meta[name="viewport"]').setAttribute('content', 'width=1280,height=280 initial-scale=1.0');
""");
        },
        onLoadStart: (controller, url) {
          isLoading = true;
          homeController.update(['drawerBody']);
        },
        onLoadStop: (controller, url) async {
          String? html = await controller.getHtml();
          categorysData = await ScrappingService.getCategorys(html);
          isLoading = false;
          homeController.update(['drawerBody']);
        },
        onReceivedError: (controller, request, error) async {
          String? html = await controller.getHtml();
          categorysData = await ScrappingService.getCategorys(html,
              hasError: true, error: error);
          isLoading = false;
          homeController.update(['drawerBody']);
        },
      );

  Widget _loadingWidget() => Container(
        alignment: Alignment.center,
        height: Get.height,
        child: CustomCircularProgress(color: _appTheme.primaryColor),
      );
}
