import 'dart:io';
import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/screens/video_reels_screen.dart';
import 'package:hm_video_downloader/utils/ad_helper.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:hm_video_downloader/widgets/my_banner_ad.dart';
import 'package:hm_video_downloader/widgets/my_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final FileManagerController controller = FileManagerController();
  List<FileSystemEntity> _downloads = [];
  final List<VideoData> _videoData = [];

  @override
  void initState() {
    _getDownloads();
    super.initState();
  }

  Future<void> _getDownloads() async {
    final videoInfo = FlutterVideoInfo();
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    final myDir = Directory(dir);
    List<FileSystemEntity> _data = [];
    List<FileSystemEntity> _folders =
        myDir.listSync(recursive: true, followLinks: false);

    for (var item in _folders) {
      if (item.path.contains(".mp4")) {
        _data.add(item);
        var _info = await videoInfo.getVideoInfo(item.path);
        _videoData.add(_info!);
      }
    }
    setState(() => _downloads = _data);
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
          final file = File(_downloads[index].path);
          await file.delete();
        } catch (e) {
          debugPrint(e.toString());
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');

        _getDownloads();
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
    return Scaffold(
      backgroundColor: CustomColors.backGround,
      appBar: AppBar(
        backgroundColor: CustomColors.appBar,
        iconTheme: IconThemeData(color: CustomColors.primary),
        title: Text(
          "Downloaded Videos",
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: CustomColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            MyBannerAd(
                type: MyBannerType.large,
                adUnitId: AdHelper.downloadsScreenBannerAdUnitId),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemCount: _downloads.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoReelsScreen(
                          initialIndex: index,
                          downloads: _downloads,
                          videoData: _videoData,
                        ),
                      ),
                    );
                  },
                  child: MyThumbnail(
                    path: _downloads[index].path,
                    data: _videoData[index],
                    onVideoDeleted: () {
                      _showAlertDialog(context, index);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
