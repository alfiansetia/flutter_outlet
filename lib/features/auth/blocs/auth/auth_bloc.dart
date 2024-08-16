import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/models/user.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authrepo = AuthRepository();
  AuthBloc() : super(AuthState.initial()) {
    on<FethAuthEven>(_login);
    add(const FethAuthEven());
  }

  Future<void> _login(
    FethAuthEven event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final bool model = await authrepo.isLogin();
      final User user = await authrepo.getUser();
      emit(
        state.copyWith(status: AuthStatus.loaded, isLogin: model, user: user),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, error: CustomError(message: e.toString())));
    }
  }
}
