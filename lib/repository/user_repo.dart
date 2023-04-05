import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mefl_app_bloc/models/ReferenceModel.dart';
import 'package:mefl_app_bloc/models/TeamModel.dart';
import 'package:mefl_app_bloc/models/UserModel.dart';
import 'package:mefl_app_bloc/pages/auth/login/bloc/login_bloc.dart';

class UserRepo {
  FirebaseAuth _firebase = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection('users');
  final _dbTeam = FirebaseFirestore.instance.collection('teams');
  final _dbRef = FirebaseFirestore.instance.collection('menus');

  Future<void> store({
    required email,
    required name,
  }) async {
    final docRef = _db.doc(email);
    UserModel user =
        UserModel(name: name, email: email, id: _firebase.currentUser!.uid);
    await docRef.set(user.toJson());

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final ref = FirebaseFirestore.instance.collection('menus').doc(id);
    ref.set(MenuReferenceModel(
      referenceId: id,
      userId: user.id,
      teamId: user.teamId,
    ).toJson());
  }

  Future<void> update({
    required UserModel user,
  }) async {
    final docRef = _db.doc(user.email);
    await docRef.set(user.toJson());
  }

  Future<UserModel> get({
    required userId,
  }) async {
    final userQuery = await _db.where('id', isEqualTo: userId).get();
    return userQuery.docs.map((e) => UserModel.fromSnapshot(e)).first;
  }

  Future<UserModel> me() async {
    final email = _firebase.currentUser!.email;
    final userQuery = await _db.where('email', isEqualTo: email).get();
    return userQuery.docs.map((e) => UserModel.fromSnapshot(e)).first;
  }

  Future<MenuReferenceModel> myRef() async {
    final user = await me();
    var ref;
    if (user.teamId == "")
      ref = await _dbRef.where('user_id', isEqualTo: user.id).get();
    else
      ref = await _dbRef.where('team_id', isEqualTo: user.teamId).get();
    return ref.docs.map((e) => MenuReferenceModel.fromSnapshot(e)).first;
  }
}
