import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:generateur_de_recu/screens/home.dart';
import 'package:generateur_de_recu/screens/menu.dart';
import 'package:generateur_de_recu/screens/splash.dart';
import 'package:generateur_de_recu/util/splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('locataire_box');
  await Hive.openBox('signature_box');
  await Hive.openBox('invoice_box');
  await Hive.openBox('test_box');

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashWidget(nextPage: HomePage(), child: SplashPage()),
      // home: const HomePage(),
    );
  }
}

