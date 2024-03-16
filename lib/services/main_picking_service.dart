import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picking_app/services/jwt_service.dart';

class MainPickingService {
  static const String apiUrl = 'https://picking-app-api.onlinestar.com.my';
  final jwtService = jwt_service();

  Future<dynamic> getPickingMainByOption() async {
    try {
      final token = await jwtService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$apiUrl/api/Main/picking/GetPickingMainByOption'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Error encountered! Error: $e');
    }
  }

  Future<dynamic> getPickingDetailByDocumentNo(String documentNo) async {
    try {
      final token = await jwtService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(
            '$apiUrl/api/Detail/detail/GetPickingDetailByDocumentNo/$documentNo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Error encountered! Error: $e');
    }
  }

  Future<dynamic> getPickingMainByDocumentNo(String documentNo) async {
    try {
      final token = await jwtService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(
            '$apiUrl/api/Main/picking/GetPickingMainByDocumentNo/$documentNo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Error encountered! Error: $e');
    }
  }

  Future<int> deletePickingDetailByDocumentNo(String documentNo) async {
    try {
      final token = await jwtService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.delete(
        Uri.parse(
            '$apiUrl/api/Main/picking/DeletePickingMainByDocumentNo/$documentNo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Error encountered! Error: $e');
    }
  }
}
