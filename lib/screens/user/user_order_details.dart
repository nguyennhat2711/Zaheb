import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/screens/restauran/restaurant_add_review_screen.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/database.dart';

class UserOrderDetailsScreen extends StatefulWidget {
  final Map orderDetails;

  const UserOrderDetailsScreen({Key key, this.orderDetails}) : super(key: key);
  @override
  _UserOrderDetailsScreenState createState() => _UserOrderDetailsScreenState();
}

class _UserOrderDetailsScreenState extends State<UserOrderDetailsScreen> {
  PageController controller;
  FirebaseUser user;

  int status;
  Map order;
  List foods;
  String statusText = '';
  bool c = false;
  bool itsCooker = false;
  bool completedLoading = false;
  Restaurant restaurantDetails;
  @override
  void initState() {
    super.initState();

    if(mounted) {
      setState(() {
        order = widget.orderDetails;
        foods = order['foodDetails'] ?? null;
        status = int.tryParse(widget.orderDetails['status'].toString());
        controller = PageController(
          initialPage: status == 9 ? 0 : status,
        );
        c = true;
      });
      getUserDetails();
    }
  }

  getUserDetails() async {
    user = await FirebaseAuth.instance.currentUser();
    var re = await Firestore.instance.collection('users').document(user.uid).get();
    if(re.data['restaurantId'] != null && re.data['restaurantId'].toString().isNotEmpty && widget.orderDetails['restaurantId'] == re.data['restaurantId']) {
      if(mounted) {
        setState(() {
          itsCooker = true;
          completedLoading = true;
        });
      }
    }
    if(widget.orderDetails['restaurantId'] != null && widget.orderDetails['restaurantId'].toString().isNotEmpty) {
      Firestore.instance.collection('restaurants').document(widget.orderDetails['restaurantId'].toString()).get().then((r) {
        if(mounted) {
          setState(() {
            restaurantDetails = Restaurant.fromFirestore(r);
          });
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    bool isTheSameUser = user.uid == order['userid'];
    DateTime getOrderDate = DateTime.fromMillisecondsSinceEpoch(int.tryParse(order['orderId'].toString()));
    String getOrderDateFixed = getOrderDate.toString().substring(0, 16);
    return Scaffold(
      appBar: AppBar(
        title: Text('طلب رقم ${order['orderId']}'),
        actions: <Widget>[
          isTheSameUser && status == 0
              ? FlatButton(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.black,
                  size: 10.0,
                ),
                SizedBox(width: 5.0),
                Text('الغاء الطلب', style: TextStyle(color: Colors.black))
              ],
            ),
            onPressed: () {
              Database().cancelOrder(order['orderId'], order['restaurantId'].toString(), canceledByUser: true).then((res) {
                if (res) {
                  setState(() {
                    status = 9;
                  });
                  controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                }
              });
            },
          )
              : SizedBox.shrink(),
          itsCooker && status != 9 ? PopupMenuButton<int>(
            onSelected: (v) {
              if (v.toString() == '1') {
                Database().acceptOrder(order['orderId'], order['userid']).then((res) {
                  if (res) {
                    setState(() {
                      status = 1;
                    });
                    controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                  }
                });
              } else if (v.toString() == '2') {
                Database().sendOrder(order['orderId'], order['userid']).then((res) {
                  if (res) {
                    setState(() {
                      status = 2;
                    });
                    controller.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                  }
                });
              } else if (v.toString() == '3') {
                Database().cancelOrder(order['orderId'], order['userid']).then((res) {
                  if (res) {
                    setState(() {
                      status = 9;
                    });
                    controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                  }
                });
              }
            },
            itemBuilder: (context) => [
              status != 9 && status == 0
                  ? PopupMenuItem(
                value: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.check_circle),
                    SizedBox(width: 5),
                    Text('قبول الطلب')
                  ],
                ),
              )
                  : null,
              status < 2
                  ? PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.send),
                    SizedBox(width: 5),
                    Text('تم تسليم الطلب')
                  ],
                ),
              )
                  : null,
              status != 9
                  ? PopupMenuItem(
                value: 3,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.cancel),
                    SizedBox(width: 5),
                    Text('الغاء الطلب')
                  ],
                ),
              )
                  : null,
            ],
          )
              : SizedBox.shrink(),
        ],
      ),
      backgroundColor: Colors.white,
      body: c ? PageView(
        controller: controller,
        physics: status == 9 ? NeverScrollableScrollPhysics() : null,
        children: <Widget>[
          Container(
            height: double.infinity,
            child: Opacity(
              opacity: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    status == 9 ? Text('تم الغاء هذا طلب.') : Text('تم ارسال الطلب الى المطعم بنجاح.'),
                    SizedBox(height: 15.0),
                    foods != null ?
                    Expanded(child: _buildFoodsListCart())
                        : SizedBox.shrink(),
                    Container(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        children: <Widget>[


                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('اجمالي السعر : ',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  Text(order['totalPrice'].toString() ?? '0', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
                                  SizedBox(width: 5.0),
                                  Text('ريال سعودي', style: TextStyle(fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          restaurantDetails != null && !itsCooker ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('الاستلام من مطعم :', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('${restaurantDetails.name} - ${restaurantDetails.city}', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ) : SizedBox.shrink(),

                          SizedBox(height: 15),
                          itsCooker ?  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('اسم العميل :', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order['username']}', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ) : SizedBox.shrink(),
                          SizedBox(height: 15),
                          itsCooker ?  InkWell(
                            onTap: () {
                              var phone = order['phone'];
                              phone = phone.replaceAll('+9660', '0');
                              phone = phone.replaceAll('+966', '0');
                              if(phone.toString().startsWith('5')) {
                                phone = '0$phone';
                              }
                              launch("tel://$phone");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('رقم الجوال :', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('${order['phone']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textDirection: TextDirection.ltr,)
                              ],
                            ),
                          ) : SizedBox.shrink(),

                          restaurantDetails != null && !itsCooker ? Align(
                            alignment: Alignment.center,
                            child: FlatButton(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.location_on,
                                      size: 25.0,
                                      color: Theme.of(context).primaryColor),
                                  Text(' عرض موقع المطعم')
                                ],
                              ),
                              onPressed: () async {
                                String googleUrl = restaurantDetails.googleMapUrl;
                                String iosUrl = restaurantDetails.googleMapUrlApple;
                                if (await canLaunch(googleUrl)) {
                                  await launch(googleUrl);
                                } else if (await canLaunch(iosUrl)) {
                                  await launch(iosUrl);
                                } else {
                                  Toast.show('لايمكن فتح الخريطة حاليا.', context);
                                }
                              },
                            ),
                          ) : SizedBox.shrink(),


                          Center(
                            child: Text(getOrderDateFixed, textDirection: TextDirection.ltr),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          status != 9 ? Container(
            child: Opacity(
              opacity: status > 0 ? 1 : 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/status1.png', width: 150),
                    SizedBox(height: 15.0),
                    Text('تم قبول الطلب وهو قيد تحضير.')
                  ],
                ),
              ),
            ),
          ) : SizedBox.shrink(),
          status != 9 ? Container(
            child: Opacity(
              opacity: status > 1 ? 1 : 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/status2.png', width: 150),
                    SizedBox(height: 15.0),
                    Text('تم تسليم الطلب.'),
                    SizedBox(height: 15.0),
                    status == 2 && isTheSameUser ? Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: flatButtonUiCallbackSec(context, 'تاكيد استلام الطلب', () => {
                        Firestore.instance.collection('orders').document(order['orderId']).updateData({'orderDetails.status': 3}).then((r) {
                          setState(() {
                            status = 3;
                            controller.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                          });
                        })
                      }),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ) : SizedBox.shrink(),
          status != 9 ? Container(
            child: Opacity(
              opacity: status > 2 ? 1 : 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/status3.png', width: 150),
                    SizedBox(height: 15.0),
                    Text('تم تاكيد استلام الطلب.'),
                    SizedBox(height: 15.0),
                    status == 3 && isTheSameUser ? Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: flatButtonUiCallbackSec(context, 'اضافة تقيم للمطعم', () => {
                        Firestore.instance.collection('orders').document(order['orderId']).updateData({'orderDetails.status': 4}).then((r) {
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => RestaurantAddReviewScreen(restaurantId: order['restaurantId'] ?? null)));
                        })
                      },
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ) : SizedBox.shrink(),

        ],
      ) : LoadingScreen(true),
    );
  }

  Widget _buildFoodsListCart() {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 400.0;
    return ListView.builder(
        itemCount: foods.length,
        itemBuilder: (BuildContext context, int index) {
          String subtitle = '';
          if(foods[index]['userOptionsSelected'] != null && foods[index]['userOptionsSelected'].length > 0) {
            subtitle = 'الاضافات : ';
            foods[index]['userOptionsSelected'].forEach((k, v) {
              subtitle = '$subtitle - ${v['userSelected']} ${v['price'].toString()} ريال';
            });
          }
          return Container(
            margin: EdgeInsets.only(bottom: 9.0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(15.0),
                  right: Radius.circular(15),
                ),
                child: Image.network(
                  foods[index]['image'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              title: Row(
                children: <Widget>[
                  Text("${foods[index]['quantity'] ?? ''} ${foods[index]['name']}", style: TextStyle(fontSize: isSmallScreen ? 13.0 : null)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("${foods[index]['price'].toString()} ريال", style: TextStyle(fontSize: 11.0)),
                  ),
                ],
              ),
              subtitle: Text(subtitle, style: TextStyle(fontSize: 11.0)),
            ),
          );
        }
    );
  }
}
