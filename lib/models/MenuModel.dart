import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';

class MenuModel {
  MenuModel({
    this.categoryId,
    this.menuId,
    this.image,
    required this.name,
    required this.price,
  });

  final String? categoryId;
  final String? menuId;
  final String? image;
  final String name;
  final num price;

  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'image': image,
    };
  }

  factory MenuModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MenuModel(
      categoryId: data['category_id'],
      menuId: data['menu_id'],
      name: data['name'],
      price: data['price'],
      image: data['image'],
    );
  }
}
