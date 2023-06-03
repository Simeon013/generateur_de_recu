import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:generateur_de_recu/screens/creatte_invoice.dart';
import 'package:generateur_de_recu/screens/home.dart';
import 'package:generateur_de_recu/screens/menu.dart';
import 'package:generateur_de_recu/screens/settings.dart';
import 'package:generateur_de_recu/screens/splash.dart';
import 'package:generateur_de_recu/util/splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'constants/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('locataire_box');
  await Hive.openBox('profile_box');
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
      home: const SplashWidget(nextPage: Home(), child: SplashPage()),
      // home: const HomePage(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _tabPages = [
      const HomePage(),
      const SettingsPage()
    ];

    final _bottomItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ];

    assert(_tabPages.length == _bottomItems.length);

    final bottomNavBar = BottomNavigationBar(
      items: _bottomItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index){
        setState(() {
          _currentTabIndex = index;
        });
      },
    );

    return Scaffold(
      body: _tabPages[_currentTabIndex],
      floatingActionButton: Container(
        decoration: AppWidgets.fabDecoration,
        child: FloatingActionButton(
          onPressed: ()=> _createInvoice(),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavBar,
    );
  }

  void _createInvoice(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateInvoicePage()));
  }
}


