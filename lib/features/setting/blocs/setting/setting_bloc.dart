import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_outlet/features/setting/models/setting.dart';
import 'package:flutter_outlet/features/setting/repository/setting_repository.dart';
import 'package:flutter_outlet/models/custom_error.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState.initial()) {
    on<FetchSettingEvent>(_getData);
    on<SaveSettingEvent>(_save);
  }

  Future<void> _getData(
      FetchSettingEvent event, Emitter<SettingState> emit) async {
    emit(state.copyWith(status: SettingStatus.loading));

    try {
      final Setting model = await SettingRepository().getData();
      emit(
        state.copyWith(
          status: SettingStatus.success,
          setting: model,
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: SettingStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _save(SaveSettingEvent event, Emitter<SettingState> emit) async {
    emit(state.copyWith(status: SettingStatus.loading));

    try {
      await SettingRepository().saveData(event.setting);
      emit(
        state.copyWith(
          status: SettingStatus.success,
          setting: event.setting,
          message: 'Berhasil disimpan!',
        ),
      );
    } on CustomError catch (e) {
      emit(state.copyWith(status: SettingStatus.error, message: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
