import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String restaurantId;
  int stars;
  int starsTasteQuality;
  int starsClean;
  int starsPrepartionTime;
  int starsTimeCommitment;
  int starsPackagingRequest;
  String name;
  String review;
  String userName;
  String phoneMobile;
  String userId;
  int timestamp;
  String date;

  Review({
    this.id,
    this.restaurantId,
    this.stars,
    this.starsTasteQuality,
    this.starsClean,
    this.starsPrepartionTime,
    this.starsTimeCommitment,
    this.starsPackagingRequest,
    this.name,
    this.review,
    this.userName,
    this.phoneMobile,
    this.userId,
    this.timestamp,
    this.date,
  });

  factory Review.fromMap(Map<String, dynamic> json) =>
      Review(
        id: json["id"],
        restaurantId: json["restaurantId"],
        stars: json["stars"],
        starsTasteQuality: json["starsTasteQuality"],
        starsClean: json["starsClean"],
        starsPrepartionTime: json["starsPrepartionTime"],
        starsTimeCommitment: json["starsTimeCommitment"],
        starsPackagingRequest: json["starsPackagingRequest"],
        name: json["name"],
        review: json["review"],
        userName: json["userName"],
        phoneMobile: json["phoneMobile"],
        userId: json["userId"],
        timestamp: json["timestamp"],
        date: json["date"],
      );

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;
    return Review(
      id: doc.documentID,
      restaurantId: json["restaurantId"] ?? '',
      stars: json["stars"] ?? 0,
      starsTasteQuality: json["starsTasteQuality"] ?? 0,
      starsClean: json["starsClean"] ?? 0,
      starsPrepartionTime: json["starsPrepartionTime"] ?? 0,
      starsTimeCommitment: json["starsTimeCommitment"] ?? 0,
      starsPackagingRequest: json["starsPackagingRequest"] ?? 0,
      name: json["name"] ?? '',
      review: json["review"] ?? '',
      userName: json["userName"] ?? '',
      phoneMobile: json["phoneMobile"] ?? '',
      userId: json["userId"] ?? '',
      timestamp: json["timestamp"] ?? '',
      date: json["date"] ?? '',
    );
  }

}