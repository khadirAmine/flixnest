import 'package:get/get.dart';

import '../core/service/scrapping_service.dart';

class HomeController extends GetxController {
  int pageNum = 1;
  Map<String, dynamic>? itemsData;
  bool isLoading = false;

  Future reTry() async {
    isLoading = true;
    update();
    itemsData = await ScrappingService.getItems();
    isLoading = false;
    update();
  }
}
