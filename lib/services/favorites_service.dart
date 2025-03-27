import 'dart:convert';

import 'package:effective_mobile/models/character.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  Future<List<Character>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Character.fromJson(json)).toList();
  }

  Future<void> toggleFavorite(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    List<Character> favorites = await getFavorites();

    if (favorites.any((fav) => fav.id == character.id)) {
      // Remove from favorites
      favorites.removeWhere((fav) => fav.id == character.id);
    } else {
      // Add to favorites
      favorites.add(character);
    }

    final jsonString = jsonEncode(favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_favoritesKey, jsonString);
  }
}
