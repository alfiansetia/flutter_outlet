import 'dart:convert';

import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/branch_menu/exceptions/branch_menu_exception.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu_response.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';
import 'package:flutter_outlet/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_outlet/core/constants/variables.dart';

class BranchMenuService {
  BranchMenuService({
    required this.token,
  });

  final String token;

  Future<BranchMenuResponse> getAll({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse(
            '${Variables.baseUrl}/api/branch-menu-paginate?order_by_id=desc&$query'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw BranchMenuException('Cannot get the data Menu');
      }
      return BranchMenuResponse.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BranchMenu>> get({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/branch-menu-paginate?$query'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw const CustomError(message: "Error!");
      }
      List<BranchMenu> data = [];
      if (responseBody != null && responseBody['data'] != null) {
        List<dynamic> dataList = responseBody['data'];
        data = dataList.map((data) => BranchMenu.fromMap(data)).toList();
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<BranchMenu> show(int id) async {
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
        return BranchMenu.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }

  Future<Cart> addToCart(Map<String, dynamic> param) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/carts'),
        headers: headers,
        body: jsonEncode(param),
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final Map<String, dynamic> data = responseData['data'] ?? [];
        return Cart.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }
}
