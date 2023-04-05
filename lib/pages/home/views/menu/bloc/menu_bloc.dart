import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/repository/transaction_repo.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState()) {
    on<AddItemToCartButtonEvent>(_handleAddItemToCartButtonEvent);
    on<IncrementItemButtonEvent>(_handleIncrementItemEvent);
    on<DecrementItemButtonEvent>(_handleDecrementItemEvent);
    on<TransactionButtonEvent>(_handleTransactionEvent);
  }

  TransactionRepo _transactionRepo = TransactionRepo();

  Future<void> _handleTransactionEvent(
    TransactionButtonEvent event,
    Emitter<MenuState> emit,
  ) async {
    try {
      final transactionId = DateTime.now().microsecondsSinceEpoch.toString();
      await _transactionRepo.createTransaction(
        menus: state.cart,
        determinedId: transactionId,
      );
      emit(state.copyWith(
        status: MenuStatus.success,
        transactionId: transactionId,
      ));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.failure));
    }
  }

  Future<void> _handleAddItemToCartButtonEvent(
    AddItemToCartButtonEvent event,
    Emitter<MenuState> emitter,
  ) async {
    if (state.cart.contains(event.item)) {
      final newList = List<MenuModel>.from(state.cart);
      newList.removeWhere((element) => element == event.item);
      emit(state.copyWith(
        cart: newList,
      ));
    } else {
      var newCart = state.cart;
      newCart += [event.item];
      emit(state.copyWith(cart: newCart));
    }
  }

  Future<void> _handleIncrementItemEvent(
    IncrementItemButtonEvent event,
    Emitter<MenuState> emit,
  ) async {
    var newCart = List<MenuModel>.from(state.cart);
    newCart.add(event.item);
    emit(state.copyWith(cart: newCart));
  }

  Future<void> _handleDecrementItemEvent(
    DecrementItemButtonEvent event,
    Emitter<MenuState> emit,
  ) async {
    final newCart = List<MenuModel>.from(state.cart);
    final index = newCart.lastIndexWhere(
      (element) => element == event.item,
    );
    newCart.removeAt(index);
    emit(state.copyWith(cart: newCart));
  }
}
