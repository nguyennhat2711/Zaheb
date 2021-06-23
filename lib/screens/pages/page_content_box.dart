import 'package:flutter/material.dart';


class PageContentWidget extends StatefulWidget {
  final Widget content;

  const PageContentWidget({Key key, this.content}) : super(key: key);

  @override
  _PageContentWidgetState createState() => _PageContentWidgetState();
}

class _PageContentWidgetState extends State<PageContentWidget> {
  @override

  bool isSmallScreen = false;

  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width <= 400) {
      isSmallScreen = true;
    }
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 35.0, bottom: 30.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter
                  )
              ),
              child: Align(
                alignment: Alignment.center,
                child: Image(
                  width: 150,
                  image: AssetImage('assets/images/zaheb-logo.png'),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bgg.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter)),
            /*  decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFfcfcfc), Color(0xFFebebeb)],
                    tileMode: TileMode.repeated,
                  ),
                  boxShadow: [
                    isSmallScreen ? BoxShadow(
                        color: Colors.black.withOpacity(0)
                    ) : BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(1,5),
                      blurRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))
              ),*/
              child: Padding(
                  padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 25.0),
                  child: widget.content
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 25.0, bottom: 55.0),
              margin: EdgeInsets.only(bottom: isSmallScreen ? 20 : 20.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bggg.png'),
                        fit: BoxFit.fill,
                        alignment: Alignment.bottomCenter)),
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}


