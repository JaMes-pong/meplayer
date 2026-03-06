import 'package:flutter/material.dart';
import '../utils/app_settings.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final _settings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [Icon(Icons.settings), SizedBox(width: 8), Text('Settings')],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SettingSection(
              title: 'Playback',
              children: [
                _SettingRow(
                  label: 'Default Volume',
                  hint: '${_settings.defaultVolume.toInt()}%',
                  child: Slider(
                    value: _settings.defaultVolume,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_settings.defaultVolume.toInt()}%',
                    onChanged: (v) {
                      setState(() => _settings.defaultVolume = v);
                      _settings.save();
                    },
                  ),
                ),
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

class _SettingSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const Divider(),
        ...children,
        const SizedBox(height: 12),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String hint;
  final Widget child;

  const _SettingRow({
    required this.label,
    required this.hint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(child: child),
        SizedBox(
          width: 36,
          child: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
