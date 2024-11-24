import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/details_controller.dart';
import '../widgets/details_widgets/details_body.dart';
import '../widgets/details_widgets/serie_body.dart';
import '../widgets/details_widgets/top_navigation_bar.dart';

class Details extends StatelessWidget {
  Details({super.key});
  final DetailsController _detailsController = Get.find<DetailsController>();
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_detailsController.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          TopNavigationBar(
            getItem: (int index) {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn);
            },
          ),
          SizedBox(
            height: Get.height,
            child: PageView(controller: _pageController, children: const [
              DetailsBody(),
              SerieBody(),
            ]),
          ),
        ]),
      ),
    );
  }
}
