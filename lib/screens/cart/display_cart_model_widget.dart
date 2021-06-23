import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:zaheb/models/cart.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/utils.dart';

const double iconStartSize = 44;
const double iconEndSize = 80;
const double iconStartMarginTop = 1;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 44;
const double iconsHorizontalSpacing = 16;

class CartShoppingBottomUiSec extends StatefulWidget {
  final String restaurantID;

  const CartShoppingBottomUiSec({Key key, this.restaurantID}) : super(key: key);
  @override
  _CartShoppingBottomUiSecState createState() =>
      _CartShoppingBottomUiSecState();
}

class _CartShoppingBottomUiSecState extends State<CartShoppingBottomUiSec>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  double lerp(double min, double max) =>
      lerpDouble(min, max, _animationController.value);

  double get maxHeight => MediaQuery.of(context).size.height * 0.8;
  double minHeight = 80;

  double get itemBorderRadius => lerp(8, 24);

  double get imageSize => lerp(iconStartSize, iconEndSize);

  double imageTopMargin(int index) => lerp(iconStartMarginTop,
      iconEndMarginTop + index * (iconsVerticalSpacing + iconStartSize));

  double imageRightMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Utils>(context).getCartDetails(restaurantID: widget.restaurantID);
    var aCartItemsList = Provider.of<Utils>(context).cartDetails;
    List cartItemsList = aCartItemsList != null && aCartItemsList['cartDetails'] != null && aCartItemsList['cartDetails']['foodDetails'] != null ? aCartItemsList['cartDetails']['foodDetails'] : List();
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return cartItemsList.length > 0
            ? GestureDetector(
                onTap: _toggleCartBox,
                onVerticalDragUpdate: _dragUpdate,
                onVerticalDragEnd: _dragEnd,
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  height: lerp(minHeight, maxHeight),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(55)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(-5, -3),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      // ArrowButton(),
                      cartItemsList != null && cartItemsList.length > 0
                          ? Stack(
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.8,
                                    child: Stack(
                                      children: <Widget>[
                                        for (Map item in cartItemsList) _buildFullItemsCart(item),
                                      ],
                                    ),
                                  ),
                                ),
                                for (Map item in cartItemsList) _buildItemCart(item),
                              ],
                            )
                          : SizedBox.shrink(),
                      _animationController.status == AnimationStatus.completed
                          ? Positioned(
                              bottom: 0,
                              right: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.86,
                                    padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('اجمالي السعر', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Row(
                                          children: <Widget>[
                                            Text(aCartItemsList['cartDetails']['totalPrice'].toString() ?? '0', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
                                            SizedBox(width: 5.0),
                                            Text('ريال سعودي', style: TextStyle(fontWeight: FontWeight.bold))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.86,
                                      padding: EdgeInsets.only(
                                          top: 15.0, bottom: 5.0),
                                      color: Colors.white,
                                      child: flatButtonUiCallbackSec(
                                          context,
                                          'انهاء الطلب',
                                          () => CartOrdering().checkout(context, routeTo: true))),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.86,
                                      padding: EdgeInsets.only(
                                          top: 0.0, bottom: 0.0),
                                      color: Colors.white,
                                      child: flatButtonUiCallbackSec(
                                          context,
                                          'افراغ السلة',
                                          () => CartOrdering()
                                              .emptyCart(context)))
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildFullItemsCart(Map item) {
    Map aCartItemsList = Provider.of<Utils>(context).cartDetails;
    List cartItemsList = aCartItemsList != null ? aCartItemsList['cartDetails']['foodDetails'] : List();
    int index = cartItemsList.indexOf(item);
    return CartItemTitle(
      topMargin: imageTopMargin(
          index), //<--provide margins and height same as for icon
      rightMargin: imageRightMargin(index),
      height: imageSize,
      isVisible: _animationController.status ==
          AnimationStatus.completed, //<--set visibility
      borderRadius: itemBorderRadius, //<-- pass border radius
      title: item['name'], //<-- data to be displayed
      description: item['description'], //<-- data to be displayed
      price: item['totalItemPrice'].toString(),
      item: item,
    );
  }

  Widget _buildItemCart(Map item) {
    Map aCartItemsList = Provider.of<Utils>(context).cartDetails;
    List cartItemsList = aCartItemsList != null
        ? aCartItemsList['cartDetails']['foodDetails']
        : List();
    int index = cartItemsList.indexOf(item);
    return Positioned(
      height: imageSize,
      width: imageSize,
      top: imageTopMargin(index),
      right: imageRightMargin(index),
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(itemBorderRadius),
          right: Radius.circular(itemBorderRadius),
        ),
        child: Image.network(
          item['image'] ?? '',
          fit: BoxFit.cover,
          alignment: Alignment(
              lerp(1, 0), 0), //<-- Play with alignment for extra style points
        ),
      ),
    );
  }

  void _toggleCartBox() {
    final isToggled = _animationController.status == AnimationStatus.completed;
    _animationController.fling(velocity: isToggled ? -2 : 2);
  }

  void _dragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _dragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }
}

class ArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}

class CartItemTitle extends StatelessWidget {
  final double topMargin;
  final double rightMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String description;
  final String price;
  final String totalPrice;
  final item;

  const CartItemTitle(
      {Key key,
      this.topMargin,
      this.rightMargin,
      this.height,
      this.isVisible,
      this.borderRadius,
      this.title,
      this.description,
      this.price,
      this.totalPrice,
      this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 400.0;
    String subtitle = '';
    if(item['userOptionsSelected'] != null && item['userOptionsSelected'].length > 0) {
      subtitle = 'الاضافات : ';
      item['userOptionsSelected'].forEach((k, v) {
        subtitle = '$subtitle - ${v['userSelected']} ${v['price'].toString()} ريال';
      });
    }
    return Positioned(
      top: topMargin,
      right: rightMargin,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(microseconds: 150),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.87,
          padding: EdgeInsets.only(right: height + 10, top: 5),
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text("${item['quantity'] ?? ''} ${item['name']}", style: TextStyle(fontSize: isSmallScreen ? 13.0 : null)),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("${item['price'].toString()} ريال", style: TextStyle(fontSize: 11.0)),
                ),
              ],
            ),
            subtitle: Text(subtitle, style: TextStyle(fontSize: 11.0)),
            trailing: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                FirebaseUser user = Provider.of<FirebaseUser>(context);
                if (user != null) {
                  // Get the full cart list
                  Map cartList = Provider.of<Utils>(context).cartDetails;
                  // Set list for only the foods
                  List cartItemsList = cartList != null
                      ? cartList['cartDetails']['foodDetails']
                      : [];
                  cartItemsList = cartItemsList.toList();
                  // Remove the food item from the list
                  cartItemsList.remove(item);
                  // Remove the price
                  cartList['cartDetails']['totalPrice'] = int.tryParse(cartList['cartDetails']['totalPrice'].toString() ?? '0') - int.tryParse(price ?? '0');
                  // RePut the  new list foods to the cart
                  cartList['cartDetails']['foodDetails'] = cartItemsList;
                  // send to save it
                  Firestore.instance
                      .collection('users')
                      .document(user.uid)
                      .updateData({'cart': cartList});
                }
              },
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

}
