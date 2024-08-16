part of 'cart_bloc.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}

class CartState extends Equatable {
  const CartState({
    required this.data,
    required this.status,
    required this.totalIncart,
    required this.totalPriceIncart,
    required this.message,
  });

  factory CartState.initial() => const CartState(
        data: [],
        status: CartStatus.initial,
        totalIncart: 0,
        totalPriceIncart: 0,
        message: '',
      );

  final List<Cart> data;
  final String message;
  final CartStatus status;
  final int totalIncart;
  final int totalPriceIncart;

  @override
  List<Object?> get props =>
      [data, status, totalIncart, totalPriceIncart, message];

  CartState copyWith({
    List<Cart>? data,
    CartStatus? status,
    int? totalIncart,
    int? totalPriceIncart,
    String? message,
  }) {
    return CartState(
      data: data ?? this.data,
      status: status ?? this.status,
      totalIncart: totalIncart ?? this.totalIncart,
      totalPriceIncart: totalPriceIncart ?? this.totalPriceIncart,
      message: message ?? this.message,
    );
  }
}
