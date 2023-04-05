import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/repository/menu_repo.dart';

part 'menu_edit_event.dart';
part 'menu_edit_state.dart';

class MenuEditBloc extends Bloc<MenuEditEvent, MenuEditState> {
  MenuEditBloc() : super(MenuEditState()) {
    on<EditChangeMenuImageEvent>(_handleEditChangeMenuImageEvent);
    on<EditChangeMenuNameEvent>(_handleEditChangeMenuNameEvent);
    on<EditChangeMenuPriceEvent>(_handleEditChangeMenuPriceEvent);
    on<EditChangeMenuCategoryEvent>(_handleEditChangeMenuCategoryEvent);
  }

  Future<void> _handleEditChangeMenuImageEvent(
    EditChangeMenuImageEvent event,
    Emitter<MenuEditState> emit,
  ) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);
    emit(state.copyWith(
      image: file,
    ));
  }

  
  Future<void> _handleEditChangeMenuNameEvent(
    EditChangeMenuNameEvent event,
    Emitter<MenuEditState> emit,
  ) async {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  Future<void> _handleEditChangeMenuPriceEvent(
    EditChangeMenuPriceEvent event,
    Emitter<MenuEditState> emit,
  ) async {
    emit(state.copyWith(
      price: event.price,
    ));
  }

  Future<void> _handleEditChangeMenuCategoryEvent(
    EditChangeMenuCategoryEvent event,
    Emitter<MenuEditState> emit,
  ) async {
    emit(state.copyWith(
      category: event.category,
    ));
  }
}
