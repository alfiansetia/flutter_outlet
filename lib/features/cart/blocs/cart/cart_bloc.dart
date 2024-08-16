import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';

import 'package:flutter_outlet/features/cart/models/cart.dart';
import 'package:flutter_outlet/features/cart/models/cart_response.dart';
import 'package:flutter_outlet/features/cart/repository/cart_repository.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // final auth = AuthRepository();
  final AuthRepository authRepository;
  List<Cart> data = [];
  CartBloc({required this.authRepository}) : super(CartState.initial()) {
    on<FetchAllCartEvent>(_getAll);
    on<StoreCartEvent>(_store);
    on<UpdateCartEvent>(_update);
    on<DestroyCartEvent>(_destroy);
  }

  int _getTotalIncart() {
    if (data.isEmpty) {
      return 0;
    }
    int total = 0;
    for (var item in data) {
      total = total + item.qty;
    }
    return total;
  }

  int _getTotalPriceIncart() {
    return data.fold(
        0,
        (previousValue, element) =>
            previousValue +
            ((element.branchMenu!.price * element.qty) -
                (element.branchMenu!.discountPrice * element.qty)));
  }

  Future<void> _getAll(FetchAllCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final CartResponse model =
          await CartRepository(auth: authRepository).getAll(query: "limit=100");
      data = model.data;
      emit(
        state.copyWith(
          status: CartStatus.loaded,
          data: data,
          totalIncart: _getTotalIncart(),
          totalPriceIncart: _getTotalPriceIncart(),
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _store(StoreCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final Cart model = await CartRepository(auth: authRepository).store(
        menu: event.menuId,
        qty: event.qty,
      );
      data = state.data.map((item) {
        if (item.id == model.id) {
          return item.copyWith(qty: model.qty);
        } else {
          return item;
        }
      }).toList();
      emit(
        state.copyWith(
          status: CartStatus.success,
          message: 'Success add to cart!',
          data: data,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _update(UpdateCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final Cart model = await CartRepository(auth: authRepository)
          .update(id: event.id, qty: event.qty);
      data = state.data.map((item) {
        if (item.id == model.id) {
          return item.copyWith(qty: model.qty);
        } else {
          return item;
        }
      }).toList();
      emit(
        state.copyWith(
          status: CartStatus.success,
          message: 'Success update cart!',
          data: data,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _destroy(DestroyCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final Cart model =
          await CartRepository(auth: authRepository).destroy(id: event.id);
      data = state.data.where((cart) => cart.id != model.id).toList();
      emit(
        state.copyWith(
            status: CartStatus.success,
            data: data,
            totalIncart: _getTotalIncart(),
            totalPriceIncart: _getTotalPriceIncart(),
            message: 'Success delete cart!'),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
