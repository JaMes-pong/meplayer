import 'package:flutter/material.dart';

class ShortcutsHelpDialog extends StatelessWidget {
  const ShortcutsHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.keyboard),
          SizedBox(width: 8),
          Text('Keyboard Shortcuts'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ShortcutSection(
              title: 'Navigation',
              shortcuts: const [
                _ShortcutRow(keys: '↑ / ↓', description: 'Previous / Next file'),
              ],
            ),
            _ShortcutSection(
              title: 'Video & Audio',
              shortcuts: const [
                _ShortcutRow(keys: 'Space', description: 'Play / Pause'),
                _ShortcutRow(keys: '← / →', description: 'Backward / Forward 10s'),
                _ShortcutRow(keys: 'M', description: 'Mute toggle'),
                _ShortcutRow(keys: '[ / ]', description: 'Volume -/+ 5%'),
                _ShortcutRow(keys: 'S', description: 'Cycle playback speed'),
                _ShortcutRow(keys: 'F', description: 'Toggle fullscreen'),
                _ShortcutRow(keys: 'R', description: 'Restart'),
              ],
            ),
            _ShortcutSection(
              title: 'Image',
              shortcuts: const [
                _ShortcutRow(keys: '+ / -', description: 'Zoom in / out'),
                _ShortcutRow(keys: '0', description: 'Reset zoom & position'),
                _ShortcutRow(keys: 'L', description: 'Rotate left 90°'),
                _ShortcutRow(keys: 'R', description: 'Rotate right 90°'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ShortcutSection extends StatelessWidget {
  final String title;
  final List<_ShortcutRow> shortcuts;

  const _ShortcutSection({
    required this.title,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const Divider(),
        ...shortcuts,
        const SizedBox(height: 4),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  final String keys;
  final String description;

  const _ShortcutRow({
    required this.keys,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              keys,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(description, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
