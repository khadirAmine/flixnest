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
                        title: snapshot.data?['title'],
                        imageUrl: snapshot.data?['imageUrl'],
                        year: snapshot.data?['year'],
                        arabicName: snapshot.data?['arabicName'],
                        quality: snapshot.data?['quality'],
                        type: snapshot.data?['type'],
                        alsoKnownAs: snapshot.data?['alsoKnownAs'],
                        classification: snapshot.data?['classification'],
                        duration: snapshot.data?['duration'],
                        storyMovie: snapshot.data?['storyMovie'],
                        iframe: snapshot.data?['iframe'],
                        seasions: snapshot.data?['seasions'],
                        episodes: snapshot.data?['episodes'],
                        isFilm: snapshot.data?['isFilm'],
                      ));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )));
  }
}
