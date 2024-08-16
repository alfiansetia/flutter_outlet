import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu_response.dart';
import 'package:flutter_outlet/features/branch_menu/repository/branch_menu_repository.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/cart/models/cart.dart';

part 'branch_menu_event.dart';
part 'branch_menu_state.dart';

class BranchMenuBloc extends Bloc<BranchMenuEvent, BranchMenuState> {
  final AuthRepository authRepository;
  final BranchMenuRepository branchMenuRepository;
  List<BranchMenu>? data = [];
  BranchMenuBloc({required this.authRepository})
      : branchMenuRepository = BranchMenuRepository(auth: authRepository),
        super(BranchMenuState.initial()) {
    on<FetchAllBranchMenuEvent>(_getAll);
    on<AddToCartEvent>(_addToCart);
  }

  Future<void> _getAll(
      FetchAllBranchMenuEvent event, Emitter<BranchMenuState> emit) async {
    emit(state.copyWith(status: BranchMenuStatus.loading));

    try {
      final BranchMenuResponse model =
          await branchMenuRepository.getAll(query: "limit=10&${event.query}");
      data = model.data;
      emit(state.copyWith(status: BranchMenuStatus.loaded, model: data));
    } on CustomError catch (e) {
      emit(state.copyWith(status: BranchMenuStatus.error, error: e));
    } catch (e) {
      emit(state.copyWith(
          status: BranchMenuStatus.error,
          error: CustomError(message: e.toString())));
    }
  }

  Future<void> _addToCart(
      AddToCartEvent event, Emitter<BranchMenuState> emit) async {
    emit(state.copyWith(status: BranchMenuStatus.loading));
    try {
      final Cart model = await branchMenuRepository.addToCart(
          menu: event.menuId, qty: event.qty);
      data = state.model.map((item) {
        if (item.id == model.branchMenuId) {
          return item.copyWith(incart: model.qty);
        }
        return item;
      }).toList();
      emit(state.copyWith(status: BranchMenuStatus.loaded, model: data));
    } on CustomError catch (e) {
      emit(state.copyWith(status: BranchMenuStatus.error, error: e));
    } catch (e) {
      emit(state.copyWith(
          status: BranchMenuStatus.error,
          error: CustomError(message: e.toString())));
    }
  }
}
