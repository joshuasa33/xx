// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:testre/Helper/httpMetaData.dart';
import 'package:testre/ShopPage/pushCoins.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admob_meteData.dart';

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const int maxFailedLoadAttempts = 3;
RewardedAd? _rewardedAd;
int _numRewardedLoadAttempts = 0;

Future<void> createRewardedAd(BuildContext context, String adid) {
  return RewardedAd.load(
      adUnitId: adid,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _rewardedAd = ad;
          context.read<AdStateProvider>().settrue();

          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          context.read<AdStateProvider>().setfalse();

          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            createRewardedAd(context, adid);
          }
        },
      ));
}

Future<void> showRewardedAd(
  BuildContext context,
  String adid,
) async {
  if (_rewardedAd == null) {
    print('Warning: attempt to show rewarded before loaded.');
    return;
  }
  _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (RewardedAd ad) =>
        print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (RewardedAd ad) async {
      print('$ad onAdDismissedFullScreenContent.');
      await ad.dispose();
      await createRewardedAd(context, adid);
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) async {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      await ad.dispose();
      await createRewardedAd(context, adid);
    },
  );

  _rewardedAd!.setImmersiveMode(true);
  await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
    print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    String playerguid = "";
    const constguid = "playerguid";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(constguid)) {
      playerguid = prefs.getString(constguid)!;
    }
    int getcoins = await saveCoins(20);
    await pushCoins(playerguid, getcoins);
    await fetchMetadata(context);
    print("done");
    //open Quotes
  });
  _rewardedAd = null;
}
