import 'package:flutter/material.dart';

class SizeConfig {
  Size? size;
  static double? blockWidth;
  static double? blockHeight;
  static double? blockHorizontal;
  static double? blockVertical;

  init(BuildContext context) {
    size = MediaQuery.of(context).size;
    blockWidth = size!.width;
    blockHeight = size!.height;
    blockHorizontal = blockWidth! / 100;
    blockVertical = blockHeight! / 100;
  }
}
