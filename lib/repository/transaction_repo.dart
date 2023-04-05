import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/models/TransactionModel.dart';
import 'package:mefl_app_bloc/models/TransactionReferenceModel.dart';
import 'package:mefl_app_bloc/repository/team_repo.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

class TransactionRepo {
  final _user = UserRepo();
  final _team = TeamRepo();
  final _db = FirebaseFirestore.instance.collection('menus');

  Future<void> createTransaction({
    String? determinedId,
    required List<MenuModel> menus,
  }) async {
    final user = await _user.myRef();

    final categorized = menus.toSet().toList();
    var grandtotal = menus.fold(0.0, (prev, next) => prev += next.price);

    final transactionId = determinedId ?? DateTime.now().microsecondsSinceEpoch.toString();
    final transactionRef = _db.doc(user.referenceId).collection('transactions');
    final transactionRefDoc = transactionRef.doc(transactionId);
    transactionRefDoc.set(TransactionReference(
      transactionId: transactionId,
      grandtotal: grandtotal,
      createdAt: Timestamp.now(),
    ).toJson());

    final transactionDataId = DateTime.now().microsecondsSinceEpoch.toString();
    final transactionData =
        _db.doc(user.referenceId).collection('transactions_data');

    await Future.wait(categorized.map((e) async {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final data = TransactionModel(
        id: id,
        menuId: e.menuId,
        quantity: menus.where((menu) => menu == e).toList().length,
        transactionId: transactionId,
      );
      final dataDoc = transactionData.doc(id);
      await dataDoc.set(data.toJson());
    }));
  }
}
