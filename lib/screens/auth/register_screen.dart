import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/screens/auth/login_screen.dart';
import 'package:zaheb/screens/auth/verified_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:zaheb/ui/widgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController _phoneControllerInput = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  FocusNode _nameInput;
  @override
  void initState() {
    super.initState();
    _nameInput = FocusNode();
  }

  @override
  void dispose() {
    _nameInput.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    FirebaseUser user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user == null;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'مستخدم جديد',
          style: TextStyle(fontSize: 15.0),
        ),
        centerTitle: true,
      ),
      body: loggedIn ? Center(
        child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _registerFormKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 37.0),
                  LogoUi(),
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
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5.0),
                              prefixIcon: Icon(Icons.phone_android,
                                  color: Theme.of(context).primaryColor),
                              hintText: "رقم الجوال",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            textDirection: TextDirection.ltr,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(_nameInput);
                            },
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
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                                  borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            enabled: false,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _nameTextController,
                    focusNode: _nameInput,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يجب عليك ادخال الاسم';
                      }

                      if (value.isNotEmpty && value.length > 30) {
                        return 'يجب أن يكون الاسم  مكون من 30 حرفًا او اقل.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5.0),
                      prefixIcon: Icon(Icons.person,
                          color: Theme.of(context).primaryColor),
                      hintText: "الاسم",
                      labelText: 'الاسم',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Text("متابعة"),
                      onPressed: () {
                        if (_registerFormKey.currentState.validate()) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return new AlertDialog(
                                  content: Text(
                                    'سيتم ارسال رمز التحقق الى الرقم التالي : ${_phoneControllerInput.text}',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(builder: (BuildContext context) => VerifiedCodeScreen(number: _phoneControllerInput.text, displayName: _nameTextController.text)));
                                      },
                                      child: Text('متابعة'),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('الغاء'),
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
              /*    SizedBox(height: 20.0),
                  Text(
                    'عند ضغطك على متابعة فهذا يعني موافقتك على',
                    style: TextStyle(fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text(
                        'شروط ادارة التطبيق وقوانين الحماية',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Container()));
                      },
                    ),
                  ),*/
                  SizedBox(height: 20.0),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                    },
                    child: Text('لدي حساب بالفعل', style: TextStyle(fontSize: 11.0),),
                  )

                ],
              ),
            )),
      ) : LoggedInUi(),
    );
  }
}
