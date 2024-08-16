import 'package:flutter_outlet/features/menu/model/menu_response.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/menu/exceptions/menu_exception.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/menu/services/menu_service.dart';

class MenuRepository {
  MenuRepository({
    required this.auth,
  });

  final AuthRepository auth;

  Future getAll({String? query}) async {
    try {
      final token = await auth.getToken();
      final MenuResponse data =
          await MenuApiService(token: token).getAll(query: query);
      return data;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future show(int id) async {
    try {
      final token = await auth.getToken();
      final dompet = await MenuApiService(token: token).show(id);
      return dompet;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }
}
