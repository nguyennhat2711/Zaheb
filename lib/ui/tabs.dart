import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaheb/utils/utils.dart';

class BottomNavBtns extends StatefulWidget {
  @override
  _BottomNavBtnsState createState() => _BottomNavBtnsState();
}

class _BottomNavBtnsState extends State<BottomNavBtns> {
  @override
  Widget build(BuildContext context) {
    final tapProvider = Provider.of<Utils>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: tapProvider.currentTapIndex,
      onTap: (index) {
        tapProvider.changeTapIndex(index);
      },
      items: [
        BottomNavigationBarItem(icon: new Icon(Icons.not_listed_location), title: new Text('اكتشف'),),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), title: Text('طلباتي')),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('سلتي')),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), title: Text('المزيد')),
      ],
    );
  }
}
