import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    required this.alignment,
  }) : super(key: key);

  final Alignment alignment;
  final String title;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      height: SizeConfig.blockVertical! * 10,
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      // color: primaryColor,
      child: Align(
        alignment: alignment,
        child: Text(
          title,
          style: blackFont.copyWith(
            fontSize: SizeConfig.blockHorizontal! * 6,
            color: blackColor,
          ),
        ),
      ),
    );
  }
}
