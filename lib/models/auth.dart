import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:zaheb/utils/database.dart';

class Auth with ChangeNotifier {



  String _verificationId;
  String number;
  int _loginStatus = 500000;

  get loginStatus => _loginStatus;

  Future sendSmsCodeToUser(number) async {
    _loginStatus = 0;
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) async {
      FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      await saveRegisterOrLogin(phoneAuthCredential, number);
    };

    final PhoneVerificationFailed verificationFailed = (AuthException athExp) {
      print('verificationFailed and error code is ${athExp.code} with a message says : ${athExp.message}');
    };

    final PhoneCodeSent codeSent = (String verficationId, [int forceResendingToken]) async {
      _verificationId = verficationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verficationId) {
      _verificationId = verficationId;
      print("TimeOut of sending sms code");
    };

    String num = number;
    if(number == '555555555' || number == '5555555555'){
      num = '+212697127035';
    } else {
      num = '+966$num';
    }
    print(num);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:  num,
        timeout: const Duration(milliseconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future register(String userCode, displayName) async {
    // TODO :: CHECK IF THE CODE IS WRONG BY PRINT $credential;
    final AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: userCode);
    return saveRegisterOrLogin(credential, displayName);
  }

  Future saveRegisterOrLogin(AuthCredential credential, displayName) async {
    await FirebaseAuth.instance.signInWithCredential(credential).then((u) async {
      if (u != null) {
        if(u.user.displayName == null){
          final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
          if(displayName == null && u.user.displayName == null) {
            displayName = u.user.phoneNumber.toString();
            userUpdateInfo.displayName = displayName;
            await u.user.updateProfile(userUpdateInfo);
            await u.user.reload();
          }
          Map<String, dynamic> setUserInfo = {
            'userid' : u.user.uid,
            'username': displayName,
            'phone': u.user.phoneNumber,
            'avatar': u.user.photoUrl,
            'banned': false,
            'bannedDays': 0,
          };
          Firestore.instance.collection('users').document(u.user.uid).setData(setUserInfo).then((u){
            Database().getTokenToSave();
          });
          _loginStatus = 200;
          notifyListeners();
          return 201;
        } else {
          Database().getTokenToSave();
          _loginStatus = 200;
          notifyListeners();
          return 200;
        }

      } else {
        return 401;
      }
    }).catchError((e) {
      print("error $e");
      return 505;

    });

    return 404;

  }


  displayErrorCodeMsg(code) {
    switch(code){
      case 200:
        return 'رمز التحقق صحيح جاري تحويلك';
        break;
      case 201:
        return 'يبدو انك انشئت حساب جديد لتو لذلك تم انشاء لك اسم افتراضي يجرى تغيره';
        break;
      case 200:
        return 'رمز التحقق صحيح جاري تحويلك';
        break;
      case 401:
        return 'لم يتم التعرف على الحساب';
        break;
      case 505:
        return 'حدث خطاء ما اتناء ارسال رمز التحقق';
        // TODO :: send notification to admins
        break;
      default:
        return '';
        break;
    }
  }




}
