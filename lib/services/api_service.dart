import 'dart:convert';
import 'package:effective_mobile/models/character.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/character?page=$page'));

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
