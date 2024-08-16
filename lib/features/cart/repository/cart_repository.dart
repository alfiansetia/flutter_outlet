import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/cart/exceptions/cart_exception.dart';
import 'package:flutter_outlet/features/menu/exceptions/menu_exception.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';
import 'package:flutter_outlet/features/cart/models/cart_response.dart';
import 'package:flutter_outlet/features/cart/services/cart_services.dart';

class CartRepository {
  CartRepository({
    required this.auth,
  });

  final AuthRepository auth;

  Future getAll({String? query}) async {
    try {
      final token = await auth.getToken();
      final CartResponse data =
          await CartService(token: token).getAll(query: query);
      return data;
    } on CartException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future show(int id) async {
    try {
      final token = await auth.getToken();
      final data = await CartService(token: token).show(id);
      return data;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<Cart> store({required int menu, required int qty}) async {
    try {
      final token = await auth.getToken();
      final data =
          await CartService(token: token).store({"menu": menu, "qty": qty});
      return data;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<Cart> update({required int id, required int qty}) async {
    try {
      final token = await auth.getToken();
      final data = await CartService(token: token).update(id, {"qty": qty});
      return data;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<Cart> destroy({required int id}) async {
    try {
      final token = await auth.getToken();
      final data = await CartService(token: token).destroy(id);
      return data;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }
}
