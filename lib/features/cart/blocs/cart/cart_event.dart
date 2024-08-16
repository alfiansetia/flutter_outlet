part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchAllCartEvent extends CartEvent {
  const FetchAllCartEvent();

  @override
  List<Object> get props => [];
}

class StoreCartEvent extends CartEvent {
  const StoreCartEvent({required this.menuId, required this.qty});
  final int menuId;
  final int qty;

  @override
  List<Object> get props => [menuId, qty];
}

class UpdateCartEvent extends CartEvent {
  const UpdateCartEvent({required this.id, required this.qty});
  final int id;
  final int qty;

  @override
  List<Object> get props => [id, qty];
}

class DestroyCartEvent extends CartEvent {
  const DestroyCartEvent({required this.id});
  final int id;

  @override
  List<Object> get props => [id];
}
