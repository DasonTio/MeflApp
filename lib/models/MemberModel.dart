import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mefl_app_bloc/models/RoleModel.dart';
import 'package:mefl_app_bloc/models/UserModel.dart';

enum UserStatus {
  pending,
  accepted,
  rejected;

  String get desc => '$name';
  factory UserStatus.toEnum(String desc) {
    UserStatus status = UserStatus.values
        .firstWhere((element) => element.toString() == "UserStatus." + desc);
    return status;
  }
}

class MemberModel {
  MemberModel({
    this.id,
    required this.userId,
    this.userStatus = UserStatus.pending,
    this.createdAt,
  });

  String? id;
  String userId;
  UserStatus userStatus;
  Timestamp? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_status': userStatus.desc,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  factory MemberModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MemberModel(
      id: data['id'],
      userId: data['user_id'],
      userStatus: UserStatus.toEnum(data['user_status']),
      createdAt: data['created_at'],
    );
  }
}
