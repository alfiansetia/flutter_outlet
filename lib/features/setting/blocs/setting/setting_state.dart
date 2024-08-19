part of 'setting_bloc.dart';

enum SettingStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}

class SettingState extends Equatable {
  const SettingState({
    required this.setting,
    required this.message,
    required this.status,
  });

  factory SettingState.initial() => SettingState(
        setting: Setting.initial(),
        status: SettingStatus.initial,
        message: '',
      );

  final Setting setting;
  final String message;
  final SettingStatus status;

  @override
  List<Object?> get props => [setting, message, status];

  SettingState copyWith({
    Setting? setting,
    String? message,
    SettingStatus? status,
  }) {
    return SettingState(
      setting: setting ?? this.setting,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
