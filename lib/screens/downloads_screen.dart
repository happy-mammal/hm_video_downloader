import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:hm_video_downloader/widgets/my_thumbnail.dart';

class DownloadsScreen extends StatefulWidget {
  final List<VideoData> videoData;
  final List<FileSystemEntity> downloads;
  final VoidCallback onVideoDeleted;
  final ValueChanged<int> onCardTap;
  const DownloadsScreen({
    Key? key,
    required this.videoData,
    required this.downloads,
    required this.onVideoDeleted,
    required this.onCardTap,
  }) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
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

        widget.onVideoDeleted();
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
    return widget.downloads.isEmpty
        ? Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 50.w,
                  color: CustomColors.primary,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Hmmm.... it seems like you have no downloaded videos. Please download some videos and come back later.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: CustomColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: widget.downloads.length,
              padding: EdgeInsets.symmetric(vertical: 5.h),
              itemBuilder: (context, index) {
                int _reverseIndex = widget.downloads.length - 1 - index;
                return InkWell(
                  onTap: () => widget.onCardTap(_reverseIndex),
                  child: MyThumbnail(
                    path: widget.downloads[_reverseIndex].path,
                    data: widget.videoData[_reverseIndex],
                    onVideoDeleted: () {
                      _showAlertDialog(context, _reverseIndex);
                    },
                  ),
                );
              },
            ),
          );
  }
}
