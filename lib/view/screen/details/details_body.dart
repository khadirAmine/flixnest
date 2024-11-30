import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/assets.dart';
import '../../../core/config/constants.dart';
import '../../../core/config/theme.dart';
import '../../../data/models/item_details_model.dart';

class DetailsBody extends StatefulWidget {
  const DetailsBody({super.key, required this.model});
  final ItemDetailsModel model;

  @override
  State<DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
  late List<Map<String, dynamic>> details;

  final ThemeData _appTheme = AppTheme().instance.theme;

  @override
  void initState() {
    details = [
      {'ألإسم': widget.model.arabicName},
      {'التصنيف': widget.model.classification},
      {'المدة': widget.model.duration},
      {'الجودة': widget.model.quality},
      {'يعرف ايضا ب': widget.model.alsoKnownAs},
      {'النوع': widget.model.type},
      {'السنة': widget.model.year},
      {'القصة': widget.model.storyMovie}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView(children: [
        _buildImageTitle(),
        SizedBox(height: Get.height * 0.02),
        ...List.generate(
            details.length,
            (i) => _biuldDetails(
                details[i].keys.elementAt(0),
                details[i][details[i].keys.elementAt(0)],
                details.length != i + 1)),
        SizedBox(height: Get.height * 0.3),
      ]);

  Widget _biuldDetails(String key, String? value, bool showDivider) {
    return value != null
        ? Column(
            children: [
              ListTile(
                leading: Text('$key :',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                title: Text(value),
                titleAlignment: ListTileTitleAlignment.top,
                dense: true,
              ),
              showDivider
                  ? const Divider(color: Colors.black)
                  : const SizedBox(),
            ],
          )
        : const SizedBox();
  }

  Widget _buildImageTitle() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 2),
          child: SizedBox(
              width: Get.width,
              height: Get.height * 0.2,
              child: Image.network(widget.model.imageUrl ?? '',
                  fit: BoxFit.fill, errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Assets().images.errorImage,
                  fit: BoxFit.fill,
                );
              })),
        ),
        Container(
          height: Get.height * 0.35,
          decoration: itemCardDecoration,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.model.imageUrl ?? '',
                  fit: BoxFit.fill, errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Assets().images.errorImage,
                  fit: BoxFit.fill,
                );
              })),
        )
      ],
    );
  }
}
