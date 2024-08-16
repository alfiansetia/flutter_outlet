part of 'branch_menu_bloc.dart';

enum BranchMenuStatus {
  initial,
  loading,
  loaded,
  error,
}

class BranchMenuState extends Equatable {
  const BranchMenuState({
    required this.error,
    required this.model,
    required this.status,
  });

  factory BranchMenuState.initial() => const BranchMenuState(
        error: CustomError(),
        model: [],
        status: BranchMenuStatus.initial,
      );

  final CustomError error;
  final List<BranchMenu> model;
  final BranchMenuStatus status;

  @override
  List<Object> get props => [error, model, status];

  BranchMenuState copyWith({
    CustomError? error,
    List<BranchMenu>? model,
    BranchMenuStatus? status,
  }) {
    return BranchMenuState(
      error: error ?? this.error,
      model: model ?? this.model,
      status: status ?? this.status,
    );
  }
}
