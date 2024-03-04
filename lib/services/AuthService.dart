import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl =
      'https://picking-api.typosquare.com'; // Replace this with your actual API URL

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Account/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email address or password');
      } else if (response.statusCode == 500) {
        throw Exception('An error occurred while processing your request');
      } else if (response.statusCode == 400) {
        throw Exception('Not a valid e-mail address');
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login. Error: $e');
    }
  }
}
