import 'dart:io';
import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storage_space/storage_space.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  double _consumed = 0.0;
  String _fs1 = "";
  String _fs2 = "";
  @override
  void initState() {
    _getDiskSpace();
    super.initState();
  }

  _getDiskSpace() async {
    final videoInfo = FlutterVideoInfo();
    var _occupied = 0;
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    final myDir = Directory(dir);
    List<FileSystemEntity> _folders =
        myDir.listSync(recursive: true, followLinks: false);
    for (var item in _folders) {
      if (item.path.contains(".mp4")) {
        var _info = await videoInfo.getVideoInfo(item.path);
        _occupied += _info!.filesize!;
      }
    }

    StorageSpace freeSpace = await getStorageSpace(
      lowOnSpaceThreshold: 2 * 1024 * 1024 * 1024, // 2GB
      fractionDigits: 1,
    );

    setState(() {
      _fs1 = FileSize.getGigaBytes(freeSpace.free);
      _fs2 = FileSize.getSize(_occupied);

      _consumed = (_occupied * 100) / freeSpace.free;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Developer",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: CustomColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: CustomColors.primary,
                        size: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Happy Mammal",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.open_in_new_rounded,
                        color: CustomColors.primary,
                        size: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Check out other apps",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: CustomColors.appBar,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "App",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: CustomColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.update_rounded,
                        color: CustomColors.primary,
                        size: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Version 1.0",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.policy_rounded,
                        color: CustomColors.primary,
                        size: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Privacy Policy",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: CustomColors.appBar,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Can you please",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: CustomColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.rate_review_rounded,
                        color: CustomColors.primary,
                        size: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Rate & Review Us",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.ios_share_rounded,
                        color: CustomColors.primary,
                        size: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Share with your friends",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: CustomColors.appBar,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Storage",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: CustomColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _fs1,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "available",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  LinearProgressIndicator(
                    value: _consumed,
                    minHeight: 8.h,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$_fs2 used by app",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        _fs1,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: CustomColors.appBar,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
