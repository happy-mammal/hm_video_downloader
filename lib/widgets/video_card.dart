import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/utils/ad_helper.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:hm_video_downloader/widgets/my_banner_ad.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoCard extends StatefulWidget {
  final String path;
  final VideoData data;
  final VoidCallback onVideoDeleted;

  const VideoCard({
    Key? key,
    required this.path,
    required this.data,
    required this.onVideoDeleted,
  }) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Uint8List? _image;
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  late String _timeago;
  IconData? _getMediaIcon(String media) {
    switch (media) {
      case "Facebook":
        return FontAwesome.facebook;
      case "Twitter":
        return FontAwesome.twitter;
      case "YouTube":
        return FontAwesome.youtube_play;
      default:
        return null;
    }
  }

  Future<void> _generateImageMemory(path) async {
    var _res = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: widget.data.width!,
      maxHeight: widget.data.height!,
      timeMs: 3000,
      quality: 25,
    );

    setState(() => _image = _res);
  }

  @override
  void initState() {
    _initializeControllers();
    _generateImageMemory(widget.path);
    var _date = (widget.data.title!.split("-"))[1].substring(0, 8);
    var _time = (widget.data.title!.split("-"))[1].substring(8);
    _timeago = timeago.format(DateTime.parse("${_date}T$_time"));

    super.initState();
  }

  _initializeControllers() async {
    _controller = VideoPlayerController.file(File(widget.path));
    await _controller!.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: true,
        zoomAndPan: true,
        autoInitialize: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp
        ],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
    setState(() {});
  }

  @override
  void dispose() {
    _chewieController!.pause();
    _chewieController!.dispose();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Container(
          decoration: _image != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(_image!),
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        _chewieController != null
            ? Chewie(controller: _chewieController!)
            : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 10.w, 6.w, 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Downloaded $_timeago",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        height: 35.h,
                        alignment: Alignment.center,
                        child: Icon(
                          _getMediaIcon(widget.data.title!
                              .substring(0, widget.data.title!.indexOf('-'))),
                          color: CustomColors.primary,
                          size: 22.w,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.appBar,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "From ${widget.data.title!.substring(0, widget.data.title!.indexOf('-'))}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.data.title!.substring(widget.data.title!.indexOf('-') + 1)}.mp4",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        " ${((widget.data.filesize as int) * 0.00000095367432).toStringAsFixed(2)} MB",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () async {
                        await Share.shareFiles([widget.path]);
                      },
                      icon: Icon(
                        FontAwesome5.share,
                        color: CustomColors.white,
                        size: 16.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => widget.onVideoDeleted(),
                      icon: Icon(
                        FontAwesome5.trash,
                        color: CustomColors.white,
                        size: 16.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyBannerAd(
                type: MyBannerType.full,
                adUnitId: AdHelper.videoCardBannerAdUnitId),
          ],
        ),
      ],
    );
  }
}
