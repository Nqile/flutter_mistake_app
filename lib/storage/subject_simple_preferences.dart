import 'package:shared_preferences/shared_preferences.dart';

class SubjectSimplePreferences {
  static SharedPreferences _preferences =
      SharedPreferences.getInstance() as SharedPreferences;

  static const _keySubjects = 'subjects';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setSubjects(List<String> subjects) async {
    await _preferences.setStringList(_keySubjects, subjects);
  }

  static List<String>? getSubjects() =>
      _preferences.getStringList(_keySubjects);
}
