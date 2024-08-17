import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';

import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/features/order/models/order_response.dart';
import 'package:flutter_outlet/features/order/repository/order_repository.dart';
import 'package:flutter_outlet/features/printer/services/printer_services.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AuthRepository authRepository;
  final OrderRepository orderRepository;
  final printerServices = PrinterServices();
  List<Order> data = [];
  OrderBloc({required this.authRepository})
      : orderRepository = OrderRepository(auth: authRepository),
        super(OrderState.initial()) {
    on<FetchAllOrderEvent>(_getAll);
    on<StoreOrderEvent>(_store);
    on<DetailOrderEvent>(_detail);
    on<PrintOrderEvent>(_print);
  }

  Future<void> _getAll(
      FetchAllOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
        status: OrderStatus.loading, data: event.page == 1 ? [] : data));
    try {
      final OrderResponse model = await orderRepository.getAll(
        query: "limit=10&${event.query}&page=${event.page}",
      );
      bool hasMax = model.meta?.currentPage == model.meta?.lastPage;
      if (event.page == 1) {
        data = model.data;
      } else {
        data.addAll(model.data);
      }
      emit(
        state.copyWith(
          status: OrderStatus.loaded,
          data: data,
          hasMax: hasMax,
          page: event.page,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _store(StoreOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final Order model = await orderRepository.store(
        name: event.name,
        payment: event.payment,
        bill: event.bill,
        ppn: event.ppn,
      );
      emit(
        state.copyWith(
          status: OrderStatus.success,
          message: 'Success create Order!',
          order: model,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _detail(DetailOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loadingGetDetail));
    try {
      final Order model = await orderRepository.show(id: event.id);
      emit(
        state.copyWith(
          status: OrderStatus.successGetDetail,
          message: 'Success get order!',
          order: model,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _print(PrintOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loadingPrint));
    try {
      // final bool model =
      await printerServices.printOrder(order: event.order);
      emit(
        state.copyWith(
          status: OrderStatus.successPrint,
          message: 'Success Print!',
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: OrderStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
