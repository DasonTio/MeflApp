part of 'menu_edit_bloc.dart';

enum MenuEditStatus { loading, success, failure }

class MenuEditState extends Equatable {
  const MenuEditState({
    this.name = '',
    this.category = '',
    this.price = 0,
    this.status = MenuEditStatus.loading,
    this.image,
    this.message = '',
  });

  final String name;
  final String category;
  final num price;
  final File? image;
  final MenuEditStatus status;
  final String message;

  MenuEditState copyWith({
    String? name,
    String? category,
    num? price,
    File? image,
    MenuEditStatus? status,
    String? message,
  }) {
    return MenuEditState(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      image: image ?? this.image,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        name,
        category,
        price,
        image!,
      ];
}
