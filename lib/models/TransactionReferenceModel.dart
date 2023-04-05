import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionReference {
  TransactionReference({
    this.transactionId,
    this.createdAt,
    this.grandtotal,
  });

  String? transactionId;
  Timestamp? createdAt;
  num? grandtotal;

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'grandtotal': grandtotal,
      'created_at': createdAt,
    };
  }

  factory TransactionReference.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TransactionReference(
      transactionId: data['transaction_id'],
      grandtotal: data['grandtotal'],
      createdAt: data['created_at'],
    );
  }
}
