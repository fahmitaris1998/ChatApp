import 'file:///D:/project%20flutter/crud_firebase/lib/ScreenAdmin/dashboardadmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/mainagora.dart';
import 'package:crud_firebase/newApp.dart';
import 'package:crud_firebase/notif.dart';
import 'package:crud_firebase/user/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:device_preview/device_preview.dart';
import 'chatconseling2.dart';
import 'kotaksuara.dart';
import '../main.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var role = preferences.getString('role');
  runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          home: role == "admin" ? DashboardAdmin(): Dashboard(),
        ),
      )
  );
}

class Dashboard extends StatefulWidget {
  final String back;

  const Dashboard({Key key, this.back}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  String user;
  _openPopup(context) {
    Alert(
      context: context,
      title: "",
      content: Column(
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    ).show();
  }



  Future logout(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
//    var username = preferences.getString('username');
    collectionReference
        .doc(preferences.getString('username'))
        .update({'tokenandroid':"none"});

    preferences.remove('username');
    preferences.remove('role');
    setState(() {
      Navigator.pushReplacement(context, new MaterialPageRoute(
          builder: (context) => LoginBK()
      ));
    });

  }
  Future<String> getusername()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('username').toString();
  }

  Future<void> updatescreen(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference.doc(doc_id).update({"screen":"dashboard user"});

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm a').format(DateTime.now());
    print(formattedDate);
    _getusername();

  }
  _getusername() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("username");
    });
    updatescreen(user);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.blue,
      //   leading:  IconButton(
      //       icon: Icon(Icons.menu),
      //     ),
      // ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40))
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0,bottom: 20.0,left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,),
                              ),
                            ),
                          )
                      ),
                      Text("Counseling",textAlign: TextAlign.left ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                      SizedBox(height: 30.0,),
                      Text("Are you facing a problem?",textAlign: TextAlign.left ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                      SizedBox(height: 10.0,),
                      Text("If you have problems regarding your personal. Tell us immediately to be able to help you.",textAlign: TextAlign.left ,style: TextStyle(color: Colors.white,fontSize: 15),),
                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RaisedButton(
                              textColor: Colors.blue,
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 5.0,),
                                    Text("Send Mailbox",style: TextStyle(fontSize: 15.0),)
                                  ],
                                ),
                              ),
                              onPressed: () {
//                              _openPopup(context);
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => KotakSuara()
                                ));
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: RaisedButton(
                              textColor: Colors.blue,
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat,
                                      color: Colors.blue,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 5.0,),
                                    Text("Counseling Now",style: TextStyle(fontSize: 15.0),)
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => MainAgora()
                                        //ChatConseling2(refresh: _getusername,)
                                ));
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          ),


                        ],
                      )

                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
