import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  TransactionModel({
    this.id,
    this.menuId,
    this.transactionId,
    this.quantity = 1,
  });

  String? id;
  String? menuId;
  String? transactionId;
  num quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_id': menuId,
      'transaction_id': transactionId,
      'quantity': quantity,
    };
  }

  factory TransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TransactionModel(
      id: data['id'],
      menuId: data['menu_id'],
      transactionId: data['transaction_id'],
      quantity: data['quantity'],
    );
  }
}
