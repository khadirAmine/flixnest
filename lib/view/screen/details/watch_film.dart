import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/routes.dart';
import '../../../data/models/item_details_model.dart';
import '../../../data/models/item_model.dart';
import '../../widgets/details_widgets/iframe_card.dart';
import '../../widgets/shared/item_card.dart';

class WatchFilm extends StatelessWidget {
  const WatchFilm({super.key, required this.model});

  final ItemDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: Get.height * 0.03),
        IframeCard(
            iframe: model.iframe ?? 'www.google.com',
            imageUrl: model.imageUrl ?? errorImageLink),
        SizedBox(height: Get.height * 0.03),
        const Text('  عروض مشابهة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        SizedBox(height: Get.height * 0.02),
        Wrap(
          spacing: Get.width * 0.025,
          runSpacing: Get.height * 0.015,
          alignment: WrapAlignment.center,
          children: List.generate(
            model.similarOffers?.length ?? 0,
            (i) => ItemCard(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.details, arguments: {
                    'href': model.similarOffers?.elementAt(i)['href'],
                    'title': model.similarOffers?.elementAt(i)['title'],
                  });
                },
                model: ItemModel.fromJson(model.similarOffers?.elementAt(i))),
          ),
        ),
        SizedBox(height: Get.height * 0.5),
      ],
    );
  }
}
