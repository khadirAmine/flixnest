import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/details_controller.dart';
import '../widgets/details_widgets/details_card.dart';
import '../widgets/details_widgets/iframe_card.dart';
import '../widgets/details_widgets/image_card.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red),
        body: GetBuilder<DetailsController>(
          init: DetailsController(),
          builder: (controller) => ListView(children: [
            SizedBox(height: Get.height * 0.01),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  ImageCard(imageUrl: controller.itemDetailsModel?.imageUrl),
                  SizedBox(
                    width: Get.width * 0.55,
                    child: Text(controller.itemDetailsModel?.title ?? '',
                        style: const TextStyle(fontSize: 20)),
                  ),
                ],
              )
            ]),
            Divider(height: Get.height * 0.04, color: Colors.black),
            DetailsCard(itemDetailsModel: controller.itemDetailsModel),
            SizedBox(height: Get.height * 0.04),
            IframeCard(iframe: controller.itemDetailsModel?.iframe),
            SizedBox(height: Get.height * 0.04),
            SizedBox(height: Get.height * 0.04),
          ]),
        ));
  }
}
