import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/media_utils.dart';
import '../widgets/video_player_view.dart';
import '../widgets/image_viewer.dart';
import 'folder_picker_screen.dart';
import '../widgets/thumbnail_widget.dart';

class MediaBrowserScreen extends StatefulWidget {
  final String rootPath;
  final String? initialFilePath;

  const MediaBrowserScreen({
    super.key,
    required this.rootPath,
    this.initialFilePath,
  });

  factory MediaBrowserScreen.fromFile(String filePath) {
    final parentFolder = File(filePath).parent.path;

    return MediaBrowserScreen(
      rootPath: parentFolder,
      initialFilePath: filePath,
    );
  }

  @override
  State<MediaBrowserScreen> createState() => _MediaBrowserScreenState();
}

class _MediaBrowserScreenState extends State<MediaBrowserScreen> {
  int _selectedIndex = -1;
  late final FocusNode _focusNode;
  late String _currentPath;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _currentPath = widget.rootPath;

    if (widget.initialFilePath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final entries = _entries;
        final mediaFiles = entries.whereType<File>().toList();
        final idx = mediaFiles.indexWhere(
          (f) => f.path == widget.initialFilePath,
        );

        if (idx != -1) {
          setState(() {
            _selectedIndex = idx;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<FileSystemEntity> get _entries {
    return Directory(_currentPath)
        .listSync()
        .where(
          (e) =>
              e is Directory ||
              (e is File && MediaUtils.isSupportedMedia(e.path)),
        )
        .toList()
      ..sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return a.path.compareTo(b.path);
      });
  }

  bool get _canGoUp => _currentPath != widget.rootPath;

  void _navigate(int delta) {
    final mediaFiles = _entries.whereType<File>().toList();
    if (mediaFiles.isEmpty) return;
    setState(() {
      _selectedIndex = (_selectedIndex + delta).clamp(0, mediaFiles.length - 1);
    });
  }

  void _enterFolder(String path) {
    setState(() {
      _currentPath = path;
      _selectedIndex = -1; // reset selection when entering folder
    });
  }

  void _goUp() {
    if (!_canGoUp) return;
    setState(() {
      _currentPath = Directory(_currentPath).parent.path;
      _selectedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries; // all entries (folders + files)
    final mediaFiles =
        entries.whereType<File>().toList(); // files only, for player

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (evt) {
        if (evt is KeyDownEvent) {
          if (evt.logicalKey == LogicalKeyboardKey.arrowRight ||
              evt.logicalKey == LogicalKeyboardKey.arrowDown) {
            _navigate(1);
          } else if (evt.logicalKey == LogicalKeyboardKey.arrowLeft ||
              evt.logicalKey == LogicalKeyboardKey.arrowUp) {
            _navigate(-1);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _currentPath.replaceFirst(widget.rootPath, '').isEmpty
                ? '/ (root)'
                : _currentPath.replaceFirst(widget.rootPath, ''),
          ),
          leading: IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Change folder',
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FolderPickerScreen()),
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
              tooltip: _isGridView ? 'List view' : 'Grid view',
              onPressed:
                  () => setState(() {
                    _isGridView = !_isGridView;
                  }),
            ),
            if (_canGoUp)
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                tooltip: 'Go up',
                onPressed: _goUp,
              ),
          ],
        ),
        body: Row(
          children: [
            // Left: file + folder list
            SizedBox(
              width: _isGridView ? 320 : 260,
              child:
                  _isGridView
                      ? _buildGridView(entries, mediaFiles)
                      : _buildListView(entries, mediaFiles),
            ),

            const VerticalDivider(width: 1),

            // Right: player/viewer
            Expanded(
              child:
                  _selectedIndex == -1 || mediaFiles.isEmpty
                      ? const Center(child: Text('Select a file to play'))
                      : _buildPlayer(mediaFiles[_selectedIndex]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer(File file) {
    final type = MediaUtils.getMediaType(file.path);
    switch (type) {
      case MediaType.video:
      case MediaType.audio:
        return VideoPlayerView(file: file, key: ValueKey(file.path));
      case MediaType.image:
        return ImageViewer(file: file);
      default:
        return const Center(child: Text('Unsupported file type'));
    }
  }

  Widget _buildListView(List<FileSystemEntity> entries, List<File> mediaFiles) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entity = entries[i];

        if (entity is Directory) {
          return ListTile(
            leading: const Icon(Icons.folder),
            title: Text(entity.path.split(r'\').last),
            onTap: () => _enterFolder(entity.path),
          );
        } else {
          final file = entity as File;
          final type = MediaUtils.getMediaType(file.path);
          // Match selectedIndex against mediaFiles (files only)
          final fileIndex = mediaFiles.indexOf(file);
          return ListTile(
            leading: Icon(MediaUtils.iconFor(type)),
            title: Text(
              file.uri.pathSegments.last,
              overflow: TextOverflow.ellipsis,
            ),
            selected: _selectedIndex == fileIndex,
            onTap: () => setState(() => _selectedIndex = fileIndex),
          );
        }
      },
    );
  }

  Widget _buildGridView(List<FileSystemEntity> entries, List<File> mediaFiles) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entity = entries[i];

        if (entity is Directory) {
          return GestureDetector(
            onTap: () => _enterFolder(entity.path),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder, size: 56, color: Colors.amber),
                const SizedBox(height: 6),
                Text(
                  entity.path.split(r'\').last,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }

        final file = entity as File;
        final fileIndex = mediaFiles.indexOf(file);
        final isSelected = _selectedIndex == fileIndex;

        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = fileIndex),
          child: Container(
            decoration: BoxDecoration(
              border:
                  isSelected ? Border.all(color: Colors.blue, width: 2) : null,
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[900],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    child: ThumbnailWidget(file: file, size: double.infinity),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    file.uri.pathSegments.last,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
