import 'package:flixnest/data/models/item_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/details_controller.dart';
import '../widgets/details_widgets/details_body.dart';
import '../widgets/details_widgets/serie_body.dart';
import '../widgets/details_widgets/similar_offers.dart';
import '../widgets/details_widgets/top_navigation_bar.dart';
import '../widgets/details_widgets/watch_film.dart';
import '../widgets/shared/custom_circular_progress.dart';
import '../widgets/shared/error_widget.dart';

// ignore: must_be_immutable
class Details extends StatelessWidget {
  Details({super.key});
  final DetailsController _detailsController = Get.find<DetailsController>();
  final PageController _pageController = PageController();
  int indexBody = 0;
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
        body: GetBuilder<DetailsController>(
            builder: (controller) => FutureBuilder(
                  future: controller.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?['error']['status']) {
                        return ErrorBodyWidget(
                            statusCode: snapshot.data?['statusCode']);
                      } else {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(children: [
                            GetBuilder<DetailsController>(
                                id: 'topNavigationBar',
                                builder: (controller) => TopNavigationBar(
                                      selectedIndex: indexBody,
                                      isFilm: snapshot.data?['body']['details']
                                              ['isFilm'] ??
                                          false,
                                      getItem: (int index) {
                                        _pageController.animateToPage(index,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.bounceIn);
                                        indexBody = index;
                                      },
                                    )),
                            SizedBox(
                              height: Get.height,
                              child: PageView(
                                controller: _pageController,
                                children: _getBodys(
                                    snapshot.data?['body']['details']
                                            ['isFilm'] ??
                                        false,
                                    snapshot.data?['body'] ?? {}),
                                onPageChanged: (value) {
                                  indexBody = value;
                                  controller.update(['topNavigationBar']);
                                },
                              ),
                            ),
                          ]),
                        );
                      }
                    }
                    return Center(child: CustomCircularProgress());
                  },
                )));
  }

  List<Widget> _getBodys(bool isFilm, Map<String, dynamic> dataBody) {
    const SerieBody serieBody = SerieBody();
    const WatchFilm watchFilm = WatchFilm();
    const SimilarOffers similarOffers = SimilarOffers();

    List<Widget> bodys = [
      DetailsBody(model: ItemDetailsModel.fromJson(dataBody))
    ];
    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        isFilm ? null : bodys.add(serieBody);
      }
      if (i == 1) {
        isFilm ? bodys.add(watchFilm) : null;
      }
      if (i == 2) {
        isFilm ? bodys.add(similarOffers) : null;
      }
    }
    return bodys;
  }
}
