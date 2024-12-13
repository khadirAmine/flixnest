import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/config/assets.dart';
import '../../../core/config/theme.dart';

class ShareButton extends StatelessWidget {
  ShareButton({super.key});
  final ThemeData _appTheme = AppTheme().instance.theme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(Container(
          height: Get.height * 0.15,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: _appTheme.colorScheme.tertiaryContainer,
          ),
          child: Row(children: []),
        ));
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
          margin: EdgeInsets.symmetric(vertical: Get.height * 0.005),
          height: Get.height * 0.06,
          decoration: BoxDecoration(
              color: _appTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _appTheme.shadowColor)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('مشاركة التطبيق', style: TextStyle(fontSize: 20)),
            SvgPicture.asset(
              AppAsset().svgs.share,
              height: Get.height * 0.03,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )
          ])),
    );
  }
}
