part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class FetchAllMenuEvent extends MenuEvent {
  const FetchAllMenuEvent();

  @override
  List<Object> get props => [];
}
