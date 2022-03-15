import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_video_downloader/screens/home_screen.dart';
import 'package:hm_video_downloader/utils/custom_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGround,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "HM",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 80,
                      color: CustomColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Video Downloader",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: CustomColors.primary,
                      size: 130.w,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Very fast, secure and 100% free.",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Supports",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 50,
                      color: CustomColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "multiple",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 35,
                          color: CustomColors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Source",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 45,
                          color: CustomColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "HM Video Downloader is the easiest application to download videos from Facebook, YouTube and Twitter.",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
