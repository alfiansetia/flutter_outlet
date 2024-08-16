part of 'menu_bloc.dart';

enum MenuStatus {
  initial,
  loading,
  loaded,
  error,
}

class MenuState extends Equatable {
  const MenuState({
    required this.error,
    required this.model,
    required this.status,
  });

  factory MenuState.initial() => const MenuState(
        error: CustomError(),
        model: [],
        status: MenuStatus.initial,
      );

  final CustomError error;
  final List<Menu> model;
  final MenuStatus status;

  @override
  List<Object> get props => [error, model, status];

  MenuState copyWith({
    CustomError? error,
    List<Menu>? model,
    MenuStatus? status,
  }) {
    return MenuState(
      error: error ?? this.error,
      model: model ?? this.model,
      status: status ?? this.status,
    );
  }
}
