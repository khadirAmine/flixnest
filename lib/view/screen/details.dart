import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/details_controller.dart';
import '../../data/models/item_details_model.dart';
import '../widgets/details_widgets/details_body.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.red),
        body: GetBuilder<DetailsController>(
            init: DetailsController(),
            builder: (controller) => FutureBuilder(
                  future: controller.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DetailsBody(
                          model: ItemDetailsModel(
                        title: snapshot.data?['body']['title'],
                        imageUrl: snapshot.data?['body']['imageUrl'],
                        year: snapshot.data?['body']['year'],
                        arabicName: snapshot.data?['body']['arabicName'],
                        quality: snapshot.data?['body']['quality'],
                        type: snapshot.data?['body']['type'],
                        alsoKnownAs: snapshot.data?['body']['alsoKnownAs'],
                        classification: snapshot.data?['body']
                            ['classification'],
                        duration: snapshot.data?['body']['duration'],
                        storyMovie: snapshot.data?['body']['storyMovie'],
                        iframe: snapshot.data?['body']['iframe'],
                        seasions: snapshot.data?['body']['seasions'],
                        episodes: snapshot.data?['body']['episodes'],
                        isFilm: snapshot.data?['body']['isFilm'],
                      ));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )));
  }
}
