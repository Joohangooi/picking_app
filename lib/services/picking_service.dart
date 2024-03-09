import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/services/jwt_service.dart';

class PickingService {
  static const String apiUrl = 'https://picking-api.typosquare.com';
  final jwtService = jwt_service();

  Future<dynamic> getPickingDetailByDocumentNo(String documentNo) async {
    try {
      final token = await jwtService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(
            '$apiUrl/api/Picking/picking/GetPickingDetailByDocumentNo/$documentNo'),
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

  Future<int> updatePickingDetail(
      List<Map<String, dynamic>> pickingDetails) async {
    try {
      final token = await jwtService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final String jsonBody = jsonEncode(pickingDetails);

      final response = await http.put(
        Uri.parse('$apiUrl/api/Picking/picking/UpdatePickingDetail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Picking details updated successfully.');
        return response.statusCode;
      } else {
        print(
            'Failed to update picking details. Status code: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Error encountered! Error: $e');
    }
  }
}
