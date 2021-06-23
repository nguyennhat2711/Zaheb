import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaheb/models/cart.dart';
import 'package:zaheb/ui/tabs.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/utils.dart';

class UserCartListScreen extends StatefulWidget {
  @override
  _UserCartListScreenState createState() => _UserCartListScreenState();
}

class _UserCartListScreenState extends State<UserCartListScreen> {

  FirebaseUser user;
  var aCartItemsList;
  List cartItemsList;
  bool isInitialized = false;
  bool complatedLoading = false;
  @override
  Widget build(BuildContext context) {
    if(!isInitialized) {
      Provider.of<Utils>(context).getCartDetails();
      user = Provider.of<FirebaseUser>(context);
      aCartItemsList = Provider.of<Utils>(context).cartDetails;
      cartItemsList = aCartItemsList != null && aCartItemsList['cartDetails'] != null && aCartItemsList['cartDetails']['foodDetails'] != null ? aCartItemsList['cartDetails']['foodDetails'] : List();
      isInitialized = true;
      complatedLoading = true;
    }
    return Scaffold(
      appBar: appBarUi(title: 'سلتي'),
      body: user != null ? Container(
        height: MediaQuery.of(context).size.height,
        child: cartItemsList != null && cartItemsList.length > 0 ? Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: cartItemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String subtitle = '';
                    if(cartItemsList[index]['userOptionsSelected'] != null && cartItemsList[index]['userOptionsSelected'].length > 0) {
                      subtitle = 'الاضافات : ';
                      cartItemsList[index]['userOptionsSelected'].forEach((k, v) {
                        subtitle = '$subtitle - ${v['userSelected']} ${v['price'].toString()} ريال';
                      });
                    }
                    return InkWell(
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FoodDetailsScreen()));
                      },
                      child:  Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(cartItemsList[index]['image'] ?? ''),
                            radius: 30,
                          ),
                          title: Row(
                            children: <Widget>[
                              Text("${cartItemsList[index]['quantity'] ?? ''} ${cartItemsList[index]['name']}", style: TextStyle(fontSize: 13.0 )),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("${cartItemsList[index]['price'].toString()} ريال", style: TextStyle(fontSize: 11.0)),
                              ),
                            ],
                          ),
                          subtitle: Text(subtitle, style: TextStyle(fontSize: 11.0)),
                        ),
                      ),
                    );
                  }
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                          Text(aCartItemsList['cartDetails']['totalPrice'].toString() ?? '0', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
                          SizedBox(width: 5.0),
                          Text('ريال سعودي', style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.86,
                          padding: EdgeInsets.all(15.0),
                          color: Colors.white,
                          child: flatButtonUiCallbackSec(context, 'انهاء الطلب', () => _submitOrder())
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.86,
                        padding: EdgeInsets.all(15.0),
                        color: Colors.white,
                        child: flatButtonUiCallbackSec(context, 'افراغ السلة', () => _emptyCart()),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ) : SizedBox.shrink(),
      ) : complatedLoading ? NotLoggedInUi() : SizedBox.shrink(),
      bottomNavigationBar: BottomNavBtns(),
    );
  }
  _emptyCart() {
    setState(() {
      CartOrdering().emptyCart(context);
      cartItemsList = [];
    });
  }

  _submitOrder() {
    cartItemsList = [];
    CartOrdering().checkout(context);
  }
}
