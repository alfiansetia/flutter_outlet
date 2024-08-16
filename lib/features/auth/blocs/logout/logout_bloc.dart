import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final authrepo = AuthRepository();
  LogoutBloc() : super(LogoutState.initial()) {
    on<FetchLogoutEvent>(_logout);
  }

  Future<void> _logout(
    FetchLogoutEvent event,
    Emitter<LogoutState> emit,
  ) async {
    emit(state.copyWith(status: LogoutStatus.loading));

    try {
      await authrepo.logout();
      emit(state.copyWith(status: LogoutStatus.loaded));
    } on CustomError catch (e) {
      emit(state.copyWith(status: LogoutStatus.error, error: e));
    } catch (e) {
      emit(state.copyWith(
          status: LogoutStatus.error,
          error: CustomError(message: e.toString())));
    }
  }
}
