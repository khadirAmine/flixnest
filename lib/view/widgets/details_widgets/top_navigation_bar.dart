import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/theme.dart';

class TopNavigationBar extends StatefulWidget {
  const TopNavigationBar({super.key, required this.getItem});
  final Function(int index) getItem;

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  final ThemeData _appTheme = AppTheme().instance.theme;

  final List titles = ['التفاصيل', 'الحلقات', 'عروض مشابهة', 'مشاهدة الفلم'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        height: Get.height * 0.05,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          _appTheme.colorScheme.secondary,
          _appTheme.colorScheme.tertiaryContainer
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ...List.generate(
            titles.length,
            (i) => _buildItems(i),
          )
        ]));
  }

  Widget _buildItems(int i) => InkWell(
      onTap: () {
        selectedIndex = i;
        setState(() {});
        widget.getItem.call(i);
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.005),
          child: Column(
            children: [
              Text(
                titles[i],
                style: selectedIndex == i
                    ? TextStyle(
                        color: _appTheme.primaryColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      )
                    : null,
              ),
              selectedIndex == i
                  ? Container(
                      height: Get.height * 0.003,
                      decoration: BoxDecoration(
                          color: _appTheme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(2000)),
                      child: Text(titles[i],
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ));
}
