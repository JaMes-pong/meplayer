import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  double defaultVolume = 100.0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    defaultVolume = prefs.getDouble('defaultVolume') ?? 100.0;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('defaultVolume', defaultVolume);
  }
}
