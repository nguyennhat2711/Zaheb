import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/screens/restauran/restaurant_details_screen.dart';
import 'package:zaheb/screens/restauran/restaurant_menu_widget.dart';
import 'package:zaheb/screens/restauran/restaurant_reviews_screen.dart';
import 'package:zaheb/ui/widgets.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantMenuScreen({Key key, this.restaurant}) : super(key: key);
  @override
  _RestaurantMenuScreenState createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {

  int tabIndex = 0;





  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = false;
    if(MediaQuery.of(context).size.width <= 400) {
      isSmallScreen = true;
    }
    final Map<int, Widget> tabsContentScreens = <int, Widget>{
      0: RestaurantMenu(id: widget.restaurant.id),
      1: RestaurantMenu(id: widget.restaurant.id, byType: 1),
      2: RestaurantMenu(id: widget.restaurant.id, byType: 2),
    };
    return Scaffold(
      appBar: appBarUi(title: widget.restaurant.name),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
      //    height: MediaQuery.of(context).size.height * 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: 'logo${widget.restaurant.id}',
                  child: Image(
                    image: NetworkImage(widget.restaurant.image),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('قائمة الاصناف', style: isSmallScreen ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.headline),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => RestaurantReviewsScreen(restaurant: widget.restaurant)));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                StarDisplay(value: widget.restaurant.stars),
                                SizedBox(width: 5),
                                Text(widget.restaurant.numberOfVotes.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 15 : 25)),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => RestaurantDetailsScreen(restaurant: widget.restaurant)));
                              },
                              child: Icon(Icons.info_outline),
                          ),
                        ],
                      ),

                      _buildSegmentsUi(context),

                      tabsContentScreens[tabIndex],

                      SizedBox(height: 50),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildSegmentsUi(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 11.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.grey[300],
                width: 2,
              )
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          segmentBox('القائمة', Icons.fastfood, 0),
          segmentBox('مقبلات', Icons.library_books, 1),
          segmentBox('حلويات', Icons.favorite, 2),
        ],
      ),
    );

  }




  Widget segmentBox(String title, IconData icon, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          tabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: index == tabIndex ? BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                  width: 2,
                )

            )
        ) : BoxDecoration(),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Theme.of(context).primaryColorDark,),
            SizedBox(width: 5),
            Text(' $title ', style: TextStyle(color: tabIndex == index ? Theme.of(context).primaryColorDark : null),),
          ],
        ),
      ),
    );
  }

}
