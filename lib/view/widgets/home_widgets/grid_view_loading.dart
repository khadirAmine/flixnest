import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GridViewLoading {
  static builder({
    int? itemCount,
    required Widget Function(int index) itemBuilder,
    required void Function() onEnd,
  }) =>
      GridViewBuilder(
          itemCount: itemCount, itemBuilder: itemBuilder, onEnd: onEnd);
}

class GridViewBuilder extends StatefulWidget {
  const GridViewBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onEnd,
  });
  final int? itemCount;
  final Widget Function(int index) itemBuilder;
  final void Function() onEnd;

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {
  ScrollController controller = ScrollController();
  RxBool showLoading = RxBool(false);

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        showLoading.value = true;
        widget.onEnd.call();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, controller: controller, children: [
      SizedBox(height: Get.height * 0.015),
      Container(
        alignment: Alignment.center,
        child: Wrap(
          spacing: Get.width * 0.025,
          runSpacing: Get.height * 0.015,
          children: List.generate(
            widget.itemCount ?? 10,
            widget.itemBuilder.call,
          ),
        ),
      ),
      Obx(
        () => showLoading.value
            ? Column(children: [
                SizedBox(height: Get.height * 0.025),
                Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator()),
                SizedBox(height: Get.height * 0.015),
              ])
            : const SizedBox(),
      )
    ]);
  }
}
