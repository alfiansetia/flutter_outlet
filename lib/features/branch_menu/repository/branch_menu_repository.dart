import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/branch_menu/exceptions/branch_menu_exception.dart';
import 'package:flutter_outlet/features/menu/exceptions/menu_exception.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu_response.dart';
import 'package:flutter_outlet/features/branch_menu/services/branch_menu_services.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';

class BranchMenuRepository {
  BranchMenuRepository({
    required this.auth,
  });

  final AuthRepository auth;

  Future getAll({String? query}) async {
    try {
      final token = await auth.getToken();
      final int branchId = await auth.getBranchId();
      final BranchMenuResponse data = await BranchMenuService(token: token)
          .getAll(query: '$query&branch_id=$branchId');
      return data;
    } on BranchMenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future show(int id) async {
    try {
      final token = await auth.getToken();
      final dompet = await BranchMenuService(token: token).show(id);
      return dompet;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<Cart> addToCart({required int menu, required int qty}) async {
    try {
      final token = await auth.getToken();
      final data = await BranchMenuService(token: token)
          .addToCart({"menu": menu, "qty": qty});
      return data;
    } on MenuException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }
}
