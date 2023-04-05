part of 'menu_edit_bloc.dart';

abstract class MenuEditEvent extends Equatable {
  const MenuEditEvent();

  @override
  List<Object> get props => [];
}

class EditChangeMenuNameEvent extends MenuEditEvent {
  EditChangeMenuNameEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class EditChangeMenuCategoryEvent extends MenuEditEvent {
  EditChangeMenuCategoryEvent({required this.category});

  final String category;

  @override
  List<Object> get props => [category];
}

class EditChangeMenuPriceEvent extends MenuEditEvent {
  EditChangeMenuPriceEvent({required this.price});

  final num price;

  @override
  List<Object> get props => [price];
}

class EditChangeMenuImageEvent extends MenuEditEvent {
  EditChangeMenuImageEvent();
}

class EditMenuEvent extends MenuEditEvent {
  EditMenuEvent();
}

class InheritAll extends MenuEditEvent {
  InheritAll({
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    this.status = MenuEditStatus.loading,
    this.message = "",
  });

  String name;
  String category;
  num price;
  File? image;
  MenuEditStatus status;
  String message;

  @override
  List<Object> get props => [
        name,
        category,
        price,
        image!,
        status,
        message,
      ];
}
