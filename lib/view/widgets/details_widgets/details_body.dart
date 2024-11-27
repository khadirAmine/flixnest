import 'package:flutter/material.dart';

import '../../../data/models/item_details_model.dart';

class DetailsBody extends StatelessWidget {
  const DetailsBody({super.key, required this.model});
  final ItemDetailsModel model;
  @override
  Widget build(BuildContext context) => Column(children: [
        _biuldDetails('ألإسم', model.arabicName),
        _biuldDetails('التصنيف', model.classification),
        _biuldDetails('المدة', model.duration),
        _biuldDetails('الجودة', model.quality),
        _biuldDetails('يعرف ايضا ب', model.alsoKnownAs),
        _biuldDetails('النوع', model.type),
        _biuldDetails('السنة', model.year),
        _biuldDetails('القصة', model.storyMovie),
      ]);

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
