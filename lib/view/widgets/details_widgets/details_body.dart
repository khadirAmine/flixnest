import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/details_controller.dart';
import '../shared/custom_circular_progress.dart';

class DetailsBody extends StatelessWidget {
  const DetailsBody({super.key});
  @override
  Widget build(BuildContext context) => GetBuilder<DetailsController>(
      builder: (controller) => FutureBuilder(
            future: controller.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: [
                  _biuldDetails(
                      'ألإسم', snapshot.data?['body']['details']['arabicName']),
                  _biuldDetails('التصنيف',
                      snapshot.data?['body']['details']['classification']),
                  _biuldDetails(
                      'المدة', snapshot.data?['body']['details']['duration']),
                  _biuldDetails(
                      'الجودة', snapshot.data?['body']['details']['quality']),
                  _biuldDetails('يعرف ايضا ب',
                      snapshot.data?['body']['details']['alsoKnownAs']),
                  _biuldDetails(
                      'النوع', snapshot.data?['body']['details']['type']),
                  _biuldDetails(
                      'السنة', snapshot.data?['body']['details']['year']),
                  _biuldDetails(
                      'القصة', snapshot.data?['body']['details']['storyMovie']),
                ]);
              }
              return Center(child: CustomCircularProgress());
            },
          ));

  Widget _biuldDetails(String key, String? value) {
    return value != null
        ? Column(
            children: [
              ListTile(
                leading: Text('$key :',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                title: Text(value),
                titleAlignment: ListTileTitleAlignment.top,
                dense: true,
              ),
              const Divider(color: Colors.black),
            ],
          )
        : const SizedBox();
  }
}
