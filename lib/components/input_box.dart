import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';

class InputBox extends StatelessWidget {
  const InputBox(
      {Key? key,
      this.controller,
      this.icon,
      required this.hint,
      this.onChanged,
      this.isHidden})
      : super(key: key);

  final Icon? icon;
  final String hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool? isHidden;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return TextFormField(
      onChanged: onChanged,
      obscureText: isHidden ?? false,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockHorizontal! * 3,
          vertical: SizeConfig.blockVertical!,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: blackColor.withOpacity(0.2),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: blackColor,
          ),
        ),
        focusColor: primaryColor,
        hintText: hint,
      ),
    );
  }
}
