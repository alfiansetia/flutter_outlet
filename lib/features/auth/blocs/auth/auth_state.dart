part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  loaded,
  error,
}

class AuthState extends Equatable {
  const AuthState({
    required this.error,
    required this.status,
    required this.isLogin,
    required this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      status: AuthStatus.initial,
      isLogin: false,
      error: const CustomError(),
      user: User.initial(),
    );
  }

  final CustomError error;
  final bool isLogin;
  final AuthStatus status;
  final User user;

  @override
  List<Object> get props => [error, status, isLogin];

  @override
  String toString() =>
      'AuthState(error: $error, status: $status, isLogin: $isLogin, user: $user)';

  AuthState copyWith({
    CustomError? error,
    AuthStatus? status,
    bool? isLogin,
    User? user,
  }) {
    return AuthState(
      error: error ?? this.error,
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      user: user ?? this.user,
    );
  }
}
