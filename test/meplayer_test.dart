import 'package:test/test.dart';
import 'package:meplayer/utils/media_utils.dart';

void main() {
  group('MediaUtils', () {
    test('detects video files', () {
      expect(MediaUtils.getMediaType('movie.mp4'), MediaType.video);
      expect(MediaUtils.getMediaType('clip.mkv'), MediaType.video);
      expect(MediaUtils.getMediaType('film.avi'), MediaType.video);
    });

    test('detects audio files', () {
      expect(MediaUtils.getMediaType('song.mp3'), MediaType.audio);
      expect(MediaUtils.getMediaType('track.flac'), MediaType.audio);
    });

    test('detects image files', () {
      expect(MediaUtils.getMediaType('photo.jpg'), MediaType.image);
      expect(MediaUtils.getMediaType('pic.png'), MediaType.image);
    });

    test('rejects unsupported files', () {
      expect(MediaUtils.getMediaType('doc.pdf'), MediaType.unsupported);
      expect(MediaUtils.getMediaType('sheet.xlsx'), MediaType.unsupported);
    });

    test('isSupportedMedia returns false for unsupported', () {
      expect(MediaUtils.isSupportedMedia('readme.txt'), false);
      expect(MediaUtils.isSupportedMedia('video.mp4'), true);
    });
  });
}
