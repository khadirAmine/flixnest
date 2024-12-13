import 'package:flutter/foundation.dart';

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
}
