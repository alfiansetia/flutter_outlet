import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/models/custom_error.dart';

import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/models/user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  // final auth = AuthRepository();
  final AuthRepository authRepository;
  User? data;
  ProfileBloc({required this.authRepository}) : super(ProfileState.initial()) {
    on<FetchProfileEvent>(_getData);
  }

  Future<void> _getData(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final User model = await authRepository.getProfile();
      data = model;
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          user: model,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
