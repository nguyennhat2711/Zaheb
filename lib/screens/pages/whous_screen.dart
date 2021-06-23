import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/screens/pages/page_content_box.dart';
import 'package:zaheb/ui/widgets.dart';

class WhoUsScreen extends StatefulWidget {
  @override
  _WhoUsScreenState createState() => _WhoUsScreenState();
}

class _WhoUsScreenState extends State<WhoUsScreen> {
  bool completedLoading = false;

  @override
  void initState() {
    getTexts();
    super.initState();
  }

  String aboutText = '';

  getTexts() {
    Firestore.instance.collection('siteConfigs').document('texts').get().then((res) {
      print(res.data);
      setState(() {
        aboutText = res.data != null ? res.data['about'] : '';
        completedLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarUi(title: 'من نحن'),
      body: PageContentWidget(content: Text(aboutText, style: TextStyle(fontSize: 15.0, wordSpacing: 1.3, height: 1.5))),
    );
  }
}

