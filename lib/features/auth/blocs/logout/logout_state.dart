part of 'logout_bloc.dart';

enum LogoutStatus { initial, loading, loaded, error }

class LogoutState extends Equatable {
  const LogoutState({
    required this.status,
    required this.error,
  });

  final LogoutStatus status;
  final CustomError error;

  factory LogoutState.initial() {
    return const LogoutState(
      status: LogoutStatus.initial,
      error: CustomError(),
    );
  }

  LogoutState copyWith({
    LogoutStatus? status,
    CustomError? error,
  }) {
    return LogoutState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, error];

  @override
  String toString() => 'LogoutState(status: $status, error: $error)';
}
