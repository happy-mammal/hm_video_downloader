import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/models/video_quality_model.dart';
import 'package:hm_video_downloader/repositories/video_downloader_repository.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';

class VideoQualityCard extends StatefulWidget {
  final VideoQualityModel model;
  final VoidCallback onTap;
  final VideoType type;
  final bool isSelected;
  const VideoQualityCard({
    Key? key,
    required this.model,
    required this.onTap,
    required this.type,
    required this.isSelected,
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
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(width: 1, color: CustomColors.primary),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isSelected
                ? Icon(
                    FontAwesome5.check_circle,
                    color: CustomColors.primary,
                    size: 20.w,
                  )
                : Icon(
                    _qualityValue! < 720 ? Icons.sd : Icons.hd_rounded,
                    color: CustomColors.primary,
                    size: 28.w,
                  ),
            SizedBox(width: 5.w),
            Text(
              (widget.type == VideoType.youtube ||
                      widget.type == VideoType.twitter)
                  ? "${_qualityValue}P"
                  : _quality!,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: CustomColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }
}
