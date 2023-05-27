import 'dart:async';

import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  final int time;
  final Widget child, nextPage;
  const SplashWidget({Key? key, this.time = 3, required this.child, required this.nextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: time), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage));
    });
    return child;
  }
}
