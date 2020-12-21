import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/Card/mymessage.dart';
import 'package:crud_firebase/Card/othermessage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Chat(),
  ));
}

class Chat extends StatefulWidget {
  final String conselor;
  final String doc_id;
  final String sendfrom;
  final Function refresh;
  final String id_sendto;
  final String id_card_screen;

  const Chat({Key key, this.conselor, this.doc_id, this.sendfrom, this.refresh, this.id_sendto, this.id_card_screen}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController message = TextEditingController();
  ScrollController _controller = ScrollController();
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String id;
  String from;
  int indexto;
  int idx = 0;
  var role;

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('jadwalkonseling');
  CollectionReference crnewmssg = FirebaseFirestore.instance.collection('user');
  Query query;

  _getrole(doc_id)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      role = preferences.getString('role');
    });
    _updateNewMessage(doc_id,role);

  }
  Future<void> _sendmessage(doc_id,String msg){

    if(msg.isNotEmpty){
      Map<String,dynamic> data = {
        "From": widget.sendfrom,
        "timestamp":DateTime.now().millisecondsSinceEpoch,
        "date":DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()),
        "timesend":DateFormat('HH:mm a').format(DateTime.now()),
        "message":msg
      };
      print(data);
      print("id data : "+doc_id);
      collectionReference
          .doc(doc_id)
          .collection("historichat")
          .add(data)
          .then((value) {
//        _controller.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

          crnewmssg
            .doc(widget.id_sendto)
            .get()
            .then((DocumentSnapshot documentSnapshot) {

          if(documentSnapshot.data()['screen']!=widget.id_card_screen){
            sendAndRetrieveMessage(documentSnapshot.data()['tokenandroid'],data["message"]);
            collectionReference
                .doc(doc_id)
                .get()
                .then((DocumentSnapshot document){

              if (role != "admin"){

                var newmessage = int.parse(document.data()["nmkonseler"]) + 1;
                collectionReference
                    .doc(doc_id)
                    .update({"nmkonseler":newmessage.toString()});

              }else{

                var newmessage = int.parse(document.data()["nmkonsul"]) + 1;
                collectionReference
                    .doc(doc_id)
                    .update({"nmkonsul":newmessage.toString()});
              }
            });
          }
        });

      })
          .catchError((error) => print("Failed to add user: $error"));
    }

  }

  Future<void> updatescreen(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference.doc(doc_id).update({"screen":widget.id_card_screen});

  }
  _getusername() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      from = preferences.getString("username");
    });
    updatescreen(from);
  }
  _updateNewMessage(doc_id,role) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("jadwalkonseling");
    if(role=="admin"){

      collectionReference
          .doc(doc_id)
          .update({"nmkonseler":"0"});
    }else{

      collectionReference
          .doc(doc_id)
          .update({"nmkonsul":"0"});
      
    }

  }
  final scrollDirection = Axis.vertical;


  @override
  void initState() {
    // TODO: implement initState
    query = FirebaseFirestore.instance.collection("jadwalkonseling").doc(widget.doc_id).collection("historichat").orderBy('timestamp',descending: true);
    super.initState();
    _getusername();
    _getrole(widget.doc_id);

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        widget.refresh();
        Navigator.pop(context,true);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                widget.refresh();
                Navigator.pop(context,true);

                },
            ),
            title: Text(widget.conselor, style: TextStyle(color: Colors.white),),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child:
            Column(
              children: [
                Expanded(child: Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200]
                  ),
                  child:
                  StreamBuilder<QuerySnapshot>(
                    stream: query.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

//                      _scrollToIndex(snapshot.data.documents.length);
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return new ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context , index){
                            DocumentSnapshot document = snapshot.data.documents[index];
                            return document.data()["From"] == widget.sendfrom ?
                              MyMessage(ms: document.data()['message'],)
                                  :OtherMessage(ms: document.data()["message"],);

//                            if(index>10){
//                              return document.data()["From"] == widget.sendfrom ?
//                              MyMessage(ms: document.data()['message'],)
//                                  :OtherMessage(ms: document.data()["message"],);
//
//                            } else {
//                              return Container();
//                            }


                          }

                      );
                    },
                  ),
//                ListView.builder(
//                    padding: const EdgeInsets.symmetric(
//                        vertical: 10.0,
//                        horizontal:4.0
//                    ),
//                    controller: _controller,
//                    scrollDirection: Axis.vertical,
//                    itemCount: 100,
//                    itemBuilder: (BuildContext context, int index){
//                      if(index % 2== 0){
//                        return OtherMessage();
//                      }
//                      return MyMessage();
//                    }
//                ),
                )),
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child:  Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: TextFormField(
                                controller: message,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      top: 2.0,
                                      left: 13.0,
                                      right: 13.0,
                                      bottom: 2.0),
                                  hintText: "Type your message",
                                  hintStyle: TextStyle(
                                    color:Colors.grey,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 18.0
                                ),
                                onSaved: (String value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor: Colors.grey, // inkwell color
                            child: SizedBox(width: 50, height: 50, child: Icon(Icons.send_rounded,color: Colors.blue,)),
                            onTap: () {
                              var msg = message.text;
                              message.clear();
                              _sendmessage(widget.doc_id,msg);

                              // if(message.text.isNotEmpty){
                              //   crnewmssg
                              //       .doc(widget.id_sendto)
                              //       .get()
                              //       .then((DocumentSnapshot documentSnapshot) {
                              //     if (documentSnapshot.data()['screen']!=widget.doc_id){
                              //       sendAndRetrieveMessage(documentSnapshot.data()['tokenandroid']);
                              //       print("iya tidak sama");
                              //     }else{
                              //       message.clear();
                              //     }
                              //     print('ID EUYY '+ documentSnapshot.data()['tokenandroid']);
                              //     print('ID NYA NI '+ widget.doc_id);
                              //     print(documentSnapshot.data()['tokenandroid']);
                              //
                              //   });
                              // }


                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
            ,
          ),
        ),
      ),
    );
  }

  final String serverToken = 'AAAAxjSh-7I:APA91bGxt29WO98l0XNCozU-dxXYYQvuOijlVhS9ChFXqY9mAAPCpIG2Xi-7WN7aTrYvKlsPlHXymkNxV1fWMewnGEJdGG0yBQPwU9-qslPjM2sFZVCWXTLwf-vlHbtZ1GbUJsYdWLn6';

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token,String msg) async {

    // var msg = message.text;
    // message.clear();

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': msg,
            'title': 'BK-SMA',
            'badge': 2,
            'sound':"default"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );


    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      onResume: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    print("DONE");
    return completer.future;
  }
}

class ItemScrollController {
}
