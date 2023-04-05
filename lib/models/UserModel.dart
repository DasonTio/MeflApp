import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.name,
    required this.email,
    this.teamId = "",
    this.id,
  });

  final String teamId;
  final String? id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'team_id': teamId,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      teamId: data['team_id'],
    );
  }

  UserModel copyWith({
    String? teamId,
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      teamId: teamId ?? this.teamId,
    );
  }
}
