part of 'order_bloc.dart';

enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  success,
  loadingGetDetail,
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
    required this.hasMax,
    required this.page,
  });

  factory OrderState.initial() => OrderState(
        data: const [],
        status: OrderStatus.initial,
        message: '',
        order: Order.initial(),
        hasMax: true,
        page: 1,
      );

  final List<Order> data;
  final OrderStatus status;
  final String message;
  final Order order;
  final bool hasMax;
  final int page;

  @override
  List<Object?> get props => [data, status, message, order, hasMax, page];

  OrderState copyWith({
    List<Order>? data,
    OrderStatus? status,
    String? message,
    Order? order,
    bool? hasMax,
    int? page,
  }) {
    return OrderState(
      data: data ?? this.data,
      status: status ?? this.status,
      message: message ?? this.message,
      order: order ?? this.order,
      hasMax: hasMax ?? this.hasMax,
      page: page ?? this.page,
    );
  }
}
