import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/models/ReferenceModel.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

abstract class MenuAbstract {
  Stream<List<MenuModel>> get allMenus;
  Stream<List<CategoryModel>> get allCategories;

  Future<void> loadAll();
  void dispose();
}

class MenuService extends MenuAbstract {
  MenuService() {
    allMenus = _menuController.stream;
    allCategories = _categoryController.stream;
  }

  UserRepo _user = UserRepo();

  @override
  late final allMenus;

  @override
  late final allCategories;

  final StreamController<List<MenuModel>> _menuController = StreamController();
  final StreamController<List<CategoryModel>> _categoryController =
      StreamController();

  CollectionReference _collection =
      FirebaseFirestore.instance.collection("menus");

  @override
  Future<void> loadAll() async {
    final user = await _user.me();
    var ref;
    if (user.teamId == "") {
      final userQuery =
          await _collection.where("user_id", isEqualTo: user.id).get();
      ref = userQuery.docs.isNotEmpty
          ? MenuReferenceModel.fromSnapshot(userQuery.docs.first)
          : null;
    } else {
      final teamQuery =
          await _collection.where("team_id", isEqualTo: user.teamId).get();
      ref = teamQuery.docs.isNotEmpty
          ? MenuReferenceModel.fromSnapshot(teamQuery.docs.first)
          : null;
    }
    final categoriesQuery = _collection
        .doc(ref.referenceId)
        .collection('menus_category')
        .snapshots();

    final menusQuery =
        _collection.doc(ref.referenceId).collection('menus_data').snapshots();

    categoriesQuery.listen((col) {
      List<CategoryModel> categories =
          col.docs.map((data) => CategoryModel.fromSnapshot(data)).toList();
      _categoryController.add(categories);
    });

    menusQuery.listen((col) {
      List<MenuModel> menus =
          col.docs.map((data) => MenuModel.fromSnapshot(data)).toList();
      _menuController.add(menus);
    });
  }

  Future<void> categoryFunction(String categoryId) async {
    if (categoryId == "") {
      await searchFunction("");
    } else {
      final ref = await _user.myRef();
      final query = _collection
          .doc(ref.referenceId)
          .collection('menus_data')
          .where('category_id', isEqualTo: categoryId)
          .snapshots();
      query.listen((col) {
        final colData = col.docs.map((e) => MenuModel.fromSnapshot(e)).toList();
        _menuController.add(colData);
      });
    }
  }

  Future<void> searchFunction(String text) async {
    final ref = await _user.myRef();
    final query =
        _collection.doc(ref.referenceId).collection('menus_data').snapshots();

    query.listen((col) {
      final colData = col.docs.map((e) => MenuModel.fromSnapshot(e)).toList();
      final filtered =
          colData.where((element) => element.name.contains(text)).toList();
      _menuController.add(filtered);
    });
  }

  @override
  void dispose() {
    _menuController.close();
    _categoryController.close();
  }
}
