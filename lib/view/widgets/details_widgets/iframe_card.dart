import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class IframeCard extends StatelessWidget {
  const IframeCard({super.key, required this.iframe});
  final String? iframe;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
        height: Get.height * 0.22,
        decoration: BoxDecoration(
            color: Colors.yellow, borderRadius: BorderRadius.circular(10)),
        child: InAppWebView(
          initialUrlRequest:
              URLRequest(url: WebUri(iframe ?? 'www.facebook.com')),
        ));
  }
}
