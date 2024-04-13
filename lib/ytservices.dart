// lib/utils/youtube_utils.dart

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

String getThumbnail({
  required String videoId,
  String quality = 'mqdefault',
  bool webp = true,
}) =>
    webp
        ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
        : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

Future<Map<String, dynamic>> fetchVideoDetails(String videoUrl) async {
  final yt = YoutubeExplode();
  try {
    final videoId = convertUrlToId(videoUrl);
    if (videoId == null) throw Exception('Invalid YouTube URL');

    final videoDetails = await yt.videos.get(videoId);
    final thumbnailUrl = getThumbnail(videoId: videoId);
    final title = videoDetails.title;
    final description = videoDetails.description;

    return {
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'description': description,
    };
  } catch (e) {
    print('Error fetching video details: $e');
    return {'thumbnailUrl': '', 'title': '', 'description': ''};
  } finally {
    yt.close();
  }
}
