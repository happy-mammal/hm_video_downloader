import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/models/video_quality_model.dart';
import 'package:hm_video_downloader/repositories/video_downloader_repository.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';

class VideoQualityCard extends StatefulWidget {
  final VideoQualityModel model;
  final VoidCallback onTap;
  final VideoType type;
  const VideoQualityCard({
    Key? key,
    required this.model,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  State<VideoQualityCard> createState() => _VideoQualityCardState();
}

class _VideoQualityCardState extends State<VideoQualityCard> {
  String? get _quality {
    switch (widget.type) {
      case VideoType.facebook:
        if (widget.model.quality == "hd" || widget.model.quality == "HD") {
          return "High Defination";
        } else {
          return "Standard Defination";
        }

      case VideoType.twitter:
        return widget.model.quality;

      case VideoType.youtube:
        return widget.model.quality;

      case VideoType.instagram:
        return widget.model.quality;

      default:
        return null;
    }
  }

  int? get _qualityValue {
    switch (widget.type) {
      case VideoType.facebook:
        if (_quality == "High Defination") {
          return 720;
        } else {
          return 360;
        }

      case VideoType.twitter:
        return int.parse(
            widget.model.quality!.substring(_quality!.indexOf(":") + 1));

      case VideoType.youtube:
        return int.parse(
            widget.model.quality!.substring(_quality!.indexOf(":") + 1));

      case VideoType.instagram:
        return int.parse(
            widget.model.quality!.substring(_quality!.indexOf(":") + 1));

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: CustomColors.appBar,
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesome.file_video,
                    color: CustomColors.primary,
                    size: 30.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: CustomColors.backGround,
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Video Quality",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: CustomColors.white,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.type == VideoType.youtube
                              ? "${_qualityValue}p"
                              : _quality!,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: CustomColors.white,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          _qualityValue! < 720 ? Icons.sd : Icons.hd_rounded,
                          color: CustomColors.primary,
                          size: 28.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
