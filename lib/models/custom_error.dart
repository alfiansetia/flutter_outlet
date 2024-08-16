import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  const CustomError({
    this.message = '',
  });

  final String message;

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}
