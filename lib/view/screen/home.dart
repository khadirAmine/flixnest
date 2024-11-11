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
import '../widgets/shared/error_widget.dart';
import '../widgets/home_widgets/home_search_bar.dart';
import '../widgets/home_widgets/item_card.dart';
import '../widgets/shared/no_wifi_widget.dart';

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
          title: const HomeSearchBar(
            category: 'انيمي وكارتون',
          ),
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
        await controller.reTry();
      });
    } else if (controller.itemsData?['error']['status']) {
      return ErrorBodyWidget(
          statusCode: controller.itemsData!['statusCode'],
          onTapRetry: () async {
            await controller.reTry();
          });
    } else {
      return GridViewLoading.builder(
        onEnd: () async {
          Map<String, dynamic> newItemsData = await ScrappingService.getItems(
              newItems: true, pageNum: controller.pageNum + 1);
          if (newItemsData['connectionStatus'] == false) {
            _internitSnackBar();
          } else if (newItemsData['error']['status']) {
            _errorSnackBar(newItemsData['statusCode']);
          } else {
            controller.itemsData!['body'].addAll(newItemsData['body']);
            controller.update();
            controller.pageNum++;
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

  SnackbarController _internitSnackBar() => Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),
        message: 'تحقق من الانترنت وحاول مرة اخرة',
        borderRadius: 10,
        icon: Icon(Icons.wifi_off,
            color: _appTheme.theme.colorScheme.tertiaryContainer),
      ));

  SnackbarController _errorSnackBar(int statusCode) =>
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),
        message: 'حدث خطأ : $statusCode',
        borderRadius: 10,
        icon: Icon(Icons.error_outline,
            color: _appTheme.theme.colorScheme.tertiaryContainer),
      ));
}
