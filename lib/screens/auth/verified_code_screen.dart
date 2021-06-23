import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/myapp/main_content.dart';
import 'package:zaheb/ui/widgets.dart';





class VerifiedCodeScreen extends StatefulWidget {
  final String number;
  final String displayName;

  const VerifiedCodeScreen({Key key, this.number, this.displayName}) : super(key: key);
  @override
  _VerifiedCodeScreenState createState() => _VerifiedCodeScreenState();
}

class _VerifiedCodeScreenState extends State<VerifiedCodeScreen> {


  @override
  Widget build(BuildContext context) {
    return SecVerifiedCodeScreen(number: widget.number, displayName: widget.displayName);
  }

}


class SecVerifiedCodeScreen extends StatefulWidget {
  final String number;
  final String displayName;

  const SecVerifiedCodeScreen({Key key, this.number, this.displayName}) : super(key: key);
  @override
  _SecVerifiedCodeScreenState createState() => _SecVerifiedCodeScreenState();
}

class _SecVerifiedCodeScreenState extends State<SecVerifiedCodeScreen>  {

  Auth authClient = Auth();
  bool _visibleLoading = false;
  TextEditingController _digitOne = TextEditingController();
  TextEditingController _digitTwo = TextEditingController();
  TextEditingController _digitThree = TextEditingController();
  TextEditingController _digitFour = TextEditingController();
  TextEditingController _digitFive = TextEditingController();
  TextEditingController _digitSix = TextEditingController();

  FocusNode _focusOne = FocusNode();
  FocusNode _focusTwo = FocusNode();
  FocusNode _focusThree = FocusNode();
  FocusNode _focusFour = FocusNode();
  FocusNode _focusFive = FocusNode();
  FocusNode _focusSix = FocusNode();
  String leftTimeForReSend = " ";
  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _digitOne.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if(mounted){
      setState(() {
        changeToNextInput(_digitOne, _focusTwo);
        changeToNextInput(_digitTwo, _focusThree);
        changeToNextInput(_digitThree, _focusFour);
        changeToNextInput(_digitFour, _focusFive);
        changeToNextInput(_digitFive, _focusSix);
      });
      sendSms();
    }

  }

  sendSms() async {
    await authClient.sendSmsCodeToUser(widget.number);
  }

  changeToNextInput(TextEditingController theInput, FocusNode nextInput) {
    theInput.addListener(() {
      if (theInput.text.length > 0 && nextInput != null) {
        setState(() {
          FocusScope.of(context).requestFocus(nextInput);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber = widget.number;
    FirebaseUser getUser = Provider.of<FirebaseUser>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'رمز التحقق',
          style: TextStyle(fontSize: 15.0),
        ),
        centerTitle: true,
      ),
      body: getUser == null ? Stack(
        children: <Widget>[
          Center(
            child: Form(
              key: _codeFormKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                      LogoUi(),
                      SizedBox(height: 37.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'سيتم ارسال رسالة بها رمز التحقق على الرقم التالي',
                          style: TextStyle(fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 11.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          ' $phoneNumber ',
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      codeInputs(context),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(13.0),
                          child: Text("تاكيد",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            // Check if first if user is logged
                            setState(() {
                              _visibleLoading = true;
                            });
                            await FirebaseAuth.instance.currentUser().then((user) {
                              if (user != null) {
                                Navigator.pop(context);
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()));
                              } else {
                                var getCode = _digitOne.text+_digitTwo.text+_digitThree.text+_digitFour.text+_digitFive.text+_digitSix.text;
                                if(getCode.trim().isNotEmpty) {
                                  authClient.register(getCode.toString(), widget.displayName).then((res) {
                                    setState(() {
                                      _visibleLoading = false;
                                    });
                                    switch(res) {
/*                                      case 404:
                                        return Toast.show('رمز التحقق خاطئ', context, gravity: Toast.TOP);
                                        break;*/
                                      case 505:
                                        return Toast.show('حدث خطاء عند التحقق يرجى محاولة في وقت لاحف ', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
                                        break;
                                      case 401:
                                        Toast.show('ليس هناك اي رمز مربوط مع رقم الهاتف.', context, gravity: Toast.TOP);
                                        break;
                                      case 200:
                                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()));
                                        break;
                                    }
                                  });
                                } else {
                                  Toast.show('يرجى ادخال رمز التحقق', context, gravity: Toast.TOP);
                                  setState(() {
                                    _visibleLoading = false;
                                  });
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          LoadingScreen(_visibleLoading),
        ],
      ) : Container(
        child: Center(
          child: FlatButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Colors.white,
            child: Text('الانتقال للرئيسية'),
            onPressed: () async {
              await _saveToken();
              Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()), (Route<dynamic> route) => false);
            },
          ),
        ),
      ),
    );
  }

  _saveToken() async {
    final Firestore _db = Firestore.instance;
    final FirebaseMessaging _firebaseMsg = FirebaseMessaging();
    String nToken;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (Platform.isIOS)  {
      _firebaseMsg.requestNotificationPermissions(IosNotificationSettings());
      _firebaseMsg.onIosSettingsRegistered.listen((data) async {
        nToken = await _firebaseMsg.getToken();
        if (nToken != null && user != null) {
          await _db.collection('users').document(user.uid).collection('tokens').document(nToken).setData({
            'userid': user.uid,
            'token': nToken,
            'created_at': FieldValue.serverTimestamp(),
            'username': user.displayName,
            'phone': user.phoneNumber,
          });
        }
      });
    } else {
      nToken = await _firebaseMsg.getToken();
      if (nToken != null && user != null) {
        await _db.collection('users').document(user.uid).collection('tokens').document(nToken).setData({
          'userid': user.uid,
          'token': nToken,
          'created_at': FieldValue.serverTimestamp(),
          'username': user.displayName,
          'phone': user.phoneNumber,
        });
      }
    }
  }

  Widget codeInputs(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: _digitOne,
            focusNode: _focusOne,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: _digitTwo,
            focusNode: _focusTwo,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: _digitThree,
            focusNode: _focusThree,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: _digitFour,
            focusNode: _focusFour,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: _digitFive,
            focusNode: _focusFive,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: _digitSix,
            focusNode: _focusSix,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }


}