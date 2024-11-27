import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/item_details_model.dart';
import '../../widgets/details_widgets/iframe_card.dart';

class WatchFilm extends StatelessWidget {
  const WatchFilm({super.key, required this.model});

  final ItemDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: Get.height * 0.02),
        IframeCard(iframe: model.iframe),
        SizedBox(height: Get.height * 0.02),
        // Wrap(
        //   spacing: Get.width * 0.015,
        //   runSpacing: Get.height * 0.015,
        //   alignment: WrapAlignment.center,
        //   children: List.generate(
        //       model.episodes?.length ?? 0,
        //       (i) => InkWell(
        //           onTap: () {
        //             //     model.episodes?.elementAt(i)['href']
        //           },
        //           child: _buildEpisode(model.episodes?.elementAt(i)['name'],
        //               model.episodes?.elementAt(i)['selected']))),
        // ),
        SizedBox(height: Get.height * 0.5),
      ],
    );
  }
}
