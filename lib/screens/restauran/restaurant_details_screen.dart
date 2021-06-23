import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaheb/models/restaurant.dart';
import 'package:zaheb/ui/widgets.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({Key key, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUi(title: 'معلومات عن المطعم'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(110),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            offset: Offset(0, 0),
                            blurRadius: 7,
                          ),
                        ]),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                    //  backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/fr/thumb/8/8d/Pizza_Hut_Logo_1967.svg/281px-Pizza_Hut_Logo_1967.svg.png'),
                      child: Image.network(restaurant.image),
                      radius: 110.0,
                    ),
                  ),
                  SizedBox(height: 11.0),
                  Text(restaurant.name, style: Theme.of(context).textTheme.headline),
                  SizedBox(height: 11.0),
                  StarDisplay(value: restaurant.stars),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Text('${restaurant.city} المملكة العربية السعودية'),
            Text(restaurant.mobile, textDirection: TextDirection.ltr),
            Text('ساعات العمل من ${restaurant.openAt} الى ${restaurant.closeAt}'),
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey[300],
              margin: EdgeInsets.only(top: 15, bottom: 15),
            ),
            InkWell(
              onTap: () {
                var phone = restaurant.mobile;
                phone = phone.replaceAll('+9660', '0');
                phone = phone.replaceAll('+966', '0');
                if(phone.toString().startsWith('5')) {
                  phone = '0$phone';
                }
                launch("tel://$phone");
              },
              child: Row(
                children: <Widget>[
                  Image(
                    image: NetworkImage('https://cdn2.iconfinder.com/data/icons/circle-icons-1/64/smartphone-512.png'),
                    width: 25,
                  ),
                  SizedBox(width: 10),
                  Text(restaurant.mobile, textDirection: TextDirection.ltr),
                ],
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {

                String url = 'whatsapp://send?phone=${restaurant.whatsapp}';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }

              },
              child: Row(
                children: <Widget>[
                  Image(
                    image: NetworkImage('https://cdn2.iconfinder.com/data/icons/social-icons-33/128/WhatsApp-512.png'),
                    width: 25,
                  ),
                  SizedBox(width: 10),
                  Text(restaurant.whatsapp, textDirection: TextDirection.ltr),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey[300],
              margin: EdgeInsets.only(top: 15, bottom: 15),
            ),
          ],
        ),
      ),
    );
  }
}
