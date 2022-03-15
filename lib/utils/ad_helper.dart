import 'package:hm_video_downloader/utils/constants.dart';

class AdHelper {
  //BANNER
  static String get downloaderScreenBannerAdUnitId {
    if (kIsDebug) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      return "ca-app-pub-3215909327537946/6501471771";
    }
  }

  //BANNER
  static String get downloadsScreenBannerAdUnitId {
    if (kIsDebug) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      return "ca-app-pub-3215909327537946/3910967450";
    }
  }

  //BANNER
  static String get videoCardBannerAdUnitId {
    if (kIsDebug) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      return "ca-app-pub-3215909327537946/6118328394";
    }
  }

  //INTERSTITIAL
  static String get downloadInterstialAdUnitId {
    if (kIsDebug) {
      return "ca-app-pub-3940256099942544/8691691433";
    } else {
      return "ca-app-pub-3215909327537946/4613675038";
    }
  }

  //INTERSTITIAL
  static String get navigateInterstialAdUnitId {
    if (kIsDebug) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      return "ca-app-pub-3215909327537946/4857217619";
    }
  }
}
