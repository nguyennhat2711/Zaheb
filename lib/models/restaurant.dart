import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String id;
  String image;
  String name;
  String description;
  double lat;
  double lng;
  String city;
  String openAt;
  String closeAt;
  String mobile;
  String whatsapp;
  int timestamp;
  int numberOfVotes;
  int stars;
  int starsTasteQuality;
  int starsClean;
  int starsPrepartionTime;
  int starsTimeCommitment;
  int starsPackagingRequest;
  String googleMapUrl;
  String googleMapUrlApple;
  int distance;
  int categoryNumberType;

  Restaurant({
    this.id,
    this.image,
    this.name,
    this.description,
    this.lat,
    this.lng,
    this.city,
    this.openAt,
    this.closeAt,
    this.mobile,
    this.whatsapp,
    this.timestamp,
    this.numberOfVotes,
    this.stars,
    this.starsTasteQuality,
    this.starsClean,
    this.starsPrepartionTime,
    this.starsTimeCommitment,
    this.starsPackagingRequest,
    this.googleMapUrl,
    this.googleMapUrlApple,
    this.distance,
    this.categoryNumberType,
  });

  factory Restaurant.fromMap(Map<String, dynamic> json) => Restaurant(
    image: json["image"],
    name: json["name"],
    description: json["description"],
    lat: json["lat"],
    lng: json["lng"],
    city: json["city"],
    openAt: json["openAt"],
    closeAt: json["closeAt"],
    mobile: json["mobile"],
    whatsapp: json["whatsapp"],
    timestamp: json["timestamp"],
    numberOfVotes: json["numberOfVotes"],
    stars: json["stars"],
    starsTasteQuality: json["starsTasteQuality"],
    starsClean: json["starsClean"],
    starsPrepartionTime: json["starsPrepartionTime"],
    starsTimeCommitment: json["starsTimeCommitment"],
    starsPackagingRequest: json["starsPackagingRequest"],
    googleMapUrl: json["googleMapUrl"] ?? '',
    googleMapUrlApple: json["googleMapUrlApple"] ?? '',
      distance: null,
  );

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;
    return  Restaurant(
      id: doc.documentID,
      image: json["image"] ?? '',
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      lat: double.tryParse(json["lat"].toString()) ?? null,
      lng: double.tryParse(json["lng"].toString()) ?? null,
      city: json["city"] ?? '',
      openAt: json["openAt"] ?? '',
      closeAt: json["closeAt"] ?? '',
      mobile: json["mobile"] ?? '',
      whatsapp: json["whatsapp"] ?? '',
      timestamp: json["timestamp"] ?? 0,
      numberOfVotes: json["numberOfVotes"] ?? 0,
      stars: json["stars"] ?? 0,
      starsTasteQuality: json["starsTasteQuality"] ?? 0,
      starsClean: json["starsClean"] ?? 0,
      starsPrepartionTime: json["starsPrepartionTime"] ?? 0,
      starsTimeCommitment: json["starsTimeCommitment"] ?? 0,
      starsPackagingRequest: json["starsPackagingRequest"] ?? 0,
      googleMapUrl: json["googleMapUrl"] ?? '',
      googleMapUrlApple: json["googleMapUrlApple"] ?? '',
      distance: null,
      categoryNumberType: json["categoryNumberType"] ?? 0,
    );
  }

  static int calculateDistance(lat1, lon1, lat2, lon2){
    if(lat1 != null && lon1 != null && lat2 != null && lon2 != null) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
      var re = 12742 * asin(sqrt(a));
      return re.toInt() ?? 0;
    } else {
      return 0;
    }
  }
}
