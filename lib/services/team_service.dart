import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/MemberModel.dart';
import 'package:mefl_app_bloc/models/TeamModel.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

abstract class TeamAbstract {
  Stream<TeamModel> get all;
  Future<void> load();
  void dispose();
}

class TeamService extends TeamAbstract {
  TeamService() {
    all = _controller.stream;
  }

  final StreamController<TeamModel> _controller = StreamController();
  CollectionReference _collection =
      FirebaseFirestore.instance.collection('teams');

  @override
  late final all;

  @override
  Future<void> load() async {
    final user = await UserRepo().me();
    final query = _collection.doc(user.teamId.toString()).snapshots();
    query.listen((event) {
      TeamModel team = TeamModel.fromSnapshot(event);
      _controller.add(team);
    });
  }

  @override
  void dispose() {
    _controller.close();
  }
}
