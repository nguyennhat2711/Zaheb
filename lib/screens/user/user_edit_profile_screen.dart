import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/ui/widgets.dart';

class UserEditProfileScreen extends StatefulWidget {
  @override
  _UserEditProfileScreenState createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  final auth = FirebaseAuth.instance;
  bool _visibleLoading = true;

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();

  final GlobalKey<FormState> _userInfoKeyForm = GlobalKey<FormState>();
  FirebaseUser user;
  @override
  void initState() {
    getUser();
    super.initState();
  }
  getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _nameTextController.text = user.displayName;
      _phoneTextController.text = user.phoneNumber;
      _visibleLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'بيانات المستخدم',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: double.infinity,
              width: double.infinity,
              color: Color(0xfff3f3f8),
              child: Form(
                  key: _userInfoKeyForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      TextFormField(
                        controller: _nameTextController,
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
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 35.0),
                      TextFormField(
                        controller: _phoneTextController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5.0),
                          prefixIcon: Icon(Icons.phone_iphone,
                              color: Theme.of(context).primaryColor),
                          hintText: "رقم الجوال",
                          labelText: 'رقم الجوال',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        enabled: false,
                      ),
                      SizedBox(height: 21.0),
                      SizedBox(
                        width: double.infinity,
                        child: flatButtonUiCallbackSec(context, 'حفظ البيانات', () => updateInfo()),
                      ),

                    ].toList(),
                  )
              )),
          LoadingScreen(_visibleLoading),
        ],
      ),
    );
  }

  void updateInfo() async {
    if (_userInfoKeyForm.currentState.validate()) {
      setState(() {
        _visibleLoading = true;
      });
      FocusScope.of(context).requestFocus(FocusNode());
      final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = _nameTextController.text;
      final FirebaseUser user = await auth.currentUser();
      await user.updateProfile(userUpdateInfo);
      user.reload();
      Map<String, dynamic> setUserInfo = {
        'username': _nameTextController.text,
        'avatar': user.photoUrl,
      };
      Firestore.instance.collection('users').document(user.uid).updateData(setUserInfo).then((d) {
        /*
        Firestore.instance.collection('orders').where('userid', isEqualTo: user.uid).getDocuments().then((postsUser) {
          postsUser.documents.forEach((d) {
            Firestore.instance.collection('orders').document(d.documentID).updateData({'orderDetails.username': _nameTextController.text});
          });
        });
         */

      });
      Toast.show('تم تعديل البيانات بنجاح.', context, gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      setState(() {
        _visibleLoading = false;
      });
      // Navigator.of(context).pop();
    }
  }
}