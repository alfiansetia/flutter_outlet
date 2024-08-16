import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/order/exceptions/order_exception.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/features/order/models/order_response.dart';
import 'package:flutter_outlet/features/order/services/order_services.dart';

class OrderRepository {
  OrderRepository({
    required this.auth,
  });

  final AuthRepository auth;

  Future getAll({String? query}) async {
    try {
      final int branchId = await auth.getBranchId();
      final token = await auth.getToken();
      final OrderResponse data = await OrderServices(token: token)
          .getAll(query: '$query&branch_id=$branchId');
      return data;
    } on OrderException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future show({required int id}) async {
    try {
      final token = await auth.getToken();
      final data = await OrderServices(token: token).show(id);
      return data;
    } on OrderException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<Order> store(
      {required String name, required String payment, required int bill, int ppn = 0}) async {
    try {
      final token = await auth.getToken();
      final data = await OrderServices(token: token).store(
        {"payment": payment, "bill": bill, "ppn": ppn, "name": name},
      );
      return data;
    } on OrderException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }

  Future<Order> destroy({required int id}) async {
    try {
      final token = await auth.getToken();
      final data = await OrderServices(token: token).destroy(id);
      return data;
    } on OrderException catch (e) {
      throw CustomError(message: e.message);
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }
}
