import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  static double textSize(double size) {
    return blockSizeVertical * size;
  }

  static double iconSize(double size) {
    return blockSizeVertical * size;
  }

  static double imageSize(double size) {
    return blockSizeHorizontal * size;
  }

  static double paddingSize(double size) {
    return blockSizeHorizontal * size;
  }
}
