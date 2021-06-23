import 'package:cloud_firestore/cloud_firestore.dart';

class Options {
  String id;
  String restaurantId;
  String menuId;
  String name;
  bool required;

  Options({
    this.id,
    this.restaurantId,
    this.menuId,
    this.name,
    this.required,
  });

  factory Options.fromMap(Map<String, dynamic> json) => Options(
    id: json["id"],
    restaurantId: json["restaurantId"],
    menuId: json["menuId"],
    name: json["name"],
    required: json["required"],
  );

  factory Options.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;
    return Options(
      id: doc.documentID,
      restaurantId: json["restaurantId"] ?? '',
      menuId: json["menuId"] ?? '',
      name: json["name"] ?? '',
      required: json["required"] ?? false,
    );
  }
}