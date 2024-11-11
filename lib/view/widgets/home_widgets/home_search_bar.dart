import 'package:flixnest/core/service/scrapping_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/theme.dart';

// class HomeSearchBar extends StatefulWidget {
//   const HomeSearchBar({super.key, required this.category});
//   final String category;
//   @override
//   State<HomeSearchBar> createState() => _HomeSearchBarState();
// }

class HomeSearchBar extends StatelessWidget {
  HomeSearchBar({super.key, required this.category});

  final String category;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  final AppTheme _appTheme = AppTheme().instance;

  bool _isIcon = true;

  final String url = AppConfig().instance.baseUrl;

  final HomeController _homeController = Get.put(HomeController());

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   _editingController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        id: 'homeSearchBar',
        builder: (controller) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isIcon ? Get.width * 0.78 : Get.width * 0.7,
                  height: _isIcon ? Get.height * 0.05 : Get.height * 0.045,
                  child:
                      _isIcon ? _buildSearchIcon(category) : _buildTextField(),
                ),
              ],
            ));
  }

  Widget _buildTextField() => TextField(
        controller: _editingController,
        focusNode: _focusNode,
        onTapOutside: (event) {
          _focusNode.unfocus();
          _isIcon = true;
          _editingController.clear();
          _homeController.update(['homeSearchBar']);
        },
        onSubmitted: (value) {
          _focusNode.unfocus();
          _isIcon = true;
          _editingController.clear();
          _homeController.update(['homeSearchBar']);
        },
        cursorColor: _appTheme.theme.primaryColor,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: _appTheme.theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(2000)),
          hintText: 'أدخل الإسم',
          hintStyle: const TextStyle(color: Colors.black38),
          fillColor: _appTheme.theme.iconButtonTheme.style?.backgroundColor
              ?.resolve(RxSet()),
          filled: true,
        ),
      );

  Widget _buildSearchIcon(String category) => Row(children: [
        FutureBuilder<Map>(
          future: ScrappingService.getCollections(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                onTap: () async {
                  showMenu(
                      context: context,
                      position: RelativeRect.fromDirectional(
                        textDirection: TextDirection.rtl,
                        start: 70,
                        end: 90,
                        top: 0,
                        bottom: 0,
                      ),
                      color: _appTheme.theme.colorScheme.secondary,
                      useRootNavigator: true,
                      items: [
                        PopupMenuItem(
                          onTap: () async {
                            _homeController.isLoading = true;
                            _homeController
                                .update(['homeBody', 'homeSearchBar']);
                            _homeController.pageNum = 1;
                            ScrappingService().instance.getByCollection = false;
                            ScrappingService().instance.baseUrl =
                                AppConfig().instance.baseUrl;
                            _homeController.itemsData =
                                await ScrappingService.getItems();
                            _homeController.isLoading = false;
                            _homeController
                                .update(['homeBody', 'homeSearchBar']);
                          },
                          child:
                              const Column(children: [Text('الكل'), Divider()]),
                        ),
                        ...List.generate(
                            snapshot.data?['body'].length,
                            (i) => PopupMenuItem(
                                  onTap: () async {
                                    await _getItemsByCollection(snapshot, i);
                                  },
                                  child: Column(children: [
                                    Text(snapshot.data?['body'][i]['name']),
                                    const Divider()
                                  ]),
                                ))
                      ]);
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: _appTheme.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: _appTheme.theme.shadowColor,
                            offset: const Offset(0, 1.5)),
                      ]),
                  child: const Row(children: [
                    Text('التصنيف ', style: TextStyle(fontSize: 19)),
                    Icon(Icons.keyboard_arrow_down)
                  ]),
                ),
              );
            } else {
              return SizedBox(width: Get.width * 0.22);
            }
          },
        ),
        SizedBox(width: Get.width * 0.14),
        Text(category, style: const TextStyle(fontSize: 20)),
        SizedBox(width: Get.width * 0.05),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _isIcon = false;
            _homeController.update(['homeSearchBar']);
            _focusNode.requestFocus();
          },
          iconSize: ((Get.width + Get.height) / 2) * 0.045,
        ),
      ]);

  Future<void> _getItemsByCollection(AsyncSnapshot snapshot, int index) async {
    _homeController.isLoading = true;
    _homeController.update(['homeBody', 'homeSearchBar']);
    _homeController.pageNum = 1;
    ScrappingService().instance.getByCollection = true;
    ScrappingService().instance.baseUrl = snapshot.data?['body'][index]['href'];
    _homeController.itemsData = await ScrappingService.getItems();
    _homeController.isLoading = false;
    _homeController.update(['homeBody', 'homeSearchBar']);
  }
}
