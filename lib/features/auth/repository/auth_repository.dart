import 'package:flutter_outlet/features/auth/services/auth_local_service.dart';
import 'package:flutter_outlet/features/branch/models/branch.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/models/user.dart';
import 'package:flutter_outlet/features/auth/models/login_request_model.dart';
import 'package:flutter_outlet/features/auth/models/auth_response.dart';
import 'package:flutter_outlet/features/auth/exceptions/auth_exception.dart';
import 'package:flutter_outlet/features/auth/services/auth_api_service.dart';

class AuthRepository {
  final _authApiService = AuthApiService();
  final _authLocalServices = AuthLocalService();

  Future<bool> saveData(AuthResponse model) async {
    final result = await _authLocalServices.saveData(model);
    return result;
  }

  Future<bool> removeData() async {
    final result = await _authLocalServices.removeData();
    return result;
  }

  Future login({required LoginRequestModel data}) async {
    try {
      final AuthResponse response = await _authApiService.login(data);
      saveData(response);
      return response;
    } on AuthException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future logout() async {
    try {
      final token = await getToken();
      final bool response = await _authApiService.logout(token: token);
      await _authLocalServices.removeData();
      return response;
    } on AuthException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<String> getToken() async {
    try {
      final String token = await _authLocalServices.getToken();
      if (token.isEmpty) {
        throw AuthException('Token not found, Please Login Again!');
      }
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBranchId() async {
    try {
      final data = await _authLocalServices.getData();
      return data.user.branchId;
    } catch (e) {
      return 0;
    }
  }

  Future<Branch> getBranch() async {
    try {
      final data = await getUser();
      return data.branch!;
    } catch (e) {
      throw const CustomError(message: 'No data!');
    }
  }

  Future<User> getUser() async {
    try {
      final data = await _authLocalServices.getData();
      return data.user;
    } catch (e) {
      throw const CustomError(message: 'No data!');
    }
  }

  Future<bool> isLogin() async {
    try {
      final data = await _authLocalServices.getData();
      return data.jwtToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<User> getProfile() async {
    try {
      final data = await getToken();
      final User user = await _authApiService.getProfile(token: data);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
