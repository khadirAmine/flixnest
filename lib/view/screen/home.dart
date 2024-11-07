import 'package:flixnest/core/service/scrapping_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../data/models/item_model.dart';
import '../widgets/home_widgets/grid_view_loading.dart';
import '../widgets/home_widgets/item_card.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final HomeController _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            centerTitle: true,
            title: IconButton(
                icon: const Icon(Icons.radio_button_checked),
                onPressed: () async {
                  _homeController.pageNum++;
                  await ScrappingService.getItems(
                      newItems: true, pageNum: _homeController.pageNum);
                })),
        body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) => GridViewLoading.builder(
            onEnd: () async {
              controller.pageNum++;
              List<ItemModel>? newItems = await ScrappingService.getItems(
                  newItems: true, pageNum: controller.pageNum);
              controller.items?.addAll(newItems ?? []);
              newItems == null ? null : controller.update();
            },
            itemBuilder: (i) {
              return ItemCard(
                onTap: () {
                  Get.toNamed(Routes.details,
                      arguments: {'href': controller.items?[i].href});
                },
                model: controller.items?[i],
              );
            },
            itemCount: controller.items?.length,
          ),
        ));
  }
}
