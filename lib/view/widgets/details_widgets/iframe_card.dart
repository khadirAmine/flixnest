import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../controller/details_controller.dart';
import '../../../core/config/theme.dart';
import '../shared/custom_circular_progress.dart';

// ignore: must_be_immutable
class IframeCard extends StatelessWidget {
  IframeCard({super.key, required this.iframe, required this.imageUrl});
  final String iframe;
  final String imageUrl;

  bool loadStop = false;

  final DetailsController _detailsController = Get.find<DetailsController>();

  final ThemeData _appTheme = AppTheme().instance.theme;

  bool playTap = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
        height: Get.height * 0.25,
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.yellow, borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (playTap == false && loadStop) {
                    playTap = true;
                    _detailsController.update(['iframe']);
                  }
                },
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(iframe)),
                  onLoadStop: (controller, url) {
                    loadStop = true;
                    _detailsController.update(['iframe']);
                  },
                  onWindowFocus: (controller) {
                    if (playTap == false && loadStop) {
                      playTap = true;
                      _detailsController.update(['iframe']);
                    }
                  },
                ),
              ),
              IgnorePointer(child: _buildStackPlay()),
            ],
          ),
        ));
  }

  Widget _buildStackPlay() {
    List<Widget> widgets = [
      Image.network(
        fit: BoxFit.fill,
        width: Get.width,
        height: Get.height * 0.25,
        imageUrl,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      ),
      Opacity(
        opacity: 0.4,
        child: Container(
          width: Get.width,
          height: Get.height * 0.25,
          color: Colors.black,
        ),
      ),
      Icon(Icons.play_arrow,
          color: Colors.white, size: (((Get.width) + (Get.height)) / 2) * 0.12)
    ];

    return GetBuilder<DetailsController>(
      id: 'iframe',
      builder: (controller) => playTap
          ? const SizedBox()
          : Stack(
              alignment: Alignment.center,
              children: loadStop
                  ? List.generate(
                      widgets.length,
                      (i) => widgets[i],
                    )
                  : [_buildLoading()]),
    );
  }

  Widget _buildLoading() {
    return Container(
        alignment: Alignment.center,
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          border: Border.all(color: _appTheme.colorScheme.secondaryContainer),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomCircularProgress());
  }
}
