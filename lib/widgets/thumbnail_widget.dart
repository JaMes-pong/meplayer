import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../utils/media_utils.dart';
import '../utils/thumbnail_utils.dart';

class ThumbnailWidget extends StatefulWidget {
  final File file;
  final double size;
  const ThumbnailWidget({required this.file, required this.size});

  @override
  State<ThumbnailWidget> createState() => ThumbnailWidgetState();
}

class ThumbnailWidgetState extends State<ThumbnailWidget> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = ThumbnailUtils.getThumbnail(widget.file);
  }

  @override
  Widget build(BuildContext context) {
    final type = MediaUtils.getMediaType(widget.file.path);

    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (snap.data != null) {
          return Image.memory(
            snap.data!,
            fit: BoxFit.cover,
            width: widget.size == double.infinity ? null : widget.size,
            height: widget.size == double.infinity ? null : widget.size,
          );
        }
        // Fallback icon if thumbnail fails
        return Icon(
          MediaUtils.iconFor(type),
          size: widget.size == double.infinity ? 40 : widget.size,
        );
      },
    );
  }
}
