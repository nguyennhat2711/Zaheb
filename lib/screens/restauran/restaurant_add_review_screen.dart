import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/myapp/main_content.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:intl/intl.dart';

class RestaurantAddReviewScreen extends StatefulWidget {
  final String restaurantId;
  final String orderId;

  const RestaurantAddReviewScreen({Key key, this.restaurantId, this.orderId}) : super(key: key);

  @override
  _RestaurantAddReviewScreenState createState() =>
      _RestaurantAddReviewScreenState();
}

class _RestaurantAddReviewScreenState extends State<RestaurantAddReviewScreen> {

  FirebaseUser user;
  int stars = 0;
  int starsTasteQuality = 0;
  int starsClean = 0;
  int starsPrepartionTime = 0;
  int starsTimeCommitment = 0;
  int starsPackagingRequest = 0;
  TextEditingController _name = TextEditingController();
  TextEditingController _review = TextEditingController();

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: appBarUi(title: 'استلام الطلب'),
      body: user != null ? SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('التقيم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('الجودة من حيث الطعم'),
                    Row(
                      children: <Widget>[
                        StarDisplayVote(
                          onChanged: (index) {
                            setState(() {
                              starsTasteQuality = index;
                            });
                          },
                          value: starsTasteQuality,
                        ),
                        SizedBox(width: 15),
                        Text(starsTasteQuality.toDouble().toString()),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('نظافة الفرع'),
                    Row(
                      children: <Widget>[
                        StarDisplayVote(
                          onChanged: (index) {
                            setState(() {
                              starsClean = index;
                            });
                          },
                          value: starsClean,
                        ),
                        SizedBox(width: 15),
                        Text(starsClean.toDouble().toString()),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('وقت التحضير'),
                    Row(
                      children: <Widget>[
                        StarDisplayVote(
                          onChanged: (index) {
                            setState(() {
                              starsPrepartionTime = index;
                            });
                          },
                          value: starsPrepartionTime,
                        ),
                        SizedBox(width: 15),
                        Text(starsPrepartionTime.toDouble().toString()),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('التزام الفرع بالوقت'),
                    Row(
                      children: <Widget>[
                        StarDisplayVote(
                          onChanged: (index) {
                            setState(() {
                              starsTimeCommitment = index;
                            });
                          },
                          value: starsTimeCommitment,
                        ),
                        SizedBox(width: 15),
                        Text(starsTimeCommitment.toDouble().toString()),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('تغليف الطلب'),
                    Row(
                      children: <Widget>[
                        StarDisplayVote(
                          onChanged: (index) {
                            setState(() {
                              starsPackagingRequest = index;
                            });
                          },
                          value: starsPackagingRequest,
                        ),
                        SizedBox(width: 15),
                        Text(starsPackagingRequest.toDouble().toString()),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 20.0),
              Text('الاسم', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              textFormFieldUi(context, '', Icons.title, TextInputType.text, controller: _name),
              SizedBox(height: 20.0),
              Text('التعليق', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              textFormFieldUi(context, '', Icons.message, TextInputType.text, controller: _review),
              SizedBox(height: 35.0),
              flatButtonUiCallback(context, 'ارسال', () => _submitReview())
            ],
          ),
        ),
      ) : SizedBox.shrink(),
    );
  }
  _submitReview() {
    if(_name.text.isEmpty || _review.text.isEmpty) {
      Toast.show('يرجى ملئ الاسم والتعليق معا.', context, gravity: Toast.TOP, duration: Duration(seconds: 3).inSeconds);
    } else {
      if(_name.text.length < 2 || _name.text.length > 15) {
        Toast.show('يرجى ملئ اسم مناسب.', context, gravity: Toast.TOP, duration: Duration(seconds: 3).inSeconds);
      } else if (_review.text.length <= 10) {
        Toast.show('يرجى ادخال تعليق مناسب.', context, gravity: Toast.TOP, duration: Duration(seconds: 3).inSeconds);
      } else {
        double starsDouble = (starsTasteQuality + starsClean + starsPrepartionTime + starsTimeCommitment + starsPackagingRequest) / 5;
        stars = starsDouble.toInt();
        var now = DateTime.now();
        String timeId = now.millisecondsSinceEpoch.toString();
        String date = new DateFormat.yMd().format(now);

        Firestore.instance.collection('restaurants').document(widget.restaurantId).collection('reviews').document(timeId).setData({
          'timestamp': int.parse(timeId),
          'date': date,
          'name': _name.text,
          'restaurantId': widget.restaurantId,
          'review': _review.text,
          'stars': starsDouble.toInt(),
          'starsTasteQuality': starsTasteQuality,
          'starsClean': starsClean,
          'starsPrepartionTime': starsPrepartionTime,
          'starsTimeCommitment': starsTimeCommitment,
          'starsPackagingRequest': starsPackagingRequest,
          'userId': user.uid,
          'userName': user.displayName,
          'phoneMobile': user.phoneNumber,
        }).then((r) {
       //   _name.clear();
        //  _review.clear();
          Firestore.instance.collection('restaurants').document(widget.restaurantId).get().then((DocumentSnapshot res) {
            Restaurant resT = Restaurant.fromFirestore(res);
            int restaurantNumberOfVotes = resT.numberOfVotes + 1;
            var restaurantNewStars = (resT.stars + (starsDouble / restaurantNumberOfVotes)).toInt();
            int restaurantStarsTasteQuality = (resT.starsTasteQuality + (starsTasteQuality / restaurantNumberOfVotes)).toInt();
            int restaurantStarsClean  = (resT.starsClean + (starsClean / restaurantNumberOfVotes)).toInt();
            int restaurantStarsPrepartionTime  = (resT.starsPrepartionTime + (starsPrepartionTime / restaurantNumberOfVotes)).toInt();
            int restaurantStarsTimeCommitment  = (resT.starsTimeCommitment + (starsTimeCommitment / restaurantNumberOfVotes)).toInt();
            int restaurantStarsPackagingRequest  = (resT.starsPackagingRequest + (starsPackagingRequest / restaurantNumberOfVotes)).toInt();
            Firestore.instance.collection('restaurants').document(widget.restaurantId).updateData({
              'numberOfVotes': restaurantNumberOfVotes,
              'stars': restaurantNewStars.toInt(),
              'starsTasteQuality': restaurantStarsTasteQuality,
              'starsClean': restaurantStarsClean,
              'starsPrepartionTime': restaurantStarsPrepartionTime,
              'starsTimeCommitment': restaurantStarsTimeCommitment,
              'starsPackagingRequest': restaurantStarsPackagingRequest,
              'lastModified': timeId,
              'lastModifiedDate': date,
            }).then((r){
              Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (BuildContext context) => MainContentTabs()), (Route<dynamic> route) => false);
            });

          });
        });
      }
    }
  }

}

