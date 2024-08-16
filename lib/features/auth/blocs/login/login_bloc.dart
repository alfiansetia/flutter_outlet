import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/auth/models/auth_response.dart';
import 'package:flutter_outlet/features/auth/models/login_request_model.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final authrepo = AuthRepository();
  LoginBloc() : super(LoginState.initial()) {
    on<FetchLoginEven>(_login);
  }

  Future<void> _login(
    FetchLoginEven event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final AuthResponse model = await authrepo.login(data: event.model);
      emit(state.copyWith(status: LoginStatus.loaded, model: model));
    } on CustomError catch (e) {
      emit(state.copyWith(status: LoginStatus.error, error: e));
    } catch (e) {
      emit(state.copyWith(
          status: LoginStatus.error,
          error: CustomError(message: e.toString())));
    }
  }
}
