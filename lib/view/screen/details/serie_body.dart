import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/theme.dart';
import '../../../data/models/item_details_model.dart';
import '../../widgets/details_widgets/iframe_card.dart';

class SerieBody extends StatelessWidget {
  SerieBody({super.key, required this.model});
  final ItemDetailsModel model;

  final ThemeData _appTheme = AppTheme().instance.theme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: Get.height * 0.02),
        IframeCard(iframe: model.iframe),
        SizedBox(height: Get.height * 0.02),
        Wrap(
          spacing: Get.width * 0.015,
          runSpacing: Get.height * 0.015,
          alignment: WrapAlignment.center,
          children: List.generate(
              model.episodes?.length ?? 0,
              (i) => InkWell(
                  onTap: () {
                    //     model.episodes?.elementAt(i)['href']
                  },
                  child: _buildEpisode(model.episodes?.elementAt(i)['name'],
                      model.episodes?.elementAt(i)['selected']))),
        ),
        SizedBox(height: Get.height * 0.5),
      ],
    );
  }

  Widget _buildEpisode(String name, bool selected) {
    return Container(
        width: Get.width * 0.23,
        height: Get.height * 0.045,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? _appTheme.primaryColor
              : _appTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(name,
            style: const TextStyle(
              fontSize: 17,
            )));
  }
}
