import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/screens/user/user_order_details.dart';
import 'package:zaheb/ui/tabs.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/database.dart';

class UserOrdersScreen extends StatefulWidget {
  @override
  _UserOrdersScreenState createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {

  FirebaseUser user;
  bool complatedLoading = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    setState(()  {
      complatedLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUi(title: 'طلباتي'),
      body: user != null ? Container(
        child: StreamBuilder(
          stream: Database().fetchUserOrder(user),
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return Container();
            } else {
              List<DocumentSnapshot> orders = snapshot.data.documents;
              orders = orders.reversed.toList();
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  Map orderDetails = orders[index]['orderDetails'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => UserOrderDetailsScreen(orderDetails: orderDetails)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text("الطلب رقم ${orderDetails['orderId']}"),
                          subtitle: printStatusOrder(orderDetails['status'].toString()),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ) : complatedLoading ? NotLoggedInUi() : SizedBox.shrink(),
      bottomNavigationBar: BottomNavBtns(),
    );
  }
}
