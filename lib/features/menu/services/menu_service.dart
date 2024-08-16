import 'dart:convert';

import 'package:flutter_outlet/features/menu/model/menu.dart';
import 'package:flutter_outlet/features/menu/model/menu_response.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/menu/exceptions/menu_exception.dart';
import 'package:flutter_outlet/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_outlet/core/constants/variables.dart';

class MenuApiService {
  MenuApiService({
    required this.token,
  });

  final String token;

  Future<MenuResponse> getAll({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/menu-paginate?$query'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw MenuException('Cannot get the data Dompet');
      }
      return MenuResponse.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Menu>> get({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/menu-paginate?$query'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw const CustomError(message: "Error!");
      }
      List<Menu> dompets = [];
      if (responseBody != null && responseBody['data'] != null) {
        List<dynamic> dompetList = responseBody['data'];
        dompets = dompetList.map((data) => Menu.fromMap(data)).toList();
      }
      return dompets;
    } catch (e) {
      rethrow;
    }
  }

  Future<Menu> show(int id) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/menus/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        final Map<String, dynamic> data = responseData['data'] ?? [];
        return Menu.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }
}
