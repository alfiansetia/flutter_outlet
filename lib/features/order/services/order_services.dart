import 'dart:convert';

import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/cart/exceptions/cart_exception.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/features/order/models/order_response.dart';
import 'package:flutter_outlet/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_outlet/core/constants/variables.dart';

class OrderServices {
  OrderServices({
    required this.token,
  });

  final String token;

  Future<OrderResponse> getAll({String? query}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse(
            '${Variables.baseUrl}/api/order-paginate?order_by_id=desc&$query'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw CartException('Cannot get the data Menu');
      }
      return OrderResponse.fromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> show(int id) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/orders/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final Map<String, dynamic> data = responseData['data'] ?? [];
        return Order.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> store(Map<String, dynamic> param) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/orders'),
        headers: headers,
        body: jsonEncode(param),
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final Map<String, dynamic> data = responseData['data'] ?? [];
        return Order.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> destroy(int id) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.delete(
        Uri.parse('${Variables.baseUrl}/api/orders/$id'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final Map<String, dynamic> data = responseData['data'] ?? [];
        return Order.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }
}
