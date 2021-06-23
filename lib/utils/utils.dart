import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utils with ChangeNotifier {
  int _currentTapIndex = 0;
  int get currentTapIndex => _currentTapIndex;


  changeTapIndex(int newIndex) {
    _currentTapIndex = newIndex;
    notifyListeners();
  }


  Map<String, dynamic> _orderInfo = {};

  Map<String, dynamic> get getOrderInfo => _orderInfo;

  updateOrderInfo(Map<String, dynamic> newOrderData) {
    _orderInfo = newOrderData;
    notifyListeners();
  }

  Map<dynamic, dynamic> _cartDetails = Map();

  Map<dynamic, dynamic> get cartDetails => _cartDetails;
  getCartDetails({restaurantID, restaurantName, googleMap, appleMap}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      await Firestore.instance.collection('users').document(user.uid).get().then((DocumentSnapshot userDocuments) async {
        Map<dynamic, dynamic> cart = userDocuments.data['cart'];
        if(cart != null && cart.length > 0) {
          _cartDetails = userDocuments.data['cart'];
        } else {
          if(restaurantID.toString().isNotEmpty && restaurantID != null && restaurantID.toString().trim().isNotEmpty) {
            await Firestore.instance.collection('restaurants').document(restaurantID).get().then((DocumentSnapshot reDocuments) {
              Map<String, dynamic> docMap = reDocuments.data;
              _cartDetails = {
                "cartDetails": {
                  "orderId": DateTime.now().millisecondsSinceEpoch.hashCode.toString(),
                  "totalPrice": 0,
                  "username": userDocuments.data['username'],
                  "phone": user.phoneNumber,
                  "status": 0,
                  "userid": user.uid,
                  "foodDetails": [],
                  "restaurantId": restaurantID != null ? restaurantID : null,
                  "restaurantName": docMap != null ? docMap['name'] ?? '' : null,
                  "googleMap": docMap != null ? docMap['googleMapUrl'] ?? '' : null,
                  "appleMap": docMap != null ? docMap['googleMapUrlApple'] ?? '' : null,
                },
              };
            });
          } else {
            _cartDetails = {
              "cartDetails": {
                "orderId": DateTime.now().millisecondsSinceEpoch.hashCode.toString(),
                "totalPrice": 0,
                "username": userDocuments.data['username'],
                "phone": user.phoneNumber,
                "status": 0,
                "userid": user.uid,
                "foodDetails": [],
                "restaurantId": null,
                "restaurantName": null,
                "googleMap": null,
                "appleMap": null,
              },
            };
          }

        }
      });



      notifyListeners();
    }
  }
}
