import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  static const String baseUrl = "http://127.0.0.1:8000"; // Eğer emulator dışı cihazdaysan, 10.0.2.2 yap

  Future<List<dynamic>> getRecommendations(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recommendation/?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recommendations'];
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
  
  