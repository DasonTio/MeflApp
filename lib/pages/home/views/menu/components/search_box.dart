import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/services/menu_service.dart';

class SearchBox extends StatefulWidget {
  SearchBox({
    Key? key,
    required this.services,
  }) : super(key: key);

  MenuService services;

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: whiteColor,
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      child: TextField(
        onChanged: (value) {
          widget.services.searchFunction(value);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: whiteColor,
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: blackColor,
          ),
          hintText: "Cari menu disini...",
        ),
      ),
    );
  }
}
