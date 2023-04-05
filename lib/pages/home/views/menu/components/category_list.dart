import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/models/CategoryModel.dart';
import 'package:mefl_app_bloc/models/MenuModel.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/services/menu_service.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key? key, required this.categories, required this.services})
      : super(key: key);

  MenuService services;
  List<CategoryModel> categories;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final categories = widget.categories;
    return BlocListener<MenuBloc, MenuState>(
      listener: (context, state) {},
      child: Container(
        width: double.infinity,
        height: SizeConfig.blockVertical! * 4,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final data = categories[index];
            return Container(
              margin: EdgeInsets.only(right: SizeConfig.blockHorizontal! * 3),
              child: ElevatedButton(
                onPressed: () {
                  widget.services.categoryFunction(data.categoryId!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                ),
                child: Text(
                  data.name,
                  style: boldFont.copyWith(
                    color: blackColor,
                    fontSize: SizeConfig.blockHorizontal! * 3,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
