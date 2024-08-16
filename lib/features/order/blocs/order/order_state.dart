part of 'order_bloc.dart';

enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  success,
  successGetDetail,
  successPrint,
  loadingPrint,
}

class OrderState extends Equatable {
  const OrderState({
    required this.data,
    required this.status,
    required this.message,
    required this.order,
  });

  factory OrderState.initial() => OrderState(
        data: const [],
        status: OrderStatus.initial,
        message: '',
        order: Order.initial(),
      );

  final List<Order> data;
  final OrderStatus status;
  final String message;
  final Order order;

  @override
  List<Object?> get props => [data, status, message, order];

  OrderState copyWith({
    List<Order>? data,
    OrderStatus? status,
    String? message,
    Order? order,
  }) {
    return OrderState(
      data: data ?? this.data,
      status: status ?? this.status,
      message: message ?? this.message,
      order: order ?? this.order,
    );
  }
}
