import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/details_controller.dart';
import '../../data/models/item_details_model.dart';
import '../widgets/details_widgets/details_card.dart';
import '../widgets/details_widgets/film_body.dart';
import '../widgets/details_widgets/iframe_card.dart';
import '../widgets/details_widgets/image_card.dart';
import '../widgets/details_widgets/serie_body.dart';
import '../widgets/details_widgets/top_navigation_bar.dart';
import '../widgets/shared/custom_circular_progress.dart';

class Details extends StatelessWidget {
  Details({super.key});
  final DetailsController _detailsController = Get.find<DetailsController>();
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
      body: Column(children: [
        TopNavigationBar(
          getItem: (int index) {
            print(index);
          },
        ),
        SingleChildScrollView(child: Column(children: []))
      ]),
      // body: GetBuilder<DetailsController>(
      //     builder: (controller) => FutureBuilder(
      //           future: controller.getData(),
      //           builder: (context, snapshot) {
      //             if (snapshot.hasData) {
      //               return _detailsBody(ItemDetailsModel(
      //                 title: snapshot.data?['body']['details']['title'],
      //                 imageUrl: snapshot.data?['body']['details']['imageUrl'],
      //                 year: snapshot.data?['body']['details']['year'],
      //                 arabicName: snapshot.data?['body']['details']
      //                     ['arabicName'],
      //                 quality: snapshot.data?['body']['details']['quality'],
      //                 type: snapshot.data?['body']['details']['type'],
      //                 alsoKnownAs: snapshot.data?['body']['details']
      //                     ['alsoKnownAs'],
      //                 classification: snapshot.data?['body']['details']
      //                     ['classification'],
      //                 duration: snapshot.data?['body']['details']['duration'],
      //                 storyMovie: snapshot.data?['body']['details']
      //                     ['storyMovie'],
      //                 iframe: snapshot.data?['body']['details']['iframe'],
      //                 seasions: snapshot.data?['body']['details']['seasions'],
      //                 episodes: snapshot.data?['body']['details']['episodes'],
      //                 isFilm: snapshot.data?['body']['details']['isFilm'],
      //               ));
      //             }
      //             return Center(child: CustomCircularProgress());
      //           },
      //         ))
    );
  }

  Widget _detailsBody(ItemDetailsModel model) => ListView(children: [
        SizedBox(height: Get.height * 0.01),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              ImageCard(imageUrl: model.imageUrl),
              SizedBox(
                width: Get.width * 0.55,
                child: Text(model.title ?? '',
                    style: const TextStyle(fontSize: 20)),
              ),
            ],
          )
        ]),
        Divider(height: Get.height * 0.04, color: Colors.black),
        DetailsCard(itemDetailsModel: model),
        SizedBox(height: Get.height * 0.04),
        IframeCard(iframe: model.iframe),
        SizedBox(height: Get.height * 0.04),
        _filmOrSerie(model.isFilm ?? false),
      ]);

  Widget _filmOrSerie(bool isFilm) =>
      isFilm ? const FilmBody() : const SerieBody();
}
