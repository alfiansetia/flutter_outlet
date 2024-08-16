part of 'branch_menu_bloc.dart';

abstract class BranchMenuEvent extends Equatable {
  const BranchMenuEvent();

  @override
  List<Object> get props => [];
}

class FetchAllBranchMenuEvent extends BranchMenuEvent {
  const FetchAllBranchMenuEvent({this.query});
  final String? query;
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends BranchMenuEvent {
  const AddToCartEvent({required this.menuId, required this.qty});
  final int menuId;
  final int qty;

  @override
  List<Object> get props => [];
}
