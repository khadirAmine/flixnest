import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/service/scrapping_service.dart';
import '../core/utils/methodes.dart';

class DetailsController extends GetxController {
  late String href;

  Future<Map?> getData() async {
    if (await checkConnection()) {
      try {
        http.Response response = await ScrappingService.getItemDetails(href);
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        logger('Error : $e');
        //TODO: show Error Dialog
      }
    } else {
      logger('Error Connection');
      //TODO: show ConnectionFiled dialog
    }
    return null;
  }

  @override
  void onInit() {
    href = Get.arguments['href'];
    super.onInit();
  }
}
