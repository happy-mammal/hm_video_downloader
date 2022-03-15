import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd extends StatefulWidget {
  final MyBannerType type;
  final String adUnitId;
  const MyBannerAd({Key? key, required this.type, required this.adUnitId})
      : super(key: key);

  @override
  State<MyBannerAd> createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd>
    with AutomaticKeepAliveClientMixin<MyBannerAd> {
  @override
  bool get wantKeepAlive => true;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  AdSize get _getAdSize {
    switch (widget.type) {
      case MyBannerType.medium:
        return AdSize.mediumRectangle;
      case MyBannerType.large:
        return AdSize.largeBanner;
      case MyBannerType.full:
        return AdSize.fullBanner;

      default:
        return AdSize.banner;
    }
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      size: _getAdSize,
      adUnitId: widget.adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isBannerAdReady = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(error.toString());
          setState(() => _isBannerAdReady = false);
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Center(
            child: SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          )
        : SizedBox(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
          );
  }
}

enum MyBannerType { medium, large, full }
