import 'package:flutter/material.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/models/review.dart';
import 'package:zaheb/ui/widgets.dart';
import 'package:zaheb/utils/database.dart';

class RestaurantReviewsScreen extends StatelessWidget {

  final Restaurant restaurant;

  const RestaurantReviewsScreen({Key key, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUi(title: 'التقيمات والمراجعات'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: StarDisplay(value: restaurant.stars),
                    ),
                    SizedBox(height: 7.0),
                    Text('استنادا الى ${restaurant.numberOfVotes} تقيمات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey[300],
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                    ),

                    buildFirstWidget('الجودة من حيث الطعم', restaurant.starsTasteQuality),
                    buildFirstWidget('نظافة الفرع', restaurant.starsClean),
                    buildFirstWidget('وقت التحضير', restaurant.starsPrepartionTime),
                    buildFirstWidget('التزام الفرع بالوقت', restaurant.starsTimeCommitment),
                    buildFirstWidget('تغليف الطلب', restaurant.starsPackagingRequest),



                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[300],
                margin: EdgeInsets.only(top: 5, bottom: 5),
              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: _buildReviewsList(),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return StreamBuilder(
      stream: Database().fetchRestaurantReviews(restaurant.id),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
        if(!snapshot.hasData) {
          return Container();
        } else {
          List<Review> reviews = snapshot.data;
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemCount: reviews.length,
              itemBuilder: (BuildContext context, int index) {
                Review review = reviews[index];
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(review.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      StarDisplay(value: review.stars),
                      Text(review.review),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.access_time, size: 17.0),
                          Text(review.date)
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                      ),
                    ],
                  ),
                );
              },
          );
        }
      },
    );
  }
}
