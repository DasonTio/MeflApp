part of 'menu_add_bloc.dart';

enum MenuAddStatus { loading, success, failure }

class MenuAddState extends Equatable {
  MenuAddState({
    this.name = '',
    this.category = '',
    this.price = 0,
    this.status = MenuAddStatus.loading,
    this.image,
    this.message = '',
  });

  final String name;
  final String category;
  final num price;
  final File? image;
  final MenuAddStatus status;
  final String message;

  MenuAddState copyWith({
    String? name,
    String? category,
    num? price,
    File? image,
    MenuAddStatus? status,
    String? message,
  }) {
    return MenuAddState(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      status: status ?? this.status,
      image: image ?? this.image,
      message: message ?? this.message,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        name,
        category,
        price,
        image,
      ];
}
