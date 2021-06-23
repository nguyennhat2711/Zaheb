//import 'package:flutter/material.dart';
//
//class Text extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: PopupMenuButton<int>(
//        onSelected: (v) {
//
//        },
//        itemBuilder: (context) => [
//        PopupMenuItem(
//        value: 1,
//        child: Row(
//          children: <Widget>[
//            Icon(Icons.check_circle),
//            SizedBox(width: 5),
//            Text('قبول الطلب'),
//          ],
//        ),
//      ),
//      ),
//    );
//  }
//}
//
//
//
//
//
//
//
////import 'package:flutter/material.dart';
////
////
////
////
////
////class CartShoppingBottomUi extends StatefulWidget {
////  @override
////  _CartShoppingBottomUiState createState() => _CartShoppingBottomUiState();
////}
////
////class _CartShoppingBottomUiState extends State<CartShoppingBottomUi> {
////  @override
////  Widget build(BuildContext context) {
////    return Container(
////      width: MediaQuery.of(context).size.width,
////      height: 75,
////      padding: EdgeInsets.all(15.0),
////      color: Colors.grey[200],
////      child: Row(
////        mainAxisAlignment: MainAxisAlignment.end,
////        crossAxisAlignment: CrossAxisAlignment.end,
////        children: <Widget>[
////          Expanded(
////            child: ListView.builder(
////                scrollDirection: Axis.horizontal,
////                itemCount: 3,
////                itemBuilder: (BuildContext context, int index) {
////                  return Container(
////                    width: 45,
////                    height: 45,
////                    margin: EdgeInsets.only(right: 8.0),
////                    decoration: BoxDecoration(
////                      color: Colors.white,
////                      // borderRadius: BorderRadius.circular(15),
////                      shape: BoxShape.circle,
////                      image: DecorationImage(
////                        fit: BoxFit.fill,
////                        image: NetworkImage(
////                            'https://img.buzzfeed.com/thumbnailer-prod-us-east-1/dc23cd051d2249a5903d25faf8eeee4c/BFV36537_CC2017_2IngredintDough4Ways-FB.jpg'),
////                      ),
////                      boxShadow: [
////                        BoxShadow(
////                          color: Colors.black.withOpacity(0.10),
////                          offset: Offset(0, 0),
////                          blurRadius: 7,
////                        ),
////                      ],
////                    ),
////                  );
////                }),
////          ),
////          Container(
////            width: 50,
////            height: 50,
////            margin: EdgeInsets.only(right: 15.0),
////            decoration: BoxDecoration(
////              color: Colors.red,
////              shape: BoxShape.circle,
////            ),
////            child: Icon(Icons.send, color: Colors.white),
////          ),
////        ],
////      ),
////    );
////  }
////}
