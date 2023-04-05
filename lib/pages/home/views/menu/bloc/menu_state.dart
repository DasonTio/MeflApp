part of 'menu_bloc.dart';

enum MenuStatus {
  loading,
  success,
  failure,
}

class MenuState extends Equatable {
  MenuState({
    this.transactionId = "",
    this.message = "",
    this.cart = const [],
    this.status = MenuStatus.loading,
  });

  String transactionId;
  String message;
  MenuStatus status;
  List<MenuModel> cart;

  @override
  List<Object> get props => [
        cart,
        status,
        message,
        transactionId,
      ];

  MenuState copyWith({
    String? transactionId,
    String? message,
    List<MenuModel>? cart,
    MenuStatus? status,
  }) {
    return MenuState(
      transactionId: transactionId ?? this.transactionId,
      cart: cart ?? this.cart,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
