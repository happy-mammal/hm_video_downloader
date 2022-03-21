import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/screens/about_us_screen.dart';
import 'package:hm_video_downloader/screens/downloads_screen.dart';
import 'package:hm_video_downloader/screens/home_screen.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.appBar,
        elevation: 0,
        title: Text(
          "HM Video Downloader",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: CustomColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          DownloadsScreen(),
          AboutUsScreen(),
        ],
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: CustomColors.appBar,
        bottomPadding: 14.h,
        waterDropColor: CustomColors.primary,
        inactiveIconColor: CustomColors.primary,
        iconSize: 30.w,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // _pageController.animateToPage(_selectedIndex,
          //     duration: const Duration(milliseconds: 400),
          //     curve: Curves.easeOutQuad);
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
