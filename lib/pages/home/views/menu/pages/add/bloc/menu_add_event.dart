part of 'menu_add_bloc.dart';

abstract class MenuAddEvent extends Equatable {
  const MenuAddEvent();

  @override
  List<Object> get props => [];
}

class ChangeMenuNameEvent extends MenuAddEvent {
  ChangeMenuNameEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class ChangeMenuCategoryEvent extends MenuAddEvent {
  ChangeMenuCategoryEvent({required this.category});

  final String category;

  @override
  List<Object> get props => [category];
}

class ChangeMenuPriceEvent extends MenuAddEvent {
  ChangeMenuPriceEvent({required this.price});

  final num price;

  @override
  List<Object> get props => [price];
}

class ChangeMenuImageEvent extends MenuAddEvent {
  ChangeMenuImageEvent();
}
class AddMenuEvent extends MenuAddEvent{
  AddMenuEvent();
}
class MenuStateCheckerEvent extends MenuAddEvent{
  MenuStateCheckerEvent();
}
