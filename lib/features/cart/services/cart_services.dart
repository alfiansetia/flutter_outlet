import 'dart:convert';

import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/cart/exceptions/cart_exception.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';
import 'package:flutter_outlet/features/cart/models/cart_response.dart';
import 'package:flutter_outlet/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_outlet/core/constants/variables.dart';

class CartService {
  CartService({
    required this.token,
  });

  final String token;

  Future<CartResponse> getAll({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/cart-paginate?$query'),
        headers: headers,
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      if (responseBody.isEmpty) {
        throw CartException('Cannot get the data Menu');
      }
      return CartResponse.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Cart>> get({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/cart-paginate?$query'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw const CustomError(message: "Error!");
      }
      List<Cart> data = [];
      if (responseBody != null && responseBody['data'] != null) {
        List<dynamic> dataList = responseBody['data'];
        data = dataList.map((data) => Cart.fromMap(data)).toList();
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Cart> show(int id) async {
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
        return Cart.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }

  Future<Cart> store(Map<String, dynamic> param) async {
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

  Future<Cart> update(int id, Map<String, dynamic> param) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.put(
        Uri.parse('${Variables.baseUrl}/api/carts/$id'),
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

  Future<Cart> destroy(int id) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.delete(
        Uri.parse('${Variables.baseUrl}/api/carts/$id'),
        headers: headers,
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
