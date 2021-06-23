import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String id;
  String name;
  String description;
  String price;
  String preparationTime;
  String image;
  String categoryId;
  String restaurantId;
  String googleMapUrl;
  String googleMapUrlApple;
  String restaurantName;

  Menu({
    this.id,
    this.name,
    this.description,
    this.price,
    this.preparationTime,
    this.image,
    this.categoryId,
    this.restaurantId,
    this.restaurantName,
    this.googleMapUrl,
    this.googleMapUrlApple,
  });

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    preparationTime: json["preparationTime"],
    image: json["image"],
    categoryId: json["categoryId"],
    restaurantId: json["restaurantId"],
  );

  factory Menu.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;
    print(json["googleMapUrl"]);
    return Menu(
      id: doc.documentID,
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      price: json["price"].toString() ?? 'مجانا',
      image: json["image"] ?? '',
      preparationTime: '${json["preparationTime"] ?? 0} دقيقة '  ?? '',
      categoryId: json["categoryId"] ?? '',
      restaurantId: json["restaurantId"] ?? '',
      googleMapUrl: json["googleMapUrl"] ?? '',
      googleMapUrlApple: json["googleMapUrlApple"] ?? '',
      restaurantName: json["restaurantName"] ?? '',

    );
  }
}
