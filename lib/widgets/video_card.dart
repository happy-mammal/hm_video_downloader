import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

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
  String? _timeago;
  VideoPlayerController? _controller;

  @override
  void initState() {
    var _file = File(widget.path);
    _controller = VideoPlayerController.file(_file)
      ..addListener(() {})
      ..setLooping(true)
      ..initialize().then((value) {
        setState(() {});
        _controller!.play();
      });
    var _date = (widget.data.title!.split("-"))[1].substring(0, 8);
    var _time = (widget.data.title!.split("-"))[1].substring(8);
    _timeago = timeago.format(DateTime.parse("${_date}T$_time"));
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        (_controller != null && _controller!.value.isInitialized)
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
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
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                          setState(() {});
                        },
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? FontAwesome5.pause
                              : FontAwesome5.play,
                          color: CustomColors.white,
                          size: 16.w,
                        ),
                      ),
                      SizedBox(
                        width: 240.w,
                        height: 5.h,
                        child: VideoProgressIndicator(
                          _controller!,
                          padding: EdgeInsets.zero,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: CustomColors.primary,
                            backgroundColor: CustomColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      await Share.shareFiles([widget.path]);
                    },
                    icon: Icon(
                      FontAwesome5.share,
                      color: CustomColors.white,
                      size: 20.w,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  IconButton(
                    onPressed: () => widget.onVideoDeleted(),
                    icon: Icon(
                      FontAwesome5.trash,
                      color: CustomColors.white,
                      size: 20.w,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

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
}
