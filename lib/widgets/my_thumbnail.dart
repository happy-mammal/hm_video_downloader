import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/custom_colors.dart';

class MyThumbnail extends StatefulWidget {
  final String path;
  final VideoData data;
  final VoidCallback onVideoDeleted;
  const MyThumbnail({
    Key? key,
    required this.path,
    required this.data,
    required this.onVideoDeleted,
  }) : super(key: key);

  @override
  State<MyThumbnail> createState() => _MyThumbnailState();
}

class _MyThumbnailState extends State<MyThumbnail> {
  Future<Uint8List?> _generateImageMemory(path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: widget.data.width!,
      maxHeight: widget.data.height!,
      timeMs: 3000,
      quality: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder(
          future: _generateImageMemory(widget.path),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Image.memory(
                snapshot.data as Uint8List,
                width: 100.w,
                height: 100.h,
                cacheHeight: widget.data.height,
                cacheWidth: widget.data.width,
                fit: BoxFit.cover,
              );
            } else {
              return Container();
            }
          }),
        ),
        Container(
          color: Colors.black12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await Share.shareFiles([widget.path]);
                  },
                  icon: Icon(
                    FontAwesome5.share,
                    color: CustomColors.white,
                    size: 16.w,
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onVideoDeleted(),
                  icon: Icon(
                    FontAwesome5.trash,
                    color: CustomColors.white,
                    size: 16.w,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    " ${widget.data.title!.substring(0, widget.data.title!.indexOf('-'))}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " ${((widget.data.filesize as int) * 0.00000095367432).toStringAsFixed(2)} MB",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
