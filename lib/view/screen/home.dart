import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';
import '../../core/utils/methodes.dart';
import '../../data/models/item_model.dart';
import '../widgets/home_widgets/grid_view_loading.dart';
import '../widgets/home_widgets/item_card.dart';

class Home extends StatelessWidget {
  Home({super.key});
  bool switchValue = AppTheme().instance.themeMode == ThemeMode.light;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                backgroundColor:
                    AppTheme().instance.theme.appBarTheme.backgroundColor,
                centerTitle: true,
                title: IconButton(
                    icon: const Icon(Icons.radio_button_checked),
                    onPressed: () async {
                      // controller.pageNum++;
                      // await ScrappingService.getItems(
                      //     newItems: true, pageNum: controller.pageNum);
                      List<Map<String, dynamic>> data = [];
                      data.add({
                        'title': 'title',
                        'imageUrl': 'imageUrl',
                        'episode': 'episode',
                        'year': 'year',
                        'href': 'href'
                      });
                    }),
              ),
              body: GridViewLoading.builder(
                onEnd: () async {
                  controller.pageNum++;
                  try {
                    if (await checkConnection()) {
                      http.Response newItems = await ScrappingService.getItems(
                          newItems: true, pageNum: controller.pageNum);
                      controller.items.addAll(jsonDecode(newItems.body));
                      controller.update();
                    } else {
                      //TODO: show error connectionDialog
                    }
                  } catch (e) {
                    //TODO: show errorDialog
                  }
                },
                itemBuilder: (i) {
                  return ItemCard(
                    onTap: () {
                      Get.toNamed(Routes.details,
                          arguments: {'href': controller.items[i]['href']});
                    },
                    model: ItemModel(
                      title: controller.items[i]['title'],
                      imageUrl: controller.items[i]['imageUrl'],
                      episode: controller.items[i]['episode'],
                      year: controller.items[i]['year'],
                      href: controller.items[i]['href'],
                      isFilm: controller.items[i]['isFilm'],
                    ),
                  );
                },
                itemCount: controller.items.length,
              ),
            ));
  }
}
