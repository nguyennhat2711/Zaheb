import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaheb/ui/widgets.dart';

class JoinUsScreen extends StatefulWidget {
  @override
  _JoinUsScreenState createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen> {

  bool onLoading = false;
  TextEditingController _workingName = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _whatsapp = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _commercialNumber = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUi(title: 'سجل معنا كمطعم'),
      backgroundColor: Colors.white,
      body: !onLoading ? SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image(
                width: 150,
                image: AssetImage('assets/images/join-us-image.png'),
              ),
            ),
            SizedBox(height: 20.0),

            Text('يشرفنا رغبتك في انضمامك الينا اضف مطعمك في زهّب  وانضم للعديد من المطاعم الاخرى.', textAlign: TextAlign.center,),
            SizedBox(height: 20.0),

            textFormFieldUi(context, 'الاسم التجاري', Icons.title, TextInputType.text, controller: _workingName),
            SizedBox(height: 20.0),
            textFormFieldUi(context, 'المدينة', Icons.location_on, TextInputType.text, controller: _city),
            SizedBox(height: 20.0),
            textFormFieldUi(context, 'العنوان', Icons.map, TextInputType.text, controller: _address),
            SizedBox(height: 20.0),
            textFormFieldUi(context, 'رقم الجوال', Icons.smartphone, TextInputType.phone, controller: _phone),
            SizedBox(height: 20.0),
            textFormFieldUi(context, 'رقم الواتساب', Icons.phone, TextInputType.phone, controller: _whatsapp),
            SizedBox(height: 20.0),
            textFormFieldUi(context, 'البريد الالكتروني', Icons.alternate_email, TextInputType.emailAddress, controller: _email),
            SizedBox(height: 20.0),
            textFormFieldUi(context, 'السجل التجاري', Icons.business, TextInputType.text, controller: _commercialNumber),
            SizedBox(height: 35.0),
            flatButtonUiCallbackSec(context, 'اضافة', () => _submitRequest())
          ],
        ),
      ) : LoadingScreen(true),
    );
  }

  _submitRequest() {
    if( _workingName.text.isEmpty || _city.text.isEmpty || _address.text.isEmpty || _phone.text.isEmpty || _whatsapp.text.isEmpty || _email.text.isEmpty || _commercialNumber.text.isEmpty) {
      Toast.show('يرجى ملء جميع الخانات.', context, gravity: Toast.TOP, duration: Duration(seconds: 3).inSeconds);
    } else {
      setState(() {
        onLoading = true;
      });
      Firestore.instance.collection('askforjoin').document(DateTime.now().millisecondsSinceEpoch.toString()).setData({
        '_workingName': _workingName.text,
        '_city': _city.text,
        '_address': _address.text,
        '_phone': _phone.text,
        '_whatsapp': _whatsapp.text,
        '_email': _email.text,
        '_commercialNumber': _commercialNumber.text,
      }).then((r) {
        _workingName.clear();
        _city.clear();
        _address.clear();
        _phone.clear();
        _whatsapp.clear();
        _email.clear();
        _commercialNumber.clear();
        Toast.show('تمت اضافة الطلبك بنجاك ونشكرك لذلك سوف نتواصل معك عن قريب قدر الامكان.', context, gravity: Toast.TOP, duration: Duration(seconds: 5).inSeconds);
        Navigator.pop(context);
      });

    }
  }

}



