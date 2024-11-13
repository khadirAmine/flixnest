import 'package:get/get.dart';

import '../core/service/scrapping_service.dart';

class HomeController extends GetxController {
  int pageNum = 1;
  Map<String, dynamic> itemsData = {};
  bool isLoading = false;
  String title = 'الكل';

  Future reTry() async {
    isLoading = true;
    update(['homeBody', 'homeSearchBar']);
    itemsData = await ScrappingService.getItems(false);
    isLoading = false;
    update(['homeBody', 'homeSearchBar']);
  }
}
