import 'package:flixnest/core/service/scrapping_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/theme.dart';

// ignore: must_be_immutable
class HomeSearchBar extends StatelessWidget {
  HomeSearchBar({super.key});

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _editingController = TextEditingController();

  final AppTheme _appTheme = AppTheme().instance;

  bool _isIcon = true;

  final String url = AppConfig().instance.baseUrl;

  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        id: 'homeSearchBar',
        builder: (controller) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isIcon ? Get.width * 0.78 : Get.width * 0.7,
                  height: _isIcon ? Get.height * 0.05 : Get.height * 0.045,
                  child: _isIcon ? _buildSearchIcon() : _buildTextField(),
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

  Widget _buildSearchIcon() => Row(children: [
        FutureBuilder<Map>(
          future: ScrappingService.getCollections(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?['connectionStatus']) {
                if (snapshot.data?['error']['status'] == false) {
                  return _buildPopupMenu(context, snapshot);
                } else {
                  return SizedBox(width: Get.width * 0.22);
                }
              } else {
                return SizedBox(width: Get.width * 0.22);
              }
            } else {
              return SizedBox(width: Get.width * 0.22);
            }
          },
        ),
        Container(
            alignment: Alignment.centerLeft,
            width: Get.width * 0.36,
            child: Text(_homeController.title,
                style: const TextStyle(fontSize: 20))),
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

  Widget _buildPopupMenu(BuildContext context, AsyncSnapshot snapshot) =>
      InkWell(
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
                    _homeController.title = 'الكل';
                    _homeController.isLoading = true;
                    _homeController.update(['homeBody', 'homeSearchBar']);
                    _homeController.pageNum = 1;
                    ScrappingService().instance.getByCollection = false;
                    ScrappingService().instance.baseUrl =
                        AppConfig().instance.baseUrl;
                    _homeController.itemsData =
                        await ScrappingService.getItems();
                    _homeController.isLoading = false;
                    _homeController.update(['homeBody', 'homeSearchBar']);
                  },
                  child: const Column(children: [Text('الكل'), Divider()]),
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
  Future<void> _getItemsByCollection(AsyncSnapshot snapshot, int index) async {
    _homeController.title = snapshot.data?['body'][index]['name'];
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
