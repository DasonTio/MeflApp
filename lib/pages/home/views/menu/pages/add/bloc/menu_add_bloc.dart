import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/repository/menu_repo.dart';

part 'menu_add_event.dart';
part 'menu_add_state.dart';

class MenuAddBloc extends Bloc<MenuAddEvent, MenuAddState> {
  MenuAddBloc() : super(MenuAddState()) {
    on<ChangeMenuImageEvent>(_handleChangeMenuImageEvent);
    on<ChangeMenuNameEvent>(_handleChangeMenuNameEvent);
    on<ChangeMenuPriceEvent>(_handleChangeMenuPriceEvent);
    on<ChangeMenuCategoryEvent>(_handleChangeMenuCategoryEvent);
    on<AddMenuEvent>(_handleAddMenuEvent);
  }

  final _menu = MenuRepo();

  Future<void> _handleAddMenuEvent(
    AddMenuEvent event,
    Emitter<MenuAddState> emit,
  ) async {
    if (state.props.any((element) => element == null || element == '')) {
      return emit(state.copyWith(
        message: "Please fill all the field",
        status: MenuAddStatus.failure,
      ));
    }

    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('images');

      String unique = DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceImageToUpload = referenceDirImage.child(unique);

      await referenceImageToUpload.putFile(state.image!);
      String url = await referenceImageToUpload.getDownloadURL();

      await _menu.createMenu(MenuModel(
        name: state.name,
        price: state.price,
        categoryId: state.category,
        image: url,
        menuId: "${state.name}${DateTime.now().millisecond}",
      ));

      emit(state.copyWith(
        message: "Menu added",
        status: MenuAddStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        message: "FAILURE",
        status: MenuAddStatus.failure,
      ));
    }
  }

  Future<void> _handleChangeMenuImageEvent(
    ChangeMenuImageEvent event,
    Emitter<MenuAddState> emit,
  ) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);    
    emit(state.copyWith(
      image: file,
    ));
  }

  Future<void> _handleChangeMenuNameEvent(
    ChangeMenuNameEvent event,
    Emitter<MenuAddState> emit,
  ) async {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  Future<void> _handleChangeMenuPriceEvent(
    ChangeMenuPriceEvent event,
    Emitter<MenuAddState> emit,
  ) async {
    emit(state.copyWith(
      price: event.price,
    ));
  }

  Future<void> _handleChangeMenuCategoryEvent(
    ChangeMenuCategoryEvent event,
    Emitter<MenuAddState> emit,
  ) async {
    emit(state.copyWith(
      category: event.category,
    ));
  }
}
