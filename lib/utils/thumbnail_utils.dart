import 'dart:io';
import 'dart:typed_data';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'media_utils.dart';

class ThumbnailUtils {
  // In-memory cache: path -> bytes (never written to disk permanently)
  static final Map<String, Uint8List?> _cache = {};
  static final _plugin = FcNativeVideoThumbnail();

  static Future<Uint8List?> getThumbnail(File file) async {
    final path = file.path;
    if (_cache.containsKey(path)) return _cache[path];

    Uint8List? thumb;
    final type = MediaUtils.getMediaType(path);

    try {
      if (type == MediaType.video) {
        // fc_native_video_thumbnail needs a temp dest file
        final tempDir = await getTemporaryDirectory();
        final destPath = p.join(
          tempDir.path,
          '${p.basenameWithoutExtension(path)}_thumb.jpeg',
        );

        final success = await _plugin.getVideoThumbnail(
          srcFile: path,
          destFile: destPath,
          width: 160,
          height: 160,
          format: 'jpeg',
          quality: 70,
        );

        if (success) {
          thumb = await File(destPath).readAsBytes();
          // Delete temp file immediately — keep memory only
          await File(destPath).delete();
        }
      } else if (type == MediaType.image) {
        thumb = await file.readAsBytes();
      }
    } catch (_) {
      thumb = null; // fail silently, fallback icon will show
    }

    _cache[path] = thumb;
    return thumb;
  }

  static void clearCache() => _cache.clear();
}
