import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final File file;
  const ImageViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: Center(child: Image.file(file)));
  }
}
