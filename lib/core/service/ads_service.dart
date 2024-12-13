import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../utils/methodes.dart';

class AdsService {
  static String gameId =
      defaultTargetPlatform == TargetPlatform.android ? '5750801' : '5750800';

  static String interstitialAdPlacementId =
      defaultTargetPlatform == TargetPlatform.android
          ? 'Interstitial_Android'
          : 'Interstitial_IOS';

  static String rewardedAdPlacementId =
      defaultTargetPlatform == TargetPlatform.android
          ? 'Rewarded_Android'
          : 'Rewarded_IOS';

  static String bannerAdPlacementId =
      defaultTargetPlatform == TargetPlatform.android
          ? 'Banner_Android'
          : 'Banner_IOS';

  static Future<void> showAd(String placementId) async {
    void loadAd(String placementId) {
      UnityAds.load(
        placementId: placementId,
        onComplete: (placementId) {
          logger('Load Complete $placementId');
        },
        onFailed: (placementId, error, message) =>
            logger('Load Failed $placementId: $error $message'),
      );
    }

    await UnityAds.showVideoAd(
      placementId: placementId,
      onComplete: (placementId) {
        logger('Video Ad $placementId completed');
        loadAd(placementId);
      },
      onFailed: (placementId, error, message) {
        logger('Video Ad $placementId failed: $error $message');
        loadAd(placementId);
      },
      onStart: (placementId) => logger('Video Ad $placementId started'),
      onClick: (placementId) => logger('Video Ad $placementId click'),
      onSkipped: (placementId) {
        logger('Video Ad $placementId skipped');
        loadAd(placementId);
      },
    );
  }

  static Widget showBannerAd() => UnityBannerAd(
        placementId: AdsService.bannerAdPlacementId,
        onLoad: (placementId) => logger('Banner loaded: $placementId'),
        onClick: (placementId) => logger('Banner clicked: $placementId'),
        onShown: (placementId) => logger('Banner shown: $placementId'),
        onFailed: (placementId, error, message) =>
            logger('Banner Ad $placementId failed: $error $message'),
      );
}
