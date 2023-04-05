import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/components/category_list.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/add/bloc/menu_add_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/edit/bloc/menu_edit_bloc.dart';
import 'package:mefl_app_bloc/services/menu_service.dart';

class MenuEditPage extends StatefulWidget {
  const MenuEditPage({Key? key}) : super(key: key);

  @override
  _MenuEditPageState createState() => _MenuEditPageState();
}

class _MenuEditPageState extends State<MenuEditPage> {
  MenuService _menuService = MenuService();
  String? _value;

  @override
  void initState() {
    super.initState();
    _menuService.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<MenuEditBloc, MenuEditState>(
      listener: (context, state) {
        if (state.status == MenuAddStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) => Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.blockVertical! * 2,
                  ),
                  paddingContent(
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: SizeConfig.blockHorizontal! * 20,
                        ),
                        Text(
                          "Tambah Menu",
                          style: boldFont.copyWith(
                            fontSize: SizeConfig.blockHorizontal! * 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  formHeader('Foto produk'),
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding * 1.5,
                    ),
                    child: BlocBuilder<MenuEditBloc, MenuEditState>(
                      builder: (context, state) {
                        if (state.image == null) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<MenuEditBloc>()
                                  .add(EditChangeMenuImageEvent());
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: EdgeInsets.all(7.0),
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Color(0xFF727272),
                                  ),
                                ),
                                SizedBox(
                                    width: SizeConfig.blockHorizontal! * 4),
                                Text(
                                  "Pilih dari perangkat",
                                  style: regularFont.copyWith(
                                    fontSize: SizeConfig.blockHorizontal! * 4,
                                    color: Color(0xFFC3C3C3),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<MenuEditBloc>()
                                      .add(EditChangeMenuImageEvent());
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F5F5),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        child: Image.file(
                                          state.image!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: SizeConfig.blockHorizontal! * 4),
                                    Flexible(
                                      child: Text(
                                        state.image!.path,
                                        overflow: TextOverflow.ellipsis,
                                        style: regularFont.copyWith(
                                          fontSize:
                                              SizeConfig.blockHorizontal! * 4,
                                          color: Color(0xFFC3C3C3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  formHeader('Nama produk'),
                  formField(
                    onChange: (value) {
                      context
                          .read<MenuEditBloc>()
                          .add(EditChangeMenuNameEvent(name: value));
                    },
                    hintText: "Masukkan nama produk",
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical,
                  ),
                  formHeader('Kategori'),
                  dropDownField(onChange: (value) {
                    setState(() {
                      _value = value;
                    });
                    context
                        .read<MenuEditBloc>()
                        .add(EditChangeMenuCategoryEvent(category: value));
                  }),
                  SizedBox(
                    height: SizeConfig.blockVertical,
                  ),
                  formHeader('Harga'),
                  formField(
                    onChange: (value) {
                      context.read<MenuEditBloc>().add(
                          EditChangeMenuPriceEvent(price: num.parse(value ?? 0)));
                    },
                    hintText: "Rp.0",
                    numberType: true,
                  ),
                  SizedBox(
                    height: SizeConfig.blockVertical! * 25,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        paddingContent(
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<MenuEditBloc>().add(EditMenuEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: EdgeInsets.all(
                                    SizeConfig.blockHorizontal! * 4),
                              ),
                              child: Text(
                                'Proses',
                                style: boldFont.copyWith(color: blackColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paddingContent(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: child,
    );
  }

  Widget formHeader(String text) {
    return paddingContent(
      Text(
        text,
        style: boldFont.copyWith(
          fontSize: SizeConfig.blockHorizontal! * 4,
        ),
      ),
    );
  }

  Widget formField({
    required Function onChange,
    required String hintText,
    bool numberType = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        onChanged: (value) => onChange(value),
        decoration: InputDecoration(
          hintText: hintText,
          border: UnderlineInputBorder(),
          focusColor: Colors.black,
          focusedBorder: UnderlineInputBorder(),
        ),
        keyboardType: numberType ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget dropDownField({
    required Function onChange,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: StreamBuilder(
        stream: _menuService.allCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            // context
            //     .read<MenuEditBloc>()
            //     .add(EditChangeMenuCategoryEvent(category: data[0].categoryId!));
            return DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black45),
                  ),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  value: _value,
                  items: data
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e.categoryId,
                          ))
                      .toList(),
                  onChanged: (value) => onChange(value),
                ),
              ),
            );
          }
          return Container(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        },
      ),
    );
  }
}
