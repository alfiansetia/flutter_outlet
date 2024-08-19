part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class FetchSettingEvent extends SettingEvent {
  const FetchSettingEvent();

  @override
  List<Object> get props => [];
}

class SaveSettingEvent extends SettingEvent {
  const SaveSettingEvent({required this.setting});
  final Setting setting;

  @override
  List<Object> get props => [];
}
