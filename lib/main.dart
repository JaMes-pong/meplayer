import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meplayer/screens/media_browser_screen.dart';
import 'package:meplayer/utils/app_settings.dart';
import 'screens/folder_picker_screen.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  await AppSettings().load();

  final String? openFilePath = args.isNotEmpty ? args[0] : null;

  runApp(MePrivacyPlayerApp(openFilePath: openFilePath));
}

class MePrivacyPlayerApp extends StatelessWidget {
  final String? openFilePath;
  const MePrivacyPlayerApp({ super.key, this.openFilePath });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MePlayer, Privacy first',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: openFilePath != null ? MediaBrowserScreen.fromFile(openFilePath!) : const FolderPickerScreen(),
    );
  }
}