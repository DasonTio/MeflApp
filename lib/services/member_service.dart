import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/MemberModel.dart';
import 'package:mefl_app_bloc/models/UserModel.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';


class MemberDetailModel {
  MemberDetailModel({
    required this.member,
    required this.user,
  });

  MemberModel member;
  UserModel user;
}

abstract class MemberAbstract {
  Stream<List<MemberDetailModel>> get all;
  Future<void> load();
  void dispose();
}

class MemberService extends MemberAbstract {
  MemberService() {
    all = _controller.stream;
  }

  UserRepo _user = UserRepo();
  StreamController<List<MemberDetailModel>> _controller = StreamController();
  CollectionReference _collection =
      FirebaseFirestore.instance.collection('teams');

  @override
  late final all;

  @override
  Future<void> load() async {
    final user = await _user.me();
    final query =
        _collection.doc(user.teamId).collection('members').snapshots();
    query.listen((event) async {
      final members = await Future.wait(event.docs.map((e) async {
        final member = MemberModel.fromSnapshot(e);
        final user = await _user.get(userId: member.userId);
        return MemberDetailModel(member: member, user: user);
      }).toList());
      _controller.add(members);
    });
  }

  @override
  void dispose() {
    _controller.close();
  }
}
