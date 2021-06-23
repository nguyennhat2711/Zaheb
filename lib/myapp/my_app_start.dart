import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zaheb/myapp/main_content.dart';
import 'package:zaheb/myapp/splash_screen.dart';
import 'package:zaheb/styles/theme.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _visible = true;
  @override
  void initState() {
    super.initState();
    new Future.delayed( const Duration(milliseconds: 5500), () {
      setState(() {
        _visible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [Locale("ar")],
      locale: Locale("ar"),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'زاهب',
      theme: themeStyle,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
           children: <Widget>[
             MainContentTabs(),
             IgnorePointer(
               ignoring: !_visible,
               child: AnimatedOpacity(
                 opacity: _visible ? 1.0 : 0.0,
                 duration: Duration(milliseconds: 700),
                 child: SplashScreenGif(),
               ),
             )
           ],
          ),
      ),
    );
  }
}
