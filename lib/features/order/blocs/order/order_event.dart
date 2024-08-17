part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchAllOrderEvent extends OrderEvent {
  const FetchAllOrderEvent({this.query, this.page = 1});

  final String? query;
  final int page;

  @override
  List<Object> get props => [];
}

class StoreOrderEvent extends OrderEvent {
  const StoreOrderEvent(
      {required this.name,
      required this.payment,
      required this.bill,
      this.ppn = 0});
  final String name;
  final String payment;
  final int bill;
  final int ppn;

  @override
  List<Object> get props => [name, payment, bill, ppn];
}

class DetailOrderEvent extends OrderEvent {
  const DetailOrderEvent({required this.id});
  final int id;

  @override
  List<Object> get props => [id];
}

class PrintOrderEvent extends OrderEvent {
  const PrintOrderEvent({required this.order});
  final Order order;

  @override
  List<Object> get props => [order];
}
