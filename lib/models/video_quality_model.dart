// ignore_for_file: unnecessary_getters_setters

class VideoQualityModel {
  String? _url;
  String? _quality;

  VideoQualityModel({String? url, String? quality}) {
    if (url != null) {
      _url = url;
    }
    if (quality != null) {
      _quality = quality;
    }
  }

  String? get url => _url;
  set url(String? url) => _url = url;
  String? get quality => _quality;
  set quality(String? quality) => _quality = quality;

  VideoQualityModel.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
    _quality = json['quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = _url;
    data['quality'] = _quality;
    return data;
  }
}
