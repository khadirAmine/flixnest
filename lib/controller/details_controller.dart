import 'package:get/get.dart';

import '../core/service/scrapping_service.dart';

class DetailsController extends GetxController {
  late String href;

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = await ScrappingService.getItemDetails(href);
    return data;
  }

  @override
  void onInit() {
    href = Get.arguments['href'];
    super.onInit();
  }
}
