import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/service/firebase_service.dart';
import '../core/service/scrapping_service.dart';
import '../view/widgets/shared/spleach_screen.dart';

class HomeController extends GetxController {
  int pageNum = 1;
  Map<String, dynamic> itemsData = {};
  bool isLoading = false;
  String title = 'الكل';
  Map<String, dynamic>? drawerCategorysData;
  late String shareLink;

  Future reTry() async {
    isLoading = true;
    update(['homeBody', 'homeSearchBar']);
    itemsData = await ScrappingService.getItems();
    isLoading = false;
    update(['homeBody', 'homeSearchBar']);
  }

  @override
  void onReady() {
    Get.showOverlay(
        opacity: 1,
        opacityColor: Colors.white,
        asyncFunction: () async {
          itemsData = await ScrappingService.getItems();
          update(['homeBody', 'homeSearchBar']);
        },
        loadingWidget: SpleachScreen());
    super.onReady();
  }

  @override
  void onInit() async {
    shareLink = await FirebaseService.getShareableLink();
    super.onInit();
  }
}
