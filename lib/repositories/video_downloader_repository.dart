import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hm_video_downloader/data/video_downloader_api.dart';
import 'package:hm_video_downloader/models/video_download_model.dart';
import 'package:hm_video_downloader/models/video_quality_model.dart';
import 'package:insta_extractor/insta_extractor.dart';

class VideoDownloaderRepository {
  VideoDownloaderAPI api = VideoDownloaderAPI(
    apiKey: "e280a2cbbcmsh2cdb4231e2c4f66p1abbecjsn94c0c8448e7d",
  );

  Future<VideoDownloadModel?> getAvailableYTVideos(String url) async {
    try {
      var _response = await api.getYouTubeVideoLinks(url);

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
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableFBVideos(String url) async {
    try {
      var _response = await api.getFacebookVideoLinks(url);

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
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableTWVideos(String url) async {
    try {
      var _response = await api.getTwitterVideoLinks(url);

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
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }

  Future<VideoDownloadModel?> getAvailableIGVideos(String url) async {
    try {
      var _response = await InstaExtractor.getDetails(url);

      if (_response.shortcodeMedia.content.isVideo) {
        return VideoDownloadModel.fromJson({
          "title": _response.shortcodeMedia.owner.username,
          "source": url,
          "thumbnail": _response.shortcodeMedia.content.displayUrl,
          "videos": [
            VideoQualityModel(
              url: _response.shortcodeMedia.content.videoUrl,
              quality: "720",
            )
          ],
        });
      } else {
        return null;
      }
    } on Exception catch (e) {
      debugPrint("Exception occured $e");
      return null;
    }
  }
}

enum VideoType { youtube, facebook, twitter, instagram, none }
