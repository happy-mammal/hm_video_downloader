import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/utils/ad_helper.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:hm_video_downloader/widgets/my_banner_ad.dart';
import 'package:hm_video_downloader/widgets/video_card.dart';

class VideoReelsScreen extends StatefulWidget {
  final List<VideoData> videoData;
  final List<FileSystemEntity> downloads;
  final ValueChanged onVideoDeleted,
      onControllerInit,
      onControllerDisp,
      onPageViewInit;

  const VideoReelsScreen({
    Key? key,
    required this.videoData,
    required this.downloads,
    required this.onVideoDeleted,
    required this.onControllerInit,
    required this.onControllerDisp,
    required this.onPageViewInit,
  }) : super(key: key);

  @override
  State<VideoReelsScreen> createState() => _VideoReelsScreenState();
}

class _VideoReelsScreenState extends State<VideoReelsScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    widget.onPageViewInit(_pageController);
    super.initState();
  }

  _showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: GoogleFonts.poppins(
          color: CustomColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Delete",
        style: GoogleFonts.poppins(
          color: CustomColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () async {
        try {
          final file = File(widget.downloads[index].path);
          await file.delete();
        } catch (e) {
          debugPrint(e.toString());
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
        widget.onVideoDeleted;
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: CustomColors.backGround,
      title: Text(
        "Delete Confirmation",
        style: GoogleFonts.poppins(
          color: CustomColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        "Are you sure you want to delete this video ?",
        style: GoogleFonts.poppins(
          color: CustomColors.white,
          fontSize: 18,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyBannerAd(
            type: MyBannerType.full,
            adUnitId: AdHelper.videosScreenBannerAdUnitId),
        Expanded(
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: List.generate(
              widget.downloads.length,
              (index) {
                return VideoCard(
                  path: widget.downloads[index].path,
                  data: widget.videoData[index],
                  onVideoDeleted: () {
                    _showAlertDialog(context, index);
                  },
                  onControllerInit: (controller) {
                    widget.onControllerInit(controller);
                  },
                  onControllerdisp: (controller) {
                    widget.onControllerDisp(controller);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
