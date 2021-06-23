import 'package:flutter/material.dart';
import 'package:zaheb/screens/auth/login_screen.dart';

class LoggedInUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('انت مسجل دخول بالفعل...'),
    );
  }
}

class NotLoggedInUi extends StatelessWidget {
  final completedLoading;

  const NotLoggedInUi({Key key, this.completedLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: completedLoading != null || completedLoading == false
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('يجب عليك تسجيل الدخول اولا'),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text('تسجيل دخول'),
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  final bool visible;
  LoadingScreen(this.visible);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Visibility(
        visible: widget.visible,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.9),
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

Widget appBarUi({String title}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
  );
}

class StarDisplay extends StatelessWidget {
  final int value;

  const StarDisplay({Key key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(Icons.star,
            color: index < value ? Colors.yellow[600] : Colors.grey[200],
            size: 17.0);
      }),
    );
  }
}

class StarDisplayVote extends StatelessWidget {
  final int value;
  final void Function(int index) onChanged;

  const StarDisplayVote({Key key, this.value, this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
          width: 30.0,
          child: IconButton(
            onPressed: onChanged != null ? () {
                onChanged(value == index + 1 ? index : index + 1);
              } : null ,
            icon: Icon(index < value ? Icons.star : Icons.star_border,
                color: index < value ? Colors.yellow[600] : Colors.grey,
                size: 30.0
            ),
          ),
        );
      }),
    );
  }
}


Widget buildFirstWidget(String title, int stars) {
  return Container(
    margin: EdgeInsets.only(top: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        Row(
          children: <Widget>[
            StarDisplay(value: stars),
            SizedBox(width: 15),
            Text(stars.toDouble().toString()),
          ],
        )
      ],
    ),
  );
}

Widget textFormFieldUi(
    BuildContext context, hintText, IconData icon, TextInputType typeInput,
    {TextEditingController controller}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 11.0),
    child: Material(
      elevation: 1.0,
      shadowColor: Colors.black.withOpacity(0.1),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 15.0,
          ),
          hintText: hintText,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide:
                  BorderSide(color: Colors.grey, style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                  style: BorderStyle.solid)),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: typeInput,
      ),
    ),
  );
}

Widget flatButtonUiCallback(
    BuildContext context, String text, VoidCallback callBack,
    {Color color}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.grey[300]],
        tileMode: TileMode.repeated,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(1,5),
          blurRadius: 1,
        )
      ],
    ),
    child: FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
      textColor: Colors.black,
      child: Text(' $text ', style: TextStyle(fontSize: 13.0)),
      onPressed: callBack,
    ),
  );
}


Widget flatButtonUiCallbackSec(BuildContext context, String text, VoidCallback callBack, {Color color}) {
  return Container(
    width: double.infinity,
    child: FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
      color: color != null ? color : Theme.of(context).primaryColorDark,
      textColor: color != null ? Colors.black : Colors.white,
      child: Text(' $text ', style: TextStyle(fontSize: 13.0)),
      onPressed: callBack,
    ),
  );
}

class LogoUi extends StatelessWidget {
  final bool isSmallScreen;

  const LogoUi({Key key, this.isSmallScreen = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage('assets/images/zaheb-logo.png'),
          width: isSmallScreen ? 150.0: 250.0,
        ),
      ),
    );
  }
}


Widget printStatusOrder(String getStatus) {
  int status = int.tryParse(getStatus ?? '0');
  if(status == 0) {
    return Text('قيد المراجعة', style: TextStyle(color: Colors.grey));
  } else if(status == 1) {
    return Text('تم قبول الطلب', style: TextStyle(color: Colors.orange));
  } else if(status == 2) {
    return Text('تم تسليم الطلب', style: TextStyle(color: Colors.greenAccent));
  }  else if(status == 3) {
    return Text('تم تاكيد استلام الطلب', style: TextStyle(color: Colors.green));
  }  else if(status == 4) {
    return Text('تم تاكيد استلام الطلب', style: TextStyle(color: Colors.green));
  }  else if(status == 9) {
    return Text(' الطلب ملغي', style: TextStyle(color: Colors.red));
  } else {
    return SizedBox.shrink();
  }
}