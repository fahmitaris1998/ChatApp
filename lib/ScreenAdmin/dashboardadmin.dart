import 'file:///D:/project%20flutter/crud_firebase/lib/ScreenAdmin/screenkotakmasuk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/ScreenAdmin/screenlistchat.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardAdmin(),
  ));
}
class DashboardAdmin extends StatefulWidget {
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  String user;

  final tabs = [
    ScreenKotakMasuk(),
    ScreenListChat(),
    Container(
      color: Colors.white,
      child: Center(
        child: Text("Screen History Chat counseling Soon"),
      ),
    )
  ];

  Future<String> getusername()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('username').toString();
  }

  Future<void> updatescreen(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference.doc(doc_id).update({"screen":"Dasbiard admin"});

  }

  _getusername() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("username");
    });
    updatescreen(user);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getusername();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            index: _page,
            key: _bottomNavigationKey,
            backgroundColor: Colors.white,
            color: Colors.blue,
            height: 50.0,
            items: <Widget>[
              Icon(Icons.message_outlined, size: 30,color: Colors.white,),
              Icon(Icons.track_changes, size: 30,color: Colors.white,),
              Icon(Icons.history, size: 30,color: Colors.white),
            ],
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          body: Container(
            color: Colors.blue,
            child: tabs[_page]
          ))
    );
  }
}
