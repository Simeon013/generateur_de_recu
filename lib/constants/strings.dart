import 'package:flutter/material.dart';

class AppStrings {
  static const String welcomeMessage = "Bienvenue dans notre application";
  static const String appName = "Mon Application";
  static const String headerTitle = "Générateur";
  static const String headerSubtitle = "Votre application";
  static const String submitButtonLabel = "Valider";
  static const String errorMessage = "Une erreur est survenue";
  static const String successMessage = "Opération réussie";

  static const String fileIconAsset = "assets/vs_code.png";

  static const String personIconAsset = "assets/icons/file.png";

  static const String invoiceIconAsset = "assets/icons/invoice.png";

  static const String pdfIconAsset = "assets/icons/file-pdf.png";

  static const List listAssets = [
    'assets/vs_code.png',
  ];

  static const List listRecent = [
    'recent1',
    'recent2',
    'recent3',
    'recent4',
  ];

  static const List listTitle = [
    'Titre 1',
    'Titre 2',
    'Titre 3'
  ];

  static const TextStyle welcomeMessageStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle littleText1 = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  static const TextStyle littleText2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
  );

  static const TextStyle headerTitleStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle headerSubtitleStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
  );

  static const TextStyle buttonLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  );

  static const TextStyle errorMessageStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );

  static const TextStyle successMessageStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  static const TextStyle listTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle formTitleStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    // fontWeight: FontWeight.bold
  );

  static String noInvoice = "Aucune facture";
}
