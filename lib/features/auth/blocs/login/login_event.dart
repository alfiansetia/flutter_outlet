part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class FetchLoginEven extends LoginEvent {
  final LoginRequestModel model;
  const FetchLoginEven({
    required this.model,
  });

  @override
  List<Object> get props => [model];
}
