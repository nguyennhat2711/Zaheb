import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zaheb/screens/home_screen.dart';
import 'package:zaheb/screens/pages/more_screen.dart';
import 'package:zaheb/screens/user/user_cart_list.dart';
import 'package:zaheb/screens/user/user_orders_screen.dart';
import 'package:zaheb/utils/utils.dart';

class MainContentTabs extends StatefulWidget {
  final int setIndex;

  const MainContentTabs({Key key, this.setIndex}) : super(key: key);
  @override
  _MainContentTabsState createState() => _MainContentTabsState();
}

class _MainContentTabsState extends State<MainContentTabs> {

  final List<Widget> _tapChildren = [
    HomeScreen(),
    UserOrdersScreen(),
    UserCartListScreen(),
    MoreScreen(),
  ];


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      // TODO : user != null
      child: _tapChildren[Provider.of<Utils>(context).currentTapIndex],
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('انت على وشك مغادرة التطبيق'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('البقاء', style: TextStyle(color: Theme.of(context).primaryColorDark)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('المغادرة', style: TextStyle(color: Theme.of(context).primaryColorDark)),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }
}
