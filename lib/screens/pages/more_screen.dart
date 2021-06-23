import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaheb/cooker/orders_list_screen.dart';
import 'package:zaheb/screens/auth/login_screen.dart';
import 'package:zaheb/screens/auth/logout.dart';
import 'package:zaheb/screens/pages/contactus_screen.dart';
import 'package:zaheb/screens/pages/join_us_screen.dart';
import 'package:zaheb/screens/pages/privacy_screen.dart';
import 'package:zaheb/screens/pages/whous_screen.dart';
import 'package:zaheb/screens/user/user_edit_profile_screen.dart';
import 'package:zaheb/ui/tabs.dart';
import 'package:zaheb/ui/widgets.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  FirebaseUser user;
  bool isInitialized = false;
  bool itsCooker = false;
  String restaurantId;
  bool completedLoading = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }


  getUserDetails() async {
    user = await FirebaseAuth.instance.currentUser();
    if(user != null) {
      var re = await Firestore.instance.collection('users').document(user.uid).get();
      if(re.data['restaurantId'] != null && re.data['restaurantId'].toString().isNotEmpty) {
        if(mounted) {
          setState(() {
            itsCooker = true;
            restaurantId = re.data['restaurantId'].toString();
            completedLoading = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!isInitialized) {
      user = Provider.of<FirebaseUser>(context);
      isInitialized = true;
    }
    return Scaffold(
      appBar: appBarUi(title: 'المزيد'),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(15.0, MediaQuery.of(context).size.height*0.10, 15.0, 15.0),
          padding: EdgeInsets.only(top: 25, bottom: 35.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              menuButtonWidget(context, Icons.info_outline, 'من نحن', WhoUsScreen()),
              menuButtonWidget(context, Icons.person_outline, 'سجل معنا كمطعم', JoinUsScreen()),
              menuButtonWidget(context, Icons.message, 'اتصل بنا', ContactUsScreen()),
              menuButtonWidget(context, Icons.credit_card, 'تعديل البيانات', UserEditProfileScreen()),
              menuButtonWidget(context, Icons.lock_open, 'الخصوصية و الاستخدام', PrivacyScreen()),
              completedLoading && itsCooker ? menuButtonWidget(context, Icons.list, 'ادارة الطلبات', OrdersListScreen(restaurantId: restaurantId)) : SizedBox.shrink(),
              user == null ? menuButtonWidget(context, Icons.vpn_key, 'تسجيل', LoginScreen()) : menuButtonWidget(context, Icons.vpn_key, 'تسجيل الخروج', LogoutPage()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBtns(),
    );
  }

  Widget menuButtonWidget(BuildContext context, IconData icon, String title, Widget routeTo) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 400;
    return InkWell(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => routeTo));
      },
      child: Container(
        margin: EdgeInsets.only(top: isSmallScreen ? 5.0 : 15.0),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(icon),
                SizedBox(width: isSmallScreen ? 10.0 : 15.0),
                Text(title, style: TextStyle(fontWeight: FontWeight.normal, fontSize: isSmallScreen ? 13.0 : 19.0)),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[350]),
          ],
        ),
      ),
    );
  }
}
