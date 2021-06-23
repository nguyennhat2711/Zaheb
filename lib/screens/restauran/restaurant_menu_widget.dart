import 'package:flutter/material.dart';
import 'package:zaheb/models/menu.dart';
import 'package:zaheb/screens/restauran/food_details_screen.dart';
import 'package:zaheb/utils/database.dart';

class RestaurantMenu extends StatelessWidget {
  final String id;
  final int byType;
  const RestaurantMenu({Key key, this.id, this.byType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = false;
    if(MediaQuery.of(context).size.width <= 400) {
      isSmallScreen = true;
    }
    return StreamBuilder(
      stream: Database().fetchRestaurantMenu(id,byType),
      builder: (BuildContext context, AsyncSnapshot<List<Menu>> snapshot) {
        if(!snapshot.hasData) {
          return Container();
        } else {
          List<Menu> foods = snapshot.data;
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemCount: foods.length,
              itemBuilder: (BuildContext context, int index) {
                Menu food = foods[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FoodDetailsScreen(foodDetails: food)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: ListTile(
                      leading: Hero(
                        tag: 'foodImage${food.id}',
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(food.image),
                          radius: 30,
                        ),
                      ),
                      title: Text(food.name, style: TextStyle(fontSize: isSmallScreen ? 15.0 : 20.0, fontWeight: FontWeight.bold)),
                      subtitle:  Column(
                        children: <Widget>[
                          Text(food.description, style: TextStyle(fontSize:  isSmallScreen ? 9.0 : 13.0)),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.monetization_on, color: Colors.grey[300], size: isSmallScreen ? 13.0 : 20),
                                  SizedBox(width: 5.0),
                                  Text(food.price, style: TextStyle(fontWeight: FontWeight.bold,fontSize:  isSmallScreen ? 13.0 : null)),
                                  SizedBox(width: 5.0),
                                  Text('ريال', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold,fontSize:  isSmallScreen ? 12.0 : null))
                                ],
                              ),
                              food.preparationTime != null ? Row(
                                children: <Widget>[
                                  Icon(Icons.access_time, color: Colors.grey[500], size: isSmallScreen ? 13.0 : 20),
                                  SizedBox(width: 5.0),
                                  Text(food.preparationTime, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold,fontSize:  isSmallScreen ? 13.0 : null))
                                ],
                              ) : SizedBox.shrink(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
          );
        }
      },
    );
  }
}

/*
return Container(
      height: 5000,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 11,
          itemBuilder: (BuildContext context, int index) {

          },
      ),
    );
 */
