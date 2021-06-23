import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zaheb/models/menu.dart';
import 'package:zaheb/models/options.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/models/review.dart';

class Database {

  final Firestore _db = Firestore.instance;

  Stream<List<Restaurant>> fetchRestaurant() {
    var ref = _db.collection('restaurants').orderBy('timestamp', descending: true);
    return ref.snapshots().map((list) => list.documents.map((d) => Restaurant.fromFirestore(d)).toList());
  }

  Stream<List<Menu>> fetchRestaurantMenu(String id, int byType) {
    print(byType);
    if(byType != null){
        var ref = _db.collection('restaurants').document(id).collection('menu').where('type', isEqualTo: byType.toString());
        return ref.snapshots().map((list) => list.documents.map((food) => Menu.fromFirestore(food)).toList());
    } else {
        var ref = _db.collection('restaurants').document(id).collection('menu');
        return ref.snapshots().map((list) => list.documents.map((food) => Menu.fromFirestore(food)).toList());
    }
  }

  Stream<List<Review>> fetchRestaurantReviews(String id) {
    var ref = _db.collection('restaurants').document(id).collection('reviews').orderBy('timestamp', descending: true);
    return ref.snapshots().map((list) => list.documents.map((review) => Review.fromFirestore(review)).toList());
  }

  Stream<List<Options>> fetchFoodOptions(foodId) {
    var ref = _db.collection('options').where('foodId', isEqualTo: foodId);
    return ref.snapshots().map((list) => list.documents.map((option) => Options.fromFirestore(option)).toList());
  }

  Stream<QuerySnapshot> fetchUserOrder(FirebaseUser user) {
    var ref = _db.collection('orders').where('userid', isEqualTo: user.uid);
    return ref.snapshots();
  }

  Stream<QuerySnapshot> fetchRestaurantOrder(restaurantId) {
    var ref = _db.collection('orders').where('restaurantId', isEqualTo: restaurantId);
    return ref.snapshots();
  }

  void getTokenToSave() async {
    FirebaseMessaging _firebaseMsg = FirebaseMessaging();
    String nToken;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      if(Platform.isIOS) {
        _firebaseMsg.requestNotificationPermissions(IosNotificationSettings());
        _firebaseMsg.onIosSettingsRegistered.listen((data) async {
          nToken = await _firebaseMsg.getToken();
          if(nToken != null && user != null) {
            Database().saveTokenInDb(nToken,user);
          }
        });
      }
      nToken = await _firebaseMsg.getToken();
      if(nToken != null && user != null) {
        Database().saveTokenInDb(nToken,user);
      }
    }
  }

  void saveTokenInDb(String token, FirebaseUser user) async {
    if (token != null && user != null) {
      await Firestore.instance.collection('users').document(user.uid).collection('tokens').document(token).setData({
        'userid': user.uid,
        'token': token,
        'created_at': FieldValue.serverTimestamp(),
        'username': user.displayName,
        'phone': user.phoneNumber,
      });
    }
  }

  Future cancelOrder(String orderId, String orderUserId, {canceledByUser = false}) async {
    await Firestore.instance.collection('orders').document(orderId).updateData({"orderDetails.status": 9, "statuText": " الطلب ملغي"}).then((r) {
      if(canceledByUser) {
        Firestore.instance.collection('users').where('restaurantId', isEqualTo: orderUserId.toString()).getDocuments().then((x) {
          x.documents.forEach((r) {
            if(r.data['restaurantId'] != null && r.data['restaurantId'].toString().isNotEmpty) {
              Database().sendNotifications('تم الغاء الطلب', 'لقد تم الغاء الطلب رقم $orderId من طرف الزبون نفسه.','cancelOrder', 'cancelOrder', r.documentID);
            }
          });
        });
      } else {
        Database().sendNotifications('تم الغاء طلبك.', 'لقد تم الغاء طلبك رقم  $orderId','cancelOrder', 'cancelOrder', orderUserId);
      }
    });
    return true;
  }


  Future acceptOrder(String orderId, String orderUserId) async {
    await Firestore.instance.collection('orders').document(orderId).updateData({'orderDetails.status': 1, 'statuText': 'تم قبول الطلب'}).then((r) {
      Database().sendNotifications('تم قبول الطلب الخاص بك', 'لقد تم قبول طلبك رقم  $orderId','acceptOrder', 'acceptOrder', orderUserId);
    });
    return true;
  }

  Future sendOrder(String orderId, String orderUserId) async {
    await Firestore.instance.collection('orders').document(orderId).updateData({'orderDetails.status': 2, 'statuText': 'تم ارسال طلب'}).then((r) {
      Database().sendNotifications('لقد تم تسليم الطلب. ', 'يرجى تاكيد استلامك طلبك رقم $orderId','sendOrder', 'sendOrder', orderUserId);
    });
    return true;
  }


  Future sendNotifications(String title, String body, String type,iud,userID) async {
    final Firestore _db = Firestore.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Map<String, dynamic> data = {
      'title': title.toString(),
      'body': body.toString(),
      'type': type.toString(),
      'iud': iud.toString(),
      'userid': userID != null ? userID.toString() : user.uid.toString(),
      'read': '0',
      'clicked': '0',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    _db.collection('notifications').add(data);
  }
}