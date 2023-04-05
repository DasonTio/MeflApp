import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class TeamModel {
  TeamModel({
    this.id,
    required this.teamCode,
    required this.userId,
    required this.name,
    this.createdAt,
  });

  final String? id;
  final String userId;
  final String name;
  final String teamCode;
  final Timestamp? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'code': teamCode,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  factory TeamModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TeamModel(
      id: data['id'],
      teamCode: data['code'],
      userId: data['user_id'],
      name: data['name'],
      createdAt: data['created_at'],
    );
  }
}
