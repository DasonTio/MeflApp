import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/components/button.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';
import 'package:mefl_app_bloc/pages/auth/login/login_view.dart';
import 'package:mefl_app_bloc/repository/menu_repo.dart';
import 'package:mefl_app_bloc/services/menu_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MenuService _menuService = MenuService();
  MenuRepo _menu = MenuRepo();

  TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _menuService.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: SizeConfig.blockWidth,
          height: SizeConfig.blockHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: "Settings",
                alignment: Alignment.centerLeft,
              ),
              formHeader('Add Category'),
              paddingContent(Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          hintText: "Masukkan kategori",
                          border: UnderlineInputBorder(),
                          focusColor: Colors.black,
                          focusedBorder: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockHorizontal! * 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      final data =
                          CategoryModel(name: _categoryController.text);
                      _menu.createCategory(data);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Icon(
                        Icons.save,
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              )),
              formHeader('Existing Category'),
              StreamBuilder(
                stream: _menuService.allCategories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Flexible(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final category = data[index];
                          return paddingContent(Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) {
                                    final newCategory = category.copyWith(name: value);
                                    _menu.updateCategory(newCategory);
                                  },
                                  initialValue: category.name,
                                  decoration: InputDecoration(
                                    hintText: "Masukkan kategori",
                                    border: UnderlineInputBorder(),
                                    focusColor: Colors.black,
                                    focusedBorder: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.blockHorizontal! * 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _menu.deleteCategory(category.categoryId!);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              )
                            ],
                          ));
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
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
}
