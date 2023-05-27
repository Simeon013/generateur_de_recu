import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TextLiquidFill(
          loadDuration: const Duration(seconds: 3),
          waveDuration: const Duration(seconds: 3),
          text: 'Welcome',
          waveColor: Colors.blueAccent,
          boxBackgroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 70.0,
            fontWeight: FontWeight.bold,
          ),
          // boxHeight: 300.0,
        ),
      ),
    );
  }
}
