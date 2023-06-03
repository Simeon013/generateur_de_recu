import 'package:flutter/material.dart';
import 'package:generateur_de_recu/constants/strings.dart';

import 'colors.dart';

class AppWidgets {
  static Icon searchIcon = const Icon(
    Icons.search,
    size: 28,
    color: Colors.white,
  );

  static Icon profileIcon = const Icon(
    Icons.person,
    size: 28,
    color: Colors.white,
  );

  static Icon notificationIcon = const Icon(
    Icons.notifications,
    size: 28,
    color: Colors.white,
  );

  static Icon addIcon = const Icon(
    Icons.add,
    size: 28,
    color: Colors.white,
  );

  static Icon signatureIcon = const Icon(
    Icons.mode_edit_outline_outlined,
    size: 28,
    color: Colors.white,
  );

  static BoxDecoration iconBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15.0),
    color: AppColors.iconBoxColor,
  );

  static BoxDecoration locataireBoxDecoration = BoxDecoration(
    color: AppColors.locataireBoxColor,
    borderRadius: BorderRadius.circular(15.0),
  );

  static BoxDecoration invoiceBoxDecoration = BoxDecoration(
    color: AppColors.invoiceBoxColor,
    borderRadius: BorderRadius.circular(15.0),
  );

  static BoxDecoration fabDecoration = const BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        spreadRadius: 7,
        blurRadius: 1
      )
    ],
  );

}
