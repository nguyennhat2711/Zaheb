import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/myapp/main_content.dart';
import 'package:zaheb/screens/auth/register_screen.dart';
import 'package:zaheb/screens/auth/verified_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/ui/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _phoneControllerInput = TextEditingController();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user == null;
    bool isSmallScreen = MediaQuery.of(context).size.width <= 400;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: loggedIn ? Center(
        child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _loginKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 37.0),
                  LogoUi(isSmallScreen: isSmallScreen),
                  SizedBox(height: 25.0),
                  Text('التسجيل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 15.0 : 25.0, color: Theme.of(context).primaryColorDark), textAlign: TextAlign.center),
                  SizedBox(height: 37.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: TextFormField(
                            controller: _phoneControllerInput,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'يرجى ادخال رقم الهاتف';
                              }
                              if (input.isNotEmpty && (input.length > 10 || input.length < 9)) {
                                return 'يرجى ادخال رقم هاتف صحيح';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5.0),
                              prefixIcon: Icon(Icons.phone_android),
                              hintText: "رقم الجوال",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            validator: (input) {
                              if(_phoneControllerInput.text.isEmpty) {
                                return '';
                              }
                              if (_phoneControllerInput.text.isNotEmpty && (_phoneControllerInput.text.length > 10 || _phoneControllerInput.text.length < 9)) {
                                return '';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(9.0),
                              hintText: "966+",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                                  borderSide: BorderSide.none
                              ),
                              filled: true,
                            ),
                            enabled: false,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 45.0),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                      child: Text("تسجيل دخول"),
                      onPressed: () async {
                        if (_loginKey.currentState.validate()) {
                          if(_phoneControllerInput.text == '555555555') {
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => VerifiedCodeScreen(number: _phoneControllerInput.text)));
                          } else {
                            var number = "+966${_phoneControllerInput.text}";
                            await Firestore.instance.collection('users').where('phone', isEqualTo: number).getDocuments().then((r) {
                              if(r.documents.length > 0) {
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => VerifiedCodeScreen(number: _phoneControllerInput.text)));
                              } else {
                                Toast.show('رقم الهاتف غير مربوط مع اي حساب يرجى انشاء حساب جديد.', context, gravity: Toast.TOP, duration: Duration(seconds: 3).inSeconds);
                              }
                            });
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
                    },
                    child: Text('انشاء حساب', style: TextStyle(color: Colors.grey),),
                  ),
                  SizedBox(height: 15.0),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()), (Route<dynamic> route) => false);
                    },
                    child: Text('الانتقال للرئيسية', style: TextStyle(color: Colors.grey),),
                  ),


                ],
              ),
            )),
      ) : LoggedInUi(),
    );
  }
}
