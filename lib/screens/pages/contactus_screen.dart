import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaheb/screens/pages/page_content_box.dart';
import 'package:zaheb/ui/widgets.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool completedLoading = false;
  bool isSmallScreen = false;

  @override
  void initState() {
    getTexts();
    super.initState();
  }

  String contactText = '', appNumber = '', twitter = '', gMail = '', mail = '';
  getTexts() {
    Firestore.instance
        .collection('siteConfigs')
        .document('texts')
        .get()
        .then((res) {
      setState(() {
        contactText = res.data != null ? res.data['contactus'] : '';
        appNumber = res.data != null ? res.data['phoneContactus'] : '';
        twitter = res.data != null ? res.data['twitter'] : '';
        gMail = res.data != null ? res.data['gMail'] : '';
        mail = res.data != null ? res.data['mail'] : '';
        completedLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 400) {
      isSmallScreen = true;
    }
    return completedLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarUi(title: 'اتصل بنا'),
      body: PageContentWidget(content: contactContactUs(context)),
    ) : LoadingScreen(true);
  }

  Widget contactContactUs(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(contactText,
            style: TextStyle(
                fontSize: 15.0,
                wordSpacing: 1.3,
                height: 1.5)),
        SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              appNumber.toString().length > 4
                  ? Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      var phone = appNumber;
                      var url =
                          'whatsapp://send?phone=$phone';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                        'assets/images/whatsapp.png',
                        width: 50.0),
                  )
                ],
              )
                  : SizedBox.shrink(),
              twitter.toString().length > 4
                  ? Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      var url = twitter;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                        'assets/images/twitter.png',
                        width: 50.0),
                  )
                ],
              )
                  : SizedBox.shrink(),
              mail.toString().length > 4
                  ? Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      var url = "mailto:$mail";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                        'assets/images/mail.png',
                        width: 50.0),
                  )
                ],
              )
                  : SizedBox.shrink(),
            ],
          ),
        )
      ],
    );
  }
}

/*

 */
