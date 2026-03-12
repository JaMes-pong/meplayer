import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final File file;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  const ImageViewer({super.key, required this.file, this.onNext, this.onPrev});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final TransformationController _transformController =
      TransformationController();
  int _rotationQuarters = 0; // 0, 1, 2, 3 -> 0', 90', 180', 270'

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _rotateLeft() {
    setState(() {
      _rotationQuarters = (_rotationQuarters - 1) % 4;
    });
  }

  void _rotateRight() {
    setState(() {
      _rotationQuarters = (_rotationQuarters + 1) % 4;
    });
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prev file
              IconButton(
                icon: const Icon(Icons.skip_previous),
                tooltip: 'Previous file',
                onPressed: widget.onPrev,
              ),
              IconButton(
                icon: const Icon(Icons.rotate_left),
                tooltip: 'Rotate left',
                onPressed: _rotateLeft,
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                tooltip: 'Rotate right',
                onPressed: _rotateRight,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                tooltip: 'Zoom in',
                onPressed: () {
                  final matrix = _transformController.value.clone();
                  matrix.scale(1.2);
                  _transformController.value = matrix;
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                tooltip: 'Zoom out',
                onPressed: () {
                  final matrix = _transformController.value.clone();
                  matrix.scale(0.8);
                  _transformController.value = matrix;
                },
              ),
              IconButton(
                icon: const Icon(Icons.fit_screen),
                tooltip: 'Reset zoom & position',
                onPressed: _resetZoom,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                tooltip: 'Next file',
                onPressed: widget.onNext,
              ),
            ],
          ),
        ),

        // Image
        Expanded(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 0.1,
            maxScale: 10.0,
            child: Center(
              child: RotatedBox(
                quarterTurns: _rotationQuarters,
                child: Image.file(widget.file, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
