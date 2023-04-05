import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.name,
    required this.onPress,
  }) : super(key: key);

  final String name;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(SizeConfig.blockHorizontal! * 4),
          backgroundColor: primaryColor,
        ),
        onPressed: () => onPress(),
        child: Text(
          name,
          style: boldFont.copyWith(
            color: blackColor,
            fontSize: SizeConfig.blockHorizontal! * 4,
          ),
        ),
      ),
    );
  }
}
