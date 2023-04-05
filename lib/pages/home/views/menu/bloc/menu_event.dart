part of 'menu_bloc.dart';

class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class TransactionButtonEvent extends MenuEvent {
  TransactionButtonEvent();
  }

class AddItemToCartButtonEvent extends MenuEvent {
  AddItemToCartButtonEvent({
    required this.item,
  });

  MenuModel item;
  List<Object> get props => [item];
}

class DecrementItemButtonEvent extends MenuEvent {
  DecrementItemButtonEvent({
    required this.item,
  });

  MenuModel item;
  List<Object> get props => [item];
}

class IncrementItemButtonEvent extends MenuEvent {
  IncrementItemButtonEvent({
    required this.item,
  });

  MenuModel item;
  List<Object> get props => [item];
}
