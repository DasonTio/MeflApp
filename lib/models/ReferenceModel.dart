import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';

class MenuReferenceModel {
  MenuReferenceModel({
    required this.referenceId,
    this.userId,
    this.teamId,
  });
  final String referenceId;
  final String? teamId;
  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      'reference_id': referenceId,
      'team_id': teamId,
      'user_id': userId,
    };
  }

  factory MenuReferenceModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MenuReferenceModel(
      referenceId: data['reference_id'],
      userId: data['user_id'],
      teamId: data['team_id'],
    );
  }
}
