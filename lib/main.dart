import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zaheb/myapp/my_app_start.dart';
import 'package:zaheb/utils/utils.dart';

void main() => runApp(RunTheApp());

class RunTheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Utils()),
        StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
      ],
      child: MyApp(),
    );
  }
}