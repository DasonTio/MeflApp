import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mefl_app_bloc/models/MemberModel.dart';
import 'package:mefl_app_bloc/models/ReferenceModel.dart';
import 'package:mefl_app_bloc/models/TeamModel.dart';
import 'package:mefl_app_bloc/models/UserModel.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class TeamRepo {
  final _user = UserRepo();
  final _db = FirebaseFirestore.instance.collection('teams');

  String generateCode() {
    var r = Random();
    const chars =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrTtUuVvWwXxYyZz1234567890";
    return List.generate(5, (index) => chars[r.nextInt(chars.length)]).join();
  }

  Future<void> create() async {
    final code = generateCode();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final docRef = _db.doc(code);
    final user = await _user.me();
    _user.update(user: user.copyWith(teamId: code));

    TeamModel team = TeamModel(
      id: id,
      teamCode: code,
      userId: user.id!,
      name: user.name,
    );
    await docRef.set(team.toJson());
    final refId = DateTime.now().microsecondsSinceEpoch.toString();

    final ref = FirebaseFirestore.instance.collection('menus').doc(refId);
    ref.set(MenuReferenceModel(
      referenceId: refId,
      teamId: code,
    ).toJson());
  }

  Future<void> requestJoin({required teamCode}) async {
    final user = await _user.me();
    final checker = await _db.doc(teamCode).get();
    if (checker.exists) {
      final member = _db.doc(teamCode).collection('members').doc(user.id);
      await member.set(MemberModel(userId: user.id!).toJson());
    }
  }

  Future<void> acceptJoin({required requestedUserId}) async {
    final user = await _user.me();
    final currentTeam = await _db.doc(user.teamId).get();
    if (currentTeam.exists) {
      final team = TeamModel.fromSnapshot(currentTeam);
      if (team.userId == FirebaseAuth.instance.currentUser!.uid) {
        await _db
            .doc(user.teamId)
            .collection('members')
            .doc(requestedUserId)
            .update(MemberModel(
              userId: requestedUserId,
              userStatus: UserStatus.accepted,
            ).toJson());

        final requestedUser = await _user.get(userId: requestedUserId);
        _user.update(user: requestedUser.copyWith(teamId: team.teamCode));
      }
    }
  }

  Future<void> rejectJoin({required requestedUserId}) async {}
}
