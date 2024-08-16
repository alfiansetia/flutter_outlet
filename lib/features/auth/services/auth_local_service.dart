import 'package:flutter_outlet/features/auth/models/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  Future<bool> saveData(AuthResponse model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.setString('auth', model.toJson());
    return result;
  }

  Future<bool> removeData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.remove('auth');
    return result;
  }

  Future<AuthResponse> getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authModel = AuthResponse.fromJson(authJson);
    return authModel;
  }

  Future<String> getToken() async {
    try {
      final data = await getData();
      return data.jwtToken;
    } catch (e) {
      return '';
    }
  }
}
