import 'dart:convert';
import 'package:athkar/models/dhikr_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _dhikrKey = 'dhikr_list';
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  Future<List<DhikrItem>> getDhikrs() async {
    final dhikrListJson = _prefs.getStringList(_dhikrKey) ?? [];
    return dhikrListJson
        .map((item) => DhikrItem.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> saveDhikrs(List<DhikrItem> dhikrs) async {
    final dhikrListJson = dhikrs
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await _prefs.setStringList(_dhikrKey, dhikrListJson);
  }

  Future<bool> getDarkMode() async {
    return _prefs.getBool('darkMode') ?? false;
  }

  Future<void> saveDarkMode(bool isDark) async {
    await _prefs.setBool('darkMode', isDark);
  }
}