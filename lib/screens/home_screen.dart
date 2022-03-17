import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hm_video_downloader/repositories/video_downloader_repository.dart';
import 'package:hm_video_downloader/screens/about_us_screen.dart';
import 'package:hm_video_downloader/screens/downloads_screen.dart';
import 'package:hm_video_downloader/utils/ad_helper.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:hm_video_downloader/widgets/downloader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    _loadInterstitalAd();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  _loadInterstitalAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.navigateInterstialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: ((ad) {
          setState(() => _interstitialAd = ad);
          setState(() => _isInterstitialAdReady = true);
        }),
        onAdFailedToLoad: (error) {
          setState(() => _isInterstitialAdReady = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: CustomColors.backGround,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.appBar,
          title: Text(
            "HM Video Downloader",
            textScaleFactor: ScreenUtil().textScaleFactor,
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: CustomColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: IconButton(
                onPressed: () {
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DownloadsScreen(),
                    ),
                  );
                },
                icon: Icon(
                  FontAwesome.download,
                  color: CustomColors.primary,
                  size: 26.w,
                ),
              ),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: CustomColors.primary,
            labelStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: CustomColors.primary,
              fontWeight: FontWeight.w600,
            ),
            labelColor: CustomColors.primary,
            unselectedLabelColor: CustomColors.white,
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: "YOUTUBE"),
              Tab(text: "FACEBOOK"),
              Tab(text: "TWITTER"),
              Tab(text: "ABOUT US"),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Downloader(type: VideoType.youtube),
            Downloader(type: VideoType.facebook),
            Downloader(type: VideoType.twitter),
            AboutUsScreen(),
          ],
        ),
      ),
    );
  }
}
