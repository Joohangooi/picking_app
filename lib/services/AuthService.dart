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

  Future<int> registerUser(String name, String email, String password,
      String phoneNum, String address, String company) async {
    // API endpoint
    String url = '$apiUrl/api/Account/register';

    // Request body
    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'phoneNum': phoneNum,
      'address': address,
      'company': company,
    };

    // Encoding the request body to JSON
    String jsonBody = jsonEncode(requestBody);

    try {
      // Making the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      // Checking the response status code
      if (response.statusCode == 200) {
        // Registration successful
        return response.statusCode;
      } else if (response.statusCode == 409) {
        // Email already registered
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return 500;
    }
  }
}
