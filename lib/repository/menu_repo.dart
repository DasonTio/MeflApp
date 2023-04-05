import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/repository/team_repo.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

class MenuRepo {
  final _user = UserRepo();
  final _team = TeamRepo();
  final _db = FirebaseFirestore.instance.collection('menus');

  Future<void> createMenu(MenuModel data) async {
    final user = await _user.myRef();
    final menu =
        _db.doc(user.referenceId).collection('menus_data').doc(data.menuId);
    menu.set(data.toJson());
  }

  Future<void> createCategory(CategoryModel data) async {
    final val = data.copyWith(
        categoryId: DateTime.now().microsecondsSinceEpoch.toString());

    final user = await _user.myRef();
    final category = _db
        .doc(user.referenceId)
        .collection('menus_category')
        .doc(val.categoryId);
    category.set(val.toJson());
  }

  Future<void> updateCategory(CategoryModel data) async {
    final user = await _user.myRef();
    final category = await _db
        .doc(user.referenceId)
        .collection('menus_category')
        .doc(data.categoryId)
        .set(data.toJson());
  }

  Future<void> deleteCategory(String categoryId) async {
    final user = await _user.myRef();
    final category = await _db
        .doc(user.referenceId)
        .collection('menus_category')
        .doc(categoryId)
        .delete();
  }
}
