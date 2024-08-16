import 'dart:convert';

import 'package:flutter_outlet/core/constants/variables.dart';
import 'package:flutter_outlet/features/auth/models/login_request_model.dart';
import 'package:flutter_outlet/features/auth/models/auth_response.dart';
import 'package:flutter_outlet/features/auth/exceptions/auth_exception.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/models/user.dart';
import 'package:flutter_outlet/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  Future<AuthResponse> login(LoginRequestModel model) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
          Uri.parse('${Variables.baseUrl}/api/login'),
          headers: headers,
          body: model.toJson());
      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw AuthException("cannot Login");
      }
      return AuthResponse.fromMap(responseBody);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout({required String token}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/logout'),
        headers: headers,
      );
      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw AuthException("Cannot Logout");
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getProfile({required String token}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/profile'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final Map<String, dynamic> data = responseData['data'] ?? [];
        return User.fromMap(data);
      }
      throw const CustomError(message: 'No data!');
    } catch (e) {
      rethrow;
    }
  }
}
