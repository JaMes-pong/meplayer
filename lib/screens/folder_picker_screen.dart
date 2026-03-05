import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'media_browser_screen.dart';

class FolderPickerScreen extends StatelessWidget {
  const FolderPickerScreen({super.key});

  Future<void> _pickFolder(BuildContext context) async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select a folder',
      initialDirectory: 'C:\\',
      lockParentWindow: true,
    );

    if (path != null && context.mounted) {
      final files = Directory(path).listSync().whereType<File>().toList();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  MediaBrowserScreen(rootPath: path), // 👈 only rootPath needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'MePlayer, Privacy first',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'No history. No tracking. Select a folder to begin.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Select Folder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () => _pickFolder(context),
            ),
          ],
        ),
      ),
    );
  }
}
