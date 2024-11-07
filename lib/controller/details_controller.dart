import 'package:get/get.dart';

import '../core/service/scrapping_service.dart';
import '../data/models/item_details_model.dart';

class DetailsController extends GetxController {
  late String href;
  ItemDetailsModel? itemDetailsModel;

  @override
  void onInit() async {
    href = Get.arguments['href'];
    itemDetailsModel = await ScrappingService.getItemDetails(href);
    update();
    super.onInit();
  }
}
