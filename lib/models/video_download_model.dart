// ignore_for_file: unnecessary_getters_setters

import 'package:hm_video_downloader/models/video_quality_model.dart';

class VideoDownloadModel {
  String? _title;
  String? _source;
  String? _thumbnail;
  List<VideoQualityModel>? _videos;

  VideoDownloadModel(
      {String? title,
      String? source,
      String? duration,
      String? thumbnail,
      List<VideoQualityModel>? videos}) {
    if (title != null) {
      _title = title;
    }
    if (source != null) {
      _source = source;
    }

    if (thumbnail != null) {
      _thumbnail = thumbnail;
    }
    if (videos != null) {
      _videos = videos;
    }
  }

  String? get title => _title;
  set title(String? title) => _title = title;
  String? get source => _source;
  set source(String? source) => _source = source;

  String? get thumbnail => _thumbnail;
  set thumbnail(String? thumbnail) => _thumbnail = thumbnail;
  List<VideoQualityModel>? get videos => _videos;
  set videos(List<VideoQualityModel>? videos) => _videos = videos;

  VideoDownloadModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _source = json['source'];

    _thumbnail = json['thumbnail'];
    _videos = json['videos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = _title;
    data['source'] = _source;

    data['thumbnail'] = _thumbnail;
    data['videos'] = _videos;

    return data;
  }
}
