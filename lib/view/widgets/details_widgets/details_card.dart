import 'package:flutter/material.dart';

import '../../../data/models/item_details_model.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.itemDetailsModel});
  final ItemDetailsModel? itemDetailsModel;
  @override
  Widget build(BuildContext context) => Column(children: [
        _biuldDetails('ألإسم', itemDetailsModel?.arabicName),
        _biuldDetails('التصنيف', itemDetailsModel?.classification),
        _biuldDetails('المدة', itemDetailsModel?.duration),
        _biuldDetails('الجودة', itemDetailsModel?.quality),
        _biuldDetails('يعرف ايضا ب', itemDetailsModel?.alsoKnownAs),
        _biuldDetails('النوع', itemDetailsModel?.type),
        _biuldDetails('السنة', itemDetailsModel?.year),
        _biuldDetails('القصة', itemDetailsModel?.storyMovie),
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
