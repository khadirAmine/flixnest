import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/item_details_model.dart';
import 'details_card.dart';
import 'iframe_card.dart';
import 'image_card.dart';

class DetailsBody extends StatelessWidget {
  const DetailsBody({super.key, required this.model});
  final ItemDetailsModel model;
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      SizedBox(height: Get.height * 0.01),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
            ImageCard(imageUrl: model.imageUrl),
            SizedBox(
              width: Get.width * 0.55,
              child:
                  Text(model.title ?? '', style: const TextStyle(fontSize: 20)),
            ),
          ],
        )
      ]),
      Divider(height: Get.height * 0.04, color: Colors.black),
      DetailsCard(itemDetailsModel: model),
      SizedBox(height: Get.height * 0.04),
      IframeCard(iframe: model.iframe),
      SizedBox(height: Get.height * 0.04),
      _buildFilmOrNot(model.isFilm ?? false),
    ]);
  }

  Widget _buildFilmOrNot(bool isFilm) {
    switch (isFilm) {
      case true:
        return const Column(children: [
          Text('قد يعجبك ايضا :'),
        ]);

      case false:
        return const Text('isNotFilm');
    }
  }
}
