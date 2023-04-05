import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/models/TransactionModel.dart';
import 'package:mefl_app_bloc/models/TransactionReferenceModel.dart';
import 'package:mefl_app_bloc/repository/transaction_repo.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

abstract class TransactionAbstract {
  Stream<List<TransactionDetail>> get all;
  Stream<TransactionDetail> get single;
  Future<void> load();
  void dispose();
}

class TransactionDetail {
  TransactionDetail({
    required this.models,
    required this.reference,
  });
  List<TransactionChild> models;
  TransactionReference reference;
}

class TransactionChild {
  TransactionChild({
    required this.model,
    required this.menu,
  });

  TransactionModel model;
  MenuModel menu;
}

class TransactionService extends TransactionAbstract {
  TransactionService() {
    all = _controller.stream;
    single = _singleController.stream;
  }

  final _collection = FirebaseFirestore.instance.collection('menus');
  final _user = UserRepo();
  final _transaction = TransactionRepo();

  StreamController<List<TransactionDetail>> _controller = StreamController();
  StreamController<TransactionDetail> _singleController = StreamController();
  @override
  late final all;

  @override
  late final single;

  @override
  Future<void> load() async {
    final user = await _user.myRef();
    final transactionQuery = _collection
        .doc(user.referenceId)
        .collection('transactions')
        .snapshots();

    transactionQuery.listen((col) async {
      final transactions = await Future.wait(col.docs.map((e) async {
        final reference = TransactionReference.fromSnapshot(e);
        final data = await _collection
            .doc(user.referenceId)
            .collection('transactions_data')
            .where('transaction_id', isEqualTo: reference.transactionId)
            .get();

        final models = await Future.wait(data.docs.map((e) async {
          final model = TransactionModel.fromSnapshot(e);
          final menuQuery = await _collection
              .doc(user.referenceId)
              .collection('menus_data')
              .where('menu_id', isEqualTo: model.menuId)
              .get();
          final menu = MenuModel.fromSnapshot(menuQuery.docs.first);
          return TransactionChild(model: model, menu: menu);
        }).toList());

        return TransactionDetail(
          models: models,
          reference: reference,
        );
      }));

      _controller.add(transactions);
    });
  }

  Future<void> loadSingle({
    required String transactionId,
  }) async {
    final user = await _user.myRef();
    final transactionQuery = _collection
        .doc(user.referenceId)
        .collection('transactions')
        .where('transaction_id', isEqualTo: transactionId)
        .snapshots();

    transactionQuery.listen((col) async {
      final reference = TransactionReference.fromSnapshot(col.docs.first);
      final data = await _collection
          .doc(user.referenceId)
          .collection('transactions_data')
          .where('transaction_id', isEqualTo: reference.transactionId)
          .get();

      final models = await Future.wait(data.docs.map((e) async {
        final model = TransactionModel.fromSnapshot(e);
        final menuQuery = await _collection
            .doc(user.referenceId)
            .collection('menus_data')
            .where('menu_id', isEqualTo: model.menuId)
            .get();
        final menu = MenuModel.fromSnapshot(menuQuery.docs.first);
        return TransactionChild(model: model, menu: menu);
      }).toList());

      final detail = TransactionDetail(models: models, reference: reference);
      _singleController.add(detail);
    });
  }

  @override
  void dispose() {
    _controller.close();
  }
}
