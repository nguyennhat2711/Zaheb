import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/myapp/main_content.dart';
import 'package:zaheb/utils/database.dart';
import 'package:zaheb/utils/utils.dart';
import 'package:intl/intl.dart';

class CartOrdering {

  checkout(BuildContext context, {routeTo = false}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      await Firestore.instance.collection('users').document(user.uid).get().then((DocumentSnapshot userDocuments) async {
        Map<dynamic, dynamic> cart = userDocuments.data['cart'];
        if(cart != null && cart.length > 0)  {
          DateTime now = DateTime.now();
          String date = new DateFormat.yMd().format(now);
          String day = new DateFormat.d().format(now);
          String month = new DateFormat.M().format(now);
          String year = new DateFormat.y().format(now);
          if(day.length == 1) {
            day = '0$day';
          }

          if(month.length == 1) {
            month = '0$month';
          }

          Map<String, dynamic> data = {
            'orderDetails': cart['cartDetails'],
            'items': cart['cartDetails']['foodDetails'],
            'userid': user.uid,
            'orderId': cart['cartDetails']['orderId'],
            'restaurantId': cart['cartDetails']['restaurantId'],
            'restaurantName': cart['cartDetails']['restaurantName'],
            'day': day,
            'month': month,
            'year': year,
            'md': '$month$day',
            'ym': '$year$month',
            'yd': '$year$day',
            'dmy': '$day$month$year',
            'date': date
          };
          await Firestore.instance.collection('orders').document(cart['cartDetails']['orderId']).setData(data);
          Firestore.instance.collection('users').document(user.uid).updateData({'cart': null}).then((r) {
            Toast.show('تم انشاء الطلب بنجاح', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
            Firestore.instance.collection('users').where('restaurantId', isEqualTo: cart['cartDetails']['restaurantId'].toString()).getDocuments().then((x) {
              x.documents.forEach((r) {
                if(r.data['restaurantId'] != null && r.data['restaurantId'].toString().isNotEmpty) {
                  Database().sendNotifications('طلب جديد', 'لديك طلب جديد رقم  ${cart['cartDetails']['orderId']}','newOrder', 't', r.documentID);
                }
              });
              Provider.of<Utils>(context).changeTapIndex(1);
              if(routeTo) {
                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()), (Route<dynamic> route) => false);
              }
            });
          });
        } else {
          Toast.show('يرجى اضافة اي طعام لسلتك اولا', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
        }
      });
    } else {
      Toast.show('يرجى تسجيل دخول او انشاء حساب اولا', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
    }
  }

  emptyCart(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      await Firestore.instance.collection('users').document(user.uid).get().then((DocumentSnapshot userDocuments) async {
        Map<dynamic, dynamic> cart = userDocuments.data['cart'];
        if(cart != null && cart.length > 0)  {
          Firestore.instance.collection('users').document(user.uid).updateData({'cart': null}).then((r) {
            Toast.show('تم افراغ سلتك بنجاح', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
          });
        } else {
          Toast.show('يبدو ان السلة فارغة حقا.', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
        }
      });
    } else {
      Toast.show('يرجى تسجيل دخول او انشاء حساب اولا', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
    }
  }

}