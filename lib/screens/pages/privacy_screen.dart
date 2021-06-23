import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/screens/pages/page_content_box.dart';
import 'package:zaheb/ui/widgets.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool completedLoading = false;

  @override
  void initState() {
    getTexts();
    super.initState();
  }

  String privacyText = '';

  getTexts() {
    Firestore.instance.collection('siteConfigs').document('texts').get().then((res) {
      print(res.data);
      setState(() {
        privacyText = res.data != null ? res.data['privacy'] : '';
        completedLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarUi(title: 'الخصوصية والاستخدام'),
      body: PageContentWidget(content: Text("$privacyText", style: TextStyle(fontSize: 18.0, wordSpacing: 1.3, height: 1.5))),
    );
  }
}