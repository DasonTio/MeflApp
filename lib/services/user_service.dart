import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mefl_app_bloc/models/TeamModel.dart';
import 'package:mefl_app_bloc/models/UserModel.dart';
import 'package:mefl_app_bloc/repository/team_repo.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

abstract class UserAbstract {
  Stream<UserModel> get authUser;
  Stream<List<TeamModel?>> get userTeam;
  Future<void> loadUser();
}

class UserService extends UserAbstract {
  UserService() {
    authUser = _controller.stream;
    userTeam = _userTeamController.stream;
  }

  final _user = UserRepo();

  @override
  late final authUser;
  late final userTeam;

  final StreamController<UserModel> _controller = StreamController();
  final StreamController<List<TeamModel?>> _userTeamController =
      StreamController();

  CollectionReference _userCol = FirebaseFirestore.instance.collection("users");

  CollectionReference _teamCol = FirebaseFirestore.instance.collection("teams");

  @override
  Future<void> loadUser() async {
    final query = _userCol
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots();
    query.listen((event) {
      final user = event.docs
          .map((DocumentSnapshot snapshot) => UserModel.fromSnapshot(snapshot))
          .first;
      _controller.add(user);
    });
  }

  Future<void> loadTeam() async {
    final user = await _user.me();
    final query = _teamCol.snapshots();
    final ownedTeam = _teamCol.where('user_id', isEqualTo: user.id).snapshots();
    ownedTeam.listen((event) {
      final ownerTeamList =
          event.docs.map((e) => TeamModel.fromSnapshot(e)).toList();
      query.listen((q) async {
        var list = await Future.wait(q.docs.map((doc) async {
          TeamModel team = TeamModel.fromSnapshot(doc);
          final teamMember = await _teamCol
              .doc(team.teamCode)
              .collection('members')
              .where('user_id', isEqualTo: user.id)
              .get();
          if (teamMember.docs.isNotEmpty) return team;
        }).toList());
        list.addAll(ownerTeamList);

        _userTeamController.add(list);
      });
    });
  }
}
