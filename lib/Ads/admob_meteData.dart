/* Production Notes
Files die in der Produktion geändert werden müssen:
-AndroidManifest.xml  Line 33+34
-ios/Runner/Info.plist -dort markiert zurzeit aber production vars - bei ios +simualtor erlaubt
 */
import 'dart:io';

import 'package:flutter/material.dart';

enum WhichAD {
  bannerCategory,
  bannerGoalPage,
}

enum WhichRewardedAD {
  rewardedCoins,
}

class AdHelper {
  static String getBannerAdUnitId(WhichAD rightBanner) {
    //Banner Category IOS
    if (Platform.isIOS && rightBanner == WhichAD.bannerCategory) {
      return '';
    }
    if (Platform.isAndroid && rightBanner == WhichAD.bannerCategory) {
      return '';
    }
    return "bannererror";
  }

  static String getRewardedAdID(WhichRewardedAD rightRewardedAD) {
    if (Platform.isIOS && rightRewardedAD == WhichRewardedAD.rewardedCoins) {
      return "ca-app-pub-1687998773643330/7365615742";
    }
    if (Platform.isAndroid &&
        rightRewardedAD == WhichRewardedAD.rewardedCoins) {
      return "ca-app-pub-1687998773643330/1658954269";
    }
    return "RewardedAdError";
  }
}

class AdStateProvider with ChangeNotifier {
  bool isloaded = false;
  void settrue() {
    isloaded = true;
    notifyListeners();
  }

  void setfalse() {
    isloaded = false;
    notifyListeners();
  }
}
