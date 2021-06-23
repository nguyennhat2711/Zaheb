import 'package:zaheb/myapp/main_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutPage extends StatefulWidget {

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override

  void initState() {
    FirebaseAuth.instance.signOut().then((r) {
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()), (Route<dynamic> route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}