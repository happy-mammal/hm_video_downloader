import 'dart:io';
import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/screens/about_us_screen.dart';
import 'package:hm_video_downloader/screens/downloads_screen.dart';
import 'package:hm_video_downloader/screens/home_screen.dart';
import 'package:hm_video_downloader/screens/video_reels_screen.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final PageController _pageController = PageController();
  final FileManagerController controller = FileManagerController();
  List<VideoData> _videoData = [];
  List<FileSystemEntity> _downloads = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    _getDownloads();
    super.initState();
  }

  Future<void> _getDownloads() async {
    setState(() {
      _downloads = [];
      _videoData = [];
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.backGround,
        elevation: 0,
        title: Text(
          "HM Video Downloader",
          style: GoogleFonts.poppins(
            fontSize: 26,
            color: CustomColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(
            onDownloadCompleted: () => _getDownloads(),
          ),
          DownloadsScreen(
            downloads: _downloads,
            videoData: _videoData,
            onVideoDeleted: () => _getDownloads(),
            onCardTap: (index) {
              setState(() {
                _selectedIndex = 2;
              });

              _pageController.jumpToPage(_selectedIndex);
            },
          ),
          VideoReelsScreen(
            downloads: _downloads,
            videoData: _videoData,
            onVideoDeleted: () {
              setState(() {
                _selectedIndex = 1;
              });
              _pageController.jumpToPage(_selectedIndex);
              _getDownloads();
            },
          ),
          const AboutUsScreen(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: CustomColors.backGround,
        bottomPadding: 12.h,
        waterDropColor: CustomColors.primary,
        inactiveIconColor: CustomColors.primary,
        iconSize: 28.w,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);

          _pageController.jumpToPage(_selectedIndex);
        },
        selectedIndex: _selectedIndex,
        barItems: [
          BarItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.file_download,
            outlinedIcon: Icons.download_outlined,
          ),
          BarItem(
            filledIcon: Icons.video_library_rounded,
            outlinedIcon: Icons.video_library_outlined,
          ),
          BarItem(
            filledIcon: Icons.info,
            outlinedIcon: Icons.info_outlined,
          ),
        ],
      ),
    );
  }
}
