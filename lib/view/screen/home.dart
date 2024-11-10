import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/routes.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';
import '../../data/models/item_model.dart';
import '../widgets/home_widgets/grid_view_loading.dart';
import '../widgets/home_widgets/home_drawer.dart';
import '../widgets/home_widgets/home_error_widget.dart';
import '../widgets/home_widgets/home_search_bar.dart';
import '../widgets/home_widgets/item_card.dart';
import '../widgets/home_widgets/no_wifi_widget.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final AppTheme _appTheme = AppTheme().instance;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                scaffoldState.currentState?.openDrawer();
              }),
          automaticallyImplyLeading: false,
          title: const HomeSearchBar(),
        ),
        drawer: const HomeDrawer(),
        backgroundColor: _appTheme.theme.scaffoldBackgroundColor,
        body: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => _buildBody(controller)));
  }

  Widget _buildBody(HomeController controller) {
    if (controller.isLoading) {
      return Center(
          child: SpinKitDualRing(
        color: AppTheme().instance.theme.colorScheme.secondary,
        size: ((Get.width + Get.height) / 2) * 0.06,
      ));
    } else if (controller.itemsData?['connectionStatus'] == false) {
      return NoWifiWidget(onTapRetry: () async {
        controller.isLoading = true;
        controller.update();
        controller.itemsData = await ScrappingService.getItems();
        controller.isLoading = false;
        controller.update();
      });
    } else if (controller.itemsData?['error']['status']) {
      return HomeErrorWidget(
          statusCode: controller.itemsData?['statusCode'],
          onTapRetry: () async {
            controller.isLoading = true;
            controller.update();
            controller.itemsData = await ScrappingService.getItems();
            controller.isLoading = false;
            controller.update();
          });
    } else {
      return GridViewLoading.builder(
        onEnd: () async {
          controller.pageNum++;
          Map<String, dynamic> newItemsData = await ScrappingService.getItems(
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
        itemCount: controller.itemsData?['body']?.length,
      );
    }
  }
}
