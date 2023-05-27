import 'package:flutter/widgets.dart';
import 'package:generateur_de_recu/constants/colors.dart';

class AppDimensions {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeightPercent(BuildContext context, double percent) {
    return (screenHeight(context) * percent) / 100;
  }

  static double screenWidthPercent(BuildContext context, double percent) {
    return (screenWidth(context) * percent) / 100;
  }

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 25.0;
  static const double iconSize = 24.0;
}
