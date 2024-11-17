import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/scrapping_service.dart';
import '../shared/error_widget.dart';
import '../shared/no_wifi_widget.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late final HomeController _homeController = Get.put(HomeController());
  InAppWebViewController? _webViewController;
  final ThemeData theme = AppTheme().instance.theme;
  Map<String, dynamic> categorysData = {};

  @override
  void initState() {
    _homeController.drawerIsLoading = true;
    super.initState();
  }

  @override
  void dispose() {
    _homeController.drawerIsLoading = false;
    _webViewController = null;
    _webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: AppTheme().instance.theme.colorScheme.secondary,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(children: [
            SizedBox(
              width: Get.width,
              height: Get.height * 0.1,
              child: Stack(
                children: [
                  _buildWebView(),
                  Container(
                      alignment: Alignment.center,
                      color: theme.colorScheme.secondary,
                      width: Get.width,
                      height: Get.height * 0.1,
                      child: Image.asset(Assets().images.logo))
                ],
              ),
            ),
            GetBuilder<HomeController>(
                init: HomeController(),
                id: 'drawer',
                builder: (controller) => controller.drawerIsLoading
                    ? _loadingWidget()
                    : _buildDrawerBody())
          ]),
        ));
  }

  Widget _buildDrawerBody() {
    return categorysData['connectionStatus'] == false
        ? SizedBox(
            height: Get.height,
            child: NoWifiWidget(
              onTapRetry: () async {
                await _webViewController?.reload();
              },
            ),
          )
        : categorysData['error']['status'] == true
            ? SizedBox(
                height: Get.height,
                child: ErrorBodyWidget(
                  onTapRetry: () async {
                    await _webViewController?.reload();
                  },
                  statusCode: categorysData['statusCode'],
                ))
            : Column(children: [
                SizedBox(height: Get.height * 0.1),
                ...List.generate(
                    categorysData['body']['categorys'].length,
                    (i) => _buildButtonList(
                        categorysData['body']['categorys'].elementAt(i)))
              ]);
  }

  Widget _buildButtonList(Map<String, dynamic> items) => InkWell(
        onTap: () async {
          Get.back();
          ScrappingService().instance.baseUrl = items['href'];
          await _homeController.reTry();
        },
        child: Container(
          padding: EdgeInsets.only(right: Get.width * 0.05),
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
          decoration: BoxDecoration(
              color: items['isSellected']
                  ? theme.colorScheme.secondary
                  : theme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.shadowColor)),
          width: Get.width,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              child: Text(items['name'], style: const TextStyle(fontSize: 20))),
        ),
      );

  Widget _buildWebView() => GetBuilder<HomeController>(
      id: 'drawerWebView',
      builder: (controller) => InAppWebView(
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
              _homeController.drawerIsLoading = true;
              _homeController.update(['drawer']);
            },
            onLoadStop: (controller, url) async {
              String? html = await controller.getHtml();
              categorysData = await ScrappingService.getCategorys(html);
              _homeController.drawerIsLoading = false;
              _homeController.update(['drawer']);
            },
            onReceivedError: (controller, request, error) async {
              String? html = await controller.getHtml();
              categorysData = await ScrappingService.getCategorys(html,
                  hasError: true, error: error);
              _homeController.drawerIsLoading = false;
              _homeController.update(['drawer']);
            },
          ));

  Widget _loadingWidget() => Container(
        alignment: Alignment.center,
        height: Get.height,
        child: SpinKitDualRing(
          color: AppTheme().instance.theme.primaryColor,
          size: ((Get.width + Get.height) / 2) * 0.06,
        ),
      );
}
