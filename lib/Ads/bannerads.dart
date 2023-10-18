import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Bannerad extends StatefulWidget {
  final String bannerString;
  const Bannerad({Key? key, required this.bannerString}) : super(key: key);

  @override
  State<Bannerad> createState() => _BanneradState();
}

late BannerAd _bannerAd;
bool _isBannerAdReady = false;

class _BanneradState extends State<Bannerad> {
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: widget.bannerString,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isBannerAdReady = true;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd.dispose(); // dispose the banner ad when the app is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isBannerAdReady)
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          ),
      ],
    );
  }
}
