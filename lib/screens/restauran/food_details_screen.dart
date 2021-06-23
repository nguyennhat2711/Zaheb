import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/models/menu.dart';
import 'package:zaheb/models/options.dart';
import 'package:zaheb/screens/cart/display_cart_model_widget.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/database.dart';
import 'package:zaheb/utils/utils.dart';

Map<String, Map<String, dynamic>> orderInfo = Map();

class FoodDetailsScreen extends StatefulWidget {
  final Menu foodDetails;

  const FoodDetailsScreen({Key key, this.foodDetails}) : super(key: key);

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {

// Carousel
  List _galleryZoomList = [];
  bool _showGallery = false;


  @override
  void initState() {
    setState(() {
      orderInfo = Map();
      orderInfo['foodDetails'] = {
        'foodId': widget.foodDetails.id,
        'name': widget.foodDetails.name,
        'price': widget.foodDetails.price,
        'description': widget.foodDetails.description,
        'image': widget.foodDetails.image,
        'categoryId': widget.foodDetails.categoryId,
        'restaurantId': widget.foodDetails.restaurantId,
        'quantity': 1,
        'qtyPrice': widget.foodDetails.price,
      };
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Menu food = widget.foodDetails;
    _galleryZoomList.clear();
    _galleryZoomList.add(food.image ?? '');
    // Get the options price and add it to the item
    var t = Provider.of<Utils>(context).getCartDetails(restaurantID: widget.foodDetails.restaurantId);
    int totalItemPrice = int.tryParse(widget.foodDetails.price);
    totalItemPrice = totalItemPrice ?? 0;
    if(orderInfo['userOptionsSelected'] != null && orderInfo['userOptionsSelected'].length > 0) {
      orderInfo['userOptionsSelected'].forEach((k, v) {
        print("totalItemPrice $totalItemPrice");
        totalItemPrice += int.tryParse(v['price'].toString() ?? '0') ?? 0;
      });
    }
    int quantity = int.tryParse(orderInfo['foodDetails']['quantity'].toString() ?? '1') ?? 0;
    totalItemPrice = (quantity ?? 1) * (totalItemPrice ?? 0);
    return _showGallery ? _zoomInImage(context) : Scaffold(
      appBar: appBarUi(title: 'تفاصيل الوجبة'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Container(
       //   height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showGallery = true;
                        });
                      },
                      child: Hero(
                        tag: 'foodImage${food.id}',
                        child: Container(
                          width: 200,
                          height: 200,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(15),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(food.image),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                offset: Offset(0, 0),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 11.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(food.name, style: Theme.of(context).textTheme.headline),
                        SizedBox(width: 5),
                        Text('${food.price} ريال ', style: TextStyle(fontSize: 11.0),)
                      ],
                    ),
                    SizedBox(height: 11.0),
                    Text(food.description),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                child: BuildOptionsFood(foodId: food.id),
              ),

              Container(
                height: 50.0,
               width: double.infinity,
               padding: EdgeInsets.all(15.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Text('الكمية'),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: <Widget>[
                       int.tryParse(orderInfo['foodDetails']['quantity'].toString() ?? '1') > 1 ? InkWell(
                         onTap: () {
                           var q = int.tryParse(orderInfo['foodDetails']['quantity'].toString() ?? '1') - 1;
                           var p = int.tryParse(widget.foodDetails.price ?? '1');
                           setState(() {
                             orderInfo['foodDetails']['quantity'] = q.toString();
                             var x = q * p;
                             orderInfo['foodDetails']['qtyPrice'] = x.toString();
                           });
                         },
                         child: Container(
                             decoration: BoxDecoration(
                               color: Color(0xFFD2DCD6),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(Icons.remove, color: Colors.white)),
                       ) : SizedBox.shrink(),
                       SizedBox(width: 10.0),
                       Text(orderInfo['foodDetails']['quantity'].toString() ?? '1'),
                       SizedBox(width: 10.0),
                       InkWell(
                         onTap: () {
                           var qty = int.tryParse(orderInfo['foodDetails']['quantity'].toString() ?? '1') + 1;
                           var price = int.tryParse(widget.foodDetails.price ?? '0');
                           setState(() {
                             orderInfo['foodDetails']['quantity'] = qty.toString();
                             var x = qty ?? 1 * price ?? 0;
                             orderInfo['foodDetails']['qtyPrice'] = x.toString();
                           });
                         },
                         child: Container(
                             decoration: BoxDecoration(
                               color: Color(0xFFD2DCD6),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(Icons.add, color: Colors.white)),
                       ),
                     ],
                   )
                 ],
               ),
              ),
              //
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('اجمالي السعر', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: <Widget>[
                        Text(totalItemPrice.toString() ?? '0', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
                        SizedBox(width: 5.0),
                        Text('ريال سعودي', style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: flatButtonUiCallbackSec(context, 'اضافة الوجبة للسلة', () =>_submitOrder(context)),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CartShoppingBottomUiSec(restaurantID: widget.foodDetails.restaurantId),
    );
  }

  _submitOrder(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      // Get the old cart list details from firestore or create a new cart to the user documents
      Provider.of<Utils>(context).getCartDetails(restaurantID: widget.foodDetails.restaurantId);
      // Get the cart list details
      Map<dynamic, dynamic> cartListDetails = Provider.of<Utils>(context).cartDetails;
      // Get the orderDetails and check if restaurant empty, if it not empty user can't make other to new restaurant
      if(cartListDetails['cartDetails']['restaurantId'] != null && cartListDetails['cartDetails']['restaurantId'].toString() != widget.foodDetails.restaurantId) {
        Toast.show('والان لكل مطعم طريقته الخاصة في تعامل لايمكنك طلب وجبات من مطاعم مختلفة حتى تنهي الطلب الحالي.', context, gravity: Toast.BOTTOM, duration: Duration(seconds: 5).inSeconds);
      } else {
        cartListDetails['cartDetails']['restaurantId'] = widget.foodDetails.restaurantId;
        // Get the options price and add it to the item
        int totalItemPrice = int.tryParse(widget.foodDetails.price);
        totalItemPrice = totalItemPrice ?? 0;
        if(orderInfo['userOptionsSelected'] != null && orderInfo['userOptionsSelected'].length > 0) {
          orderInfo['userOptionsSelected'].forEach((k, v) {
            totalItemPrice += int.tryParse(v['price'].toString() ?? '0') ?? 0;
          });
        }
        int quantity = int.tryParse(orderInfo['foodDetails']['quantity'].toString() ?? '1') ?? 0;
        totalItemPrice = (quantity ?? 1) * (totalItemPrice ?? 1);
        orderInfo['foodDetails']['totalItemPrice'] = totalItemPrice;
        orderInfo['foodDetails']['userOptionsSelected'] = orderInfo['userOptionsSelected'];

        // add the items to the cart and add the total price to the total cart price

        List foodDetailsFromCart = cartListDetails['cartDetails']['foodDetails'].toList() ?? [];
        foodDetailsFromCart.add(orderInfo['foodDetails']);
        cartListDetails['cartDetails']['foodDetails'] = foodDetailsFromCart;
        cartListDetails['cartDetails']['totalPrice'] = (int.tryParse(cartListDetails['cartDetails']['totalPrice'].toString()) ?? 0) + totalItemPrice;
        // save it to the firestore
        Firestore.instance.collection('users').document(user.uid).updateData(
            {'cart': cartListDetails}
        ).then((r) {
          Toast.show('تمت اضافة الوجبة للسلة بنجاح.', context, gravity: Toast.BOTTOM, duration: Duration(seconds: 2).inSeconds);
        });
      }


    } else {
      Toast.show('يرجى تسجيل دخول اولا.', context, gravity: Toast.BOTTOM, duration: Duration(seconds: 2).inSeconds);

    }
  }

  Widget _zoomInImage(BuildContext context) {
    return Visibility(
      visible: _showGallery,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                color: Colors.black,
                child: PhotoViewGallery.builder(
                  scrollPhysics: BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(_galleryZoomList[index]),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 1.1,
                    );
                  },
                  itemCount: _galleryZoomList.length,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.1,
              right: 5.0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 7.0),
                      Container(child: Text('اخفاء', style: TextStyle(color: Colors.white)))
                    ],
                  ), onPressed: () {
                  setState(() {
                    _showGallery = false;
                  });
                },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BuildOptionsFood extends StatefulWidget {
  final String foodId;

  const BuildOptionsFood({Key key, this.foodId}) : super(key: key);

  @override
  _BuildOptionsFoodState createState() => _BuildOptionsFoodState();
}

class _BuildOptionsFoodState extends State<BuildOptionsFood> {
  List<DocumentSnapshot> optionsValues = [];
  Map<String, Map<String, dynamic>> userOptionsSelected = Map();
  bool c = false;
  @override
  void initState() {
    Firestore.instance.collection('optionsValues').where('foodId', isEqualTo: widget.foodId).getDocuments().then((QuerySnapshot snapshot) {
      setState(() {
        optionsValues = snapshot.documents;
        c = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return c ? StreamBuilder(
      stream: Database().fetchFoodOptions(widget.foodId),
      builder: (BuildContext context, AsyncSnapshot<List<Options>> snapshot) {
        if(!snapshot.hasData) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            return Container(height: MediaQuery.of(context).size.height,child: LoadingScreen(true));
          }
        } else {
          List<Options> options = snapshot.data;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              Options option = options[index];
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                 //   color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(option.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 25),
                            Text(option.required ? '(اجباري)' : '(اختياري)', style: TextStyle(color: Theme.of(context).primaryColorDark)),
                          ],
                        ),
                        //Icon(Icons.arrow_drop_up)
                      ],
                    ),
                  ),
                  optionsValues.length > 0 ? Container(
                 //   height: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: optionsValues.length,
                      itemBuilder: (BuildContext context, int aIndex) {
                        if(optionsValues[aIndex].data['optionId'].toString() == option.id) {
                          bool selected = false;
                          if(userOptionsSelected.containsKey(option.id)) {
                            if(userOptionsSelected[option.id]['optionValueId'] == optionsValues[aIndex].documentID) {
                              selected = true;
                            }
                          }
                          return InkWell(
                            onTap: () {

                              if(userOptionsSelected.containsKey(option.id)) {
                                setState(() {
                                  userOptionsSelected.remove(option.id);
                                });

                              } else {
                                Map<String, dynamic> uMa = {
                                  'price': optionsValues[aIndex].data['price'],
                                  'optionTitle': option.name,
                                  'userSelected': optionsValues[aIndex].data['name'].toString(),
                                  'optionValueId': optionsValues[aIndex].documentID,
                                };
                                setState(() {
                                  userOptionsSelected[option.id] = uMa;
                                  orderInfo['userOptionsSelected'] = userOptionsSelected;
                                });
                              }

                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(top: 7.0),
                              decoration: BoxDecoration(
                                color: selected ? Theme.of(context).primaryColorDark : Colors.grey[200],
                                borderRadius: BorderRadius.circular(5.0)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(optionsValues[aIndex].data['name'] ?? '', style: TextStyle(color: selected ? Colors.white : Colors.black)),
                                  optionsValues[aIndex].data['price'].toString().isNotEmpty && optionsValues[aIndex].data['price'].toString() != '0' ? Row(
                                    children: <Widget>[
                                      Text(optionsValues[aIndex].data['price'].toString() ?? '0', style: TextStyle(color: selected ? Colors.white : Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 11),
                                      Text('ريال', style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                                    ],
                                  ) : Text('مجاني', style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 11.0)),

                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ) : SizedBox.shrink(),
                ],
              );
            },
          );
        }
      },
    ) : Container();
  }


}
