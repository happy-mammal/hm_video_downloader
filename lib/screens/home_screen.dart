import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hm_video_downloader/data/video_downloader_api.dart';
import 'package:hm_video_downloader/models/video_download_model.dart';
import 'package:hm_video_downloader/models/video_quality_model.dart';
import 'package:hm_video_downloader/repositories/video_downloader_repository.dart';
import 'package:hm_video_downloader/utils/ad_helper.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:hm_video_downloader/widgets/my_banner_ad.dart';
import 'package:hm_video_downloader/widgets/video_quality_card.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  var _progressValue = 0.0;

  var _isDownloading = false;

  List<VideoQualityModel>? _qualities = [];

  VideoDownloadModel? _video;

  bool _isLoading = false;

  String _fileName = "";

  late InterstitialAd _interstitialAd;

  bool _isInterstitialAdReady = false;

  VideoType _videoType = VideoType.none;

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
  }

  _loadInterstitalAd({required String adUnitId}) {
    InterstitialAd.load(
      adUnitId: adUnitId,
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
    return Scaffold(
      backgroundColor: CustomColors.backGround,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter URL Here",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: CustomColors.white,
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _controller,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                enabled: false,
                cursorWidth: 1.w,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
                  filled: true,
                  fillColor: CustomColors.appBar,
                  suffixIcon: Icon(
                    _getBrandIcon,
                    color: CustomColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isDownloading) {
                          _showSnackBar(
                              "Try again later! Downloading in progress.");
                        } else {
                          setState(() => _isLoading = false);
                          _controller.text = "";
                          setState(() => _qualities = []);
                          setState(() => _isLoading = true);

                          Clipboard.getData(Clipboard.kTextPlain)
                              .then((value) async {
                            bool _hasString = await Clipboard.hasStrings();
                            if (_hasString) {
                              _controller.text = value!.text!;
                              if (value.text!.isEmpty ||
                                  _controller.text.isEmpty) {
                                _showSnackBar("Please Enter Video URL");
                              } else {
                                _setVideoType(value.text!);

                                await _onLinkPasted(value.text!);
                              }
                            } else {
                              _showSnackBar(
                                  "Empty content pasted! Please try again.");
                            }

                            setState(() => _isLoading = false);
                          });
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            "Paste Link",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: CustomColors.appBar,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(CustomColors.primary),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_isDownloading) {
                          _showSnackBar(
                              "Try again later! Downloading in progress.");
                        } else {
                          setState(() => _isLoading = false);
                          _controller.text = "";
                          setState(() => _qualities = []);
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            "Clear Link",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: CustomColors.appBar,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(CustomColors.primary),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _isLoading ? SizedBox(height: 20.h) : SizedBox(height: 10.h),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !_isDownloading
                      ? (_qualities != null && _qualities!.isNotEmpty)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Video Quality",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: CustomColors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _qualities!.length,
                                  itemBuilder: (context, index) =>
                                      VideoQualityCard(
                                    model: _qualities![index],
                                    type: _videoType,
                                    onTap: () async {
                                      if (_isDownloading) {
                                        _showSnackBar(
                                            "Try again later! Downloading in progress.");
                                      } else {
                                        await _performDownloading(
                                            _qualities![index].url!);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          : _qualities == null
                              ? Text(
                                  "hmm, this link looks too complicated for me or either i don't supported it yet... Can you try another one?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: CustomColors.white,
                                  ),
                                )
                              : Container()
                      : Container(),
              _isDownloading ? SizedBox(height: 20.h) : SizedBox(height: 10.h),
              _isDownloading
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.downloading,
                                          color: CustomColors.primary),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "Downloading",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: CustomColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    _fileName.substring(1),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: CustomColors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${_progressValue.toStringAsFixed(0)}%",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  color: CustomColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          LinearProgressIndicator(
                            value: (_progressValue / 100),
                            minHeight: 6.h,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: CustomColors.appBar,
                      ),
                    )
                  : Container(),
              _isDownloading ? SizedBox(height: 20.h) : Container(),
              MyBannerAd(
                type: MyBannerType.medium,
                adUnitId: AdHelper.homeScreenBannerAdUnitId,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  IconData? get _getBrandIcon {
    switch (_videoType) {
      case VideoType.facebook:
        return FontAwesome.facebook;
      case VideoType.twitter:
        return FontAwesome.twitter;
      case VideoType.youtube:
        return FontAwesome.youtube_play;
      default:
        return null;
    }
  }

  Future<VideoDownloadModel?> _getExtrationMethod({
    required VideoType type,
    required String url,
  }) async {
    final _api = VideoDownloaderAPI();
    final _repository = VideoDownloaderRepository(api: _api);

    switch (type) {
      case VideoType.facebook:
        return await _repository.getAvailableFBVideos(url);
      case VideoType.twitter:
        return await _repository.getAvailableTWVideos(url);
      case VideoType.youtube:
        return await _repository.getAvailableYTVideos(url);
      case VideoType.instagram:
        return await _repository.getAvailableIGVideos(url);
      default:
        return null;
    }
  }

  String? get _getFilePrefix {
    switch (_videoType) {
      case VideoType.facebook:
        return "Facebook";
      case VideoType.twitter:
        return "Twitter";
      case VideoType.youtube:
        return "YouTube";
      default:
        return null;
    }
  }

  _showSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
        margin: EdgeInsets.all(15.w),
        backgroundColor: CustomColors.primary,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: CustomColors.white,
              size: 30.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: CustomColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _performDownloading(String url) async {
    if (_isInterstitialAdReady) {
      _interstitialAd.show();
    }
    Dio dio = Dio();
    var permissions = await [Permission.storage].request();

    if (permissions[Permission.storage]!.isGranted) {
      var dir = await getApplicationDocumentsDirectory();

      setState(() {
        _fileName =
            "/$_getFilePrefix-${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}.mp4";
      });

      var path = dir.path + _fileName;

      try {
        setState(() => _isDownloading = true);
        await dio.download(
          url,
          path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() => _progressValue = (received / total * 100));
            }
          },
          deleteOnError: true,
        ).then((_) async {
          _loadInterstitalAd(adUnitId: AdHelper.downloadInterstialAdUnitId);
          setState(() => _isDownloading = false);
          setState(() => _progressValue = 0.0);

          setState(() => _isLoading = false);
          _controller.text = "";
          setState(() => _qualities = []);

          _showSnackBar("Video downloaded succesfully.");
          await Future.delayed(const Duration(seconds: 1));
          if (_isInterstitialAdReady) {
            _interstitialAd.show();
          }
        });
      } on DioError catch (e) {
        setState(() => _isDownloading = false);
        setState(() => _qualities = []);

        _showSnackBar("Oops! ${e.message}");
      }
    } else {
      _showSnackBar("No permission to read and write.");
    }
  }

  _onLinkPasted(String url) async {
    _loadInterstitalAd(adUnitId: AdHelper.downloadInterstialAdUnitId);
    var _response = await _getExtrationMethod(type: _videoType, url: url);
    setState(() => _video = _response);
    if (_video != null) {
      for (var _quality in _video!.videos!) {
        _qualities!.add(_quality);
      }
    } else {
      _qualities = null;
    }
    setState(() {});
  }

  _setVideoType(String url) {
    if (url.isEmpty) {
      setState(() => _videoType = VideoType.none);
    } else if (url.contains("facebook.com") || url.contains("fb.watch")) {
      setState(() => _videoType = VideoType.facebook);
    } else if (url.contains("youtube.com") || url.contains("youtu.be")) {
      setState(() => _videoType = VideoType.youtube);
    } else if (url.contains("twitter.com")) {
      setState(() => _videoType = VideoType.twitter);
    } else if (url.contains("instagram.com")) {
      setState(() => _videoType = VideoType.instagram);
    } else {
      setState(() => _videoType = VideoType.none);
    }
  }
}
