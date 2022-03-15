import 'dart:convert';
import 'package:hm_video_downloader/data/video_downloader_api.dart';
import 'package:hm_video_downloader/models/video_download_model.dart';
import 'package:hm_video_downloader/models/video_quality_model.dart';

class VideoDownloaderRepository {
  late VideoDownloaderAPI _api;

  VideoDownloaderRepository(this._api) {
    _api = VideoDownloaderAPI();
  }

  Future<VideoDownloadModel?> getAvailableYTVideos(String url) async {
    var _response = await _api.getYouTubeVideoLinks(url);

    if (_response.statusCode == 200) {
      var _result = Map.from(jsonDecode(_response.body));

      List<VideoQualityModel> _links = [];

      for (var _link in _result['url']) {
        if (_link["ext"] == "mp4" && _link["downloadable"] == true) {
          _links.add(VideoQualityModel.fromJson({
            "url": _link['url'],
            "quality": _link['quality'],
          }));
        }
      }

      return VideoDownloadModel.fromJson({
        "title": _result['meta']['title'],
        "source": _result['meta']['source'],
        "thumbnail": _result['thumb'],
        "videos": _links,
      });
    } else {
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableFBVideos(String url) async {
    var _response = await _api.getFacebookVideoLinks(url);

    if (_response.statusCode == 200) {
      var _result = Map.from(jsonDecode(_response.body));

      List<VideoQualityModel> _links = [];

      for (var _link in _result['url']) {
        if (_link["ext"] == "mp4") {
          _links.add(VideoQualityModel.fromJson({
            "url": _link['url'],
            "quality": _link['subname'],
          }));
        }
      }

      return VideoDownloadModel.fromJson({
        "title": _result['meta']['title'],
        "source": _result['meta']['source'],
        "thumbnail": _result['thumb'],
        "videos": _links,
      });
    } else {
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableTWVideos(String url) async {
    var _response = await _api.getTwitterVideoLinks(url);

    if (_response.statusCode == 200) {
      var _result = Map.from(jsonDecode(_response.body));

      List<VideoQualityModel> _links = [];

      for (var _link in _result['url']) {
        if (_link["ext"] == "mp4") {
          _links.add(VideoQualityModel.fromJson({
            "url": _link['url'],
            "quality": _link['quality'].toString(),
          }));
        }
      }

      return VideoDownloadModel.fromJson({
        "title": _result['meta']['title'],
        "source": _result['meta']['source'],
        "thumbnail": _result['thumb'],
        "videos": _links,
      });
    } else {
      return null;
    }
  }
}

enum VideoType { youtube, facebook, twitter }
