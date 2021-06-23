import 'package:flutter/material.dart';

class SplashScreenGif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/images/splash.gif", gaplessPlayback: true, fit: BoxFit.fill)
        ));
  }
}
