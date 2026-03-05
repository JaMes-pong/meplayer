import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'screens/folder_picker_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  runApp(const MePrivacyPlayerApp());
}

class MePrivacyPlayerApp extends StatelessWidget {
  const MePrivacyPlayerApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MePlayer, Privacy first',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FolderPickerScreen(),
    );
  }
}