import 'package:flutter/material.dart';

enum MediaType { video, audio, image, unsupported }

class MediaUtils {
  static const _videoExt = ['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm'];
  static const _audioExt = ['mp3', 'aac', 'flac', 'wav', 'ogg', 'm4a', 'wma'];
  static const _imageExt = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'tiff'];

  static String _ext(String path) => path.split('.').last.toLowerCase();

  static bool isSupportedMedia(String path) =>
      getMediaType(path) != MediaType.unsupported;

  static MediaType getMediaType(String path) {
    final ext = _ext(path);
    if (_videoExt.contains(ext)) return MediaType.video;
    if (_audioExt.contains(ext)) return MediaType.audio;
    if (_imageExt.contains(ext)) return MediaType.image;
    return MediaType.unsupported;
  }

  static IconData iconFor(MediaType type) {
    switch (type) {
      case MediaType.video:
        return Icons.videocam;
      case MediaType.audio:
        return Icons.audiotrack;
      case MediaType.image:
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
