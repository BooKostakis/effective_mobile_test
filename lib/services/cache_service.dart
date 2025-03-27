import 'dart:convert';
import 'package:effective_mobile/models/character.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _charactersKey = 'characters';
  static const String _pageKey = 'page';

  Future<void> saveCharacters(List<Character> characters, int page) async {
    final prefs = await SharedPreferences.getInstance();
    // Получаем текущий кэш
    final cachedData = await getCharacters();
    final cachedCharacters = cachedData.characters;
    final cachedPage = cachedData.page;

    // Объединяем старые и новые данные
    final allCharacters = List<Character>.from(cachedCharacters)..addAll(characters);

    final jsonString = jsonEncode(allCharacters.map((e) => e.toJson()).toList());
    await prefs.setString(_charactersKey, jsonString);
    await prefs.setInt(_pageKey, page);
  }

  Future<CachedData> getCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_charactersKey);
    final page = prefs.getInt(_pageKey) ?? 1; // Если нет данных, возвращаем страницу 1
    if (jsonString == null) {
      return CachedData(characters: [], page: 1);
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final characters = jsonList.map((json) => Character.fromJson(json as Map<String, dynamic>)).toList();
    return CachedData(characters: characters, page: page);
  }
}

class CachedData {
  final List<Character> characters;
  final int page;

  CachedData({required this.characters, required this.page});
}
