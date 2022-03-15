import 'dart:convert';

import 'package:http/http.dart' as http;

class VideoDownloaderAPI {
  final String _apiKey = "e280a2cbbcmsh2cdb4231e2c4f66p1abbecjsn94c0c8448e7d";
  final String _apiType = "application/json";

  final List<String> _hosts = const [
    "facebook17.p.rapidapi.com",
    "youtube86.p.rapidapi.com",
    "twitter65.p.rapidapi.com",
    "tik-tok2.p.rapidapi.com",
    "instagram120.p.rapidapi.com",
  ];

  final List<String> _endpoints = const [
    "/api/facebook/links",
    "/api/youtube/links",
    "/api/twitter/links",
    "/api/tiktok/links",
    "/api/instagram/links",
  ];

  Future<http.Response> getFacebookVideoLinks(String url) async {
    Uri _url = Uri.parse("https://${_hosts[0]}${_endpoints[0]}");
    Map<String, String> _headers = {
      "content-type": _apiType,
      "x-rapidapi-host": _hosts[0],
      "x-rapidapi-key": _apiKey,
    };
    String _body = jsonEncode({"url": url});

    return await http.post(_url, headers: _headers, body: _body);
  }

  Future<http.Response> getYouTubeVideoLinks(String url) async {
    Uri _url = Uri.parse("https://${_hosts[1]}${_endpoints[1]}");
    Map<String, String> _headers = {
      "content-type": _apiType,
      "x-rapidapi-host": _hosts[1],
      "x-rapidapi-key": _apiKey,
    };
    String _body = jsonEncode({"url": url});
    return await http.post(_url, headers: _headers, body: _body);
  }

  Future<http.Response> getTwitterVideoLinks(String url) async {
    Uri _url = Uri.parse("https://${_hosts[2]}${_endpoints[2]}");
    Map<String, String> _headers = {
      "content-type": _apiType,
      "x-rapidapi-host": _hosts[2],
      "x-rapidapi-key": _apiKey,
    };
    String _body = jsonEncode({"url": url});
    return await http.post(_url, headers: _headers, body: _body);
  }

  Future<http.Response> getTikTokVideoLinks(String url) async {
    Uri _url = Uri.parse("https://${_hosts[3]}${_endpoints[3]}");
    Map<String, String> _headers = {
      "content-type": _apiType,
      "x-rapidapi-host": _hosts[3],
      "x-rapidapi-key": _apiKey,
    };
    String _body = jsonEncode({"url": url});
    return await http.post(_url, headers: _headers, body: _body);
  }

  Future<http.Response> getInstagramVideoLinks(String url) async {
    Uri _url = Uri.parse("https://${_hosts[4]}${_endpoints[4]}");
    Map<String, String> _headers = {
      "content-type": _apiType,
      "x-rapidapi-host": _hosts[4],
      "x-rapidapi-key": _apiKey,
    };
    String _body = jsonEncode({"url": url});
    return await http.post(_url, headers: _headers, body: _body);
  }
}
