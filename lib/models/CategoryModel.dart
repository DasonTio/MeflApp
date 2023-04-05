import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  CategoryModel({
    this.categoryId,
    required this.name,
  });

  final String? categoryId;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': categoryId,
      'name': name,
    };
  }

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CategoryModel(
      categoryId: data['id'],
      name: data['name'],
    );
  }

  CategoryModel copyWith({
    String? name,
    String? categoryId
  }) {
    return CategoryModel(
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
