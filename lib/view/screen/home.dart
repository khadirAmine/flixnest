import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';
import '../../data/models/item_model.dart';
import '../widgets/home_widgets/grid_view_loading.dart';
import '../widgets/home_widgets/home_drawer.dart';
import '../widgets/home_widgets/item_card.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final AppTheme _appTheme = AppTheme().instance;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          iconTheme: _appTheme.theme.appBarTheme.iconTheme,
          shadowColor: _appTheme.instance.theme.appBarTheme.shadowColor,
          elevation: _appTheme.instance.theme.appBarTheme.elevation,
          backgroundColor: _appTheme.instance.theme.primaryColor,
          scrolledUnderElevation:
              _appTheme.theme.appBarTheme.scrolledUnderElevation,
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                scaffoldState.currentState?.openDrawer();
              }),
          automaticallyImplyLeading: false,
        ),
        drawer: HomeDrawer(),
        backgroundColor: _appTheme.theme.scaffoldBackgroundColor,
        body: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => GridViewLoading.builder(
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
                      controller.itemsData!['body']
                          .addAll(newItemsData['body']);
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
                )));
  }
}
