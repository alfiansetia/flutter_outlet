import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/features/menu/model/menu.dart';
import 'package:flutter_outlet/features/menu/model/menu_response.dart';

import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/menu/repository/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class DompetBloc extends Bloc<MenuEvent, MenuState> {
  final auth = AuthRepository();
  List<Menu>? data = [];
  DompetBloc() : super(MenuState.initial()) {
    on<FetchAllMenuEvent>(_getAll);
  }

  Future<void> _getAll(FetchAllMenuEvent event, Emitter<MenuState> emit) async {
    emit(state.copyWith(status: MenuStatus.loading));

    try {
      final MenuResponse model =
          await MenuRepository(auth: auth).getAll(query: "limit=3");
      data = model.data;
      emit(state.copyWith(status: MenuStatus.loaded, model: data));
    } on CustomError catch (e) {
      emit(state.copyWith(status: MenuStatus.error, error: e));
    } catch (e) {
      emit(state.copyWith(
          status: MenuStatus.error, error: CustomError(message: e.toString())));
    }
  }
}
