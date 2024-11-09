import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';
import '../../data/models/item_model.dart';
import '../widgets/home_widgets/grid_view_loading.dart';
import '../widgets/home_widgets/item_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor:
                    AppTheme().instance.theme.appBarTheme.backgroundColor,
              ),
              body: GridViewLoading.builder(
                onEnd: () async {
                  controller.pageNum++;
                  Map<String, dynamic> newItemsData =
                      await ScrappingService.getItems(
                          newItems: true, pageNum: controller.pageNum);
                  if (newItemsData['connectionStatus'] == false) {
                    //TODO: show connections filed
                  } else if (newItemsData['error']['status'] == true) {
                    //TODO: show error details
                  } else {
                    controller.itemsData!['body'].addAll(newItemsData['body']);
                    controller.update();
                  }
                },
                itemBuilder: (i) {
                  return ItemCard(
                    onTap: () {
                      Get.toNamed(Routes.details, arguments: {
                        'href': controller.itemsData!['body'][i]['href']
                      });
                    },
                    model: ItemModel(
                      title: controller.itemsData!['body'][i]['title'],
                      imageUrl: controller.itemsData!['body'][i]['imageUrl'],
                      episode: controller.itemsData!['body'][i]['episode'],
                      year: controller.itemsData!['body'][i]['year'],
                      href: controller.itemsData!['body'][i]['href'],
                      isFilm: controller.itemsData!['body'][i]['isFilm'],
                    ),
                  );
                },
                itemCount: controller.itemsData!['body'].length,
              ),
            ));
  }
}
