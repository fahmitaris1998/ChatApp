import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/LIstChat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../animation/FadeAnimation.dart';
import '../Card/cardlistchat.dart';
import 'chat.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatConseling2(),
  ));
}

class ChatConseling2 extends StatefulWidget {
  final Function refresh;

  const ChatConseling2({Key key, this.refresh}) : super(key: key);

  @override
  _ChatConselingState createState() => _ChatConselingState();
}

class _ChatConselingState extends State<ChatConseling2> {
  TextEditingController problem = TextEditingController();
  String date = DateFormat('yMd').format(DateTime.now());
  var datefix;
  var split1;
  DateTime dateTime;
  String datejadwal = "Date";
  String _valFriends;
  String _valtime;
  String from ;

  List _myFriends = [
    "Mamik Laila",
  ];
  List _time = [
    "10:00",
    "13:00",
  ];

  final Query query = FirebaseFirestore.instance.collection('jadwalkonseling').orderBy('date',descending: true);

  Future<void> _createjadwal() async {
    split1 = date.toString().split("/");
    print(split1);
    datefix = split1[0]+""+split1[1]+""+split1[2];

    Map<String,dynamic> data = {
      "From": from,
      "To": _valFriends,
      "id_counseler": _valFriends == "Mamik Laila" ? "mamik09" : "none",
      "problem":problem.text,
      "date":datejadwal,
      "time":_valtime,
      "status":"waiting",
      "nmkonseler": "0",
      "nmkonsul":"0"
    };
    Navigator.of(context).pop();
    var doc_ref = await Firestore.instance.collection("jadwalkonseling").getDocuments();
    doc_ref.documents.forEach((result) {
      print(result.documentID);
    });

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('jadwalkonseling');
    collectionReference.add(data);
//    collectionReference
//    .doc(datefix.toString())
//    .get()
//    .then((DocumentSnapshot documentSnapshot) {
//
//      if(documentSnapshot.exists){
//        collectionReference.doc(datefix.toString()).collection("riwayatdaftarconseling").doc(username).set(data)
//            .then((value){
//
//        })
//            .catchError((error) => print("Failed to add user: $error"));
//      }else{
//        collectionReference.doc(datefix.toString()).set({
//          'Create Time': date.toString()
//        })
//            .then((value){
//          collectionReference.doc(datefix.toString()).collection("riwayatdaftarconseling").doc(username).set(data)
//              .then((value){
//
//          })
//              .catchError((error) => print("Failed to add user: $error"));
//        })
//            .catchError((error) => print("Failed to add user: $error"));
//      }
//
//    });

//read
//    collectionReference
//        .doc(datefix.toString())
//    .collection("riwayatdaftarconseling")
//    .get()
//    .then((QuerySnapshot querySnapshot){
//      querySnapshot.docs.forEach((doc) {
//        print(doc.get("From"));
//      });
//    });

  }
  Future<void> updatescreen(doc_id) async{
    await Firebase.initializeApp();
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
    collectionReference.doc(doc_id).update({"screen":"list jadwal konseling"});

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getusername();

  }
  _getusername() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      from = preferences.getString("username");
    });
    updatescreen(from);

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        widget.refresh();
        Navigator.pop(context,true);

      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
              DateTime date = DateTime.now();
              print(DateFormat('EEEE, d MMM, yyyy').format(date));

              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                          return Container(
                              padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0,top: 10.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 5.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.grey
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text("Create Schedule", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0 ),),
                                    SizedBox(height: 20.0,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                      width: double.infinity,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0,color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: TextFormField(
                                        controller: problem,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Your Problem',
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
                                    SizedBox(height: 5.0,),
                                    Container(
                                      padding: EdgeInsets.only(left: 5.0),
                                      width: double.infinity,
                                      child: Text("Ex : Family, Addiction, Trauma, Friends, Phobia, Stress, Personal and other", style: TextStyle(color: Colors.grey),),
                                    ),
                                    SizedBox(height: 20.0,),
                                    Container(
                                      width: double.infinity,
                                      height: 50.0,
                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0,color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        isExpanded: true,
                                        hint: Text("Select Conselator",style: TextStyle(color: Colors.black),),
                                        value: _valFriends,
                                        validator: (value) => value == null ? 'required' : null,
                                        items: _myFriends.map((value) {
                                          return DropdownMenuItem(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: Colors.brown.shade800,
                                                    child: Text('M'),
                                                  ),
                                                  SizedBox(width: 10.0,),
                                                  Expanded(child: Text(value))
                                                ],
                                              ),
                                            ),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _valFriends = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20.0,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                      width: double.infinity,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0,color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: Row(
                                        children: [
                                          Text(datejadwal,style: TextStyle(fontSize: 15.0),),
                                          Expanded(child: SizedBox()),
                                          GestureDetector(
                                            onTap: (){
                                              DateTime dt = DateTime.now();
                                              print(DateFormat('h:mm a').format(dt));

                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime(dt.year,dt.month,dt.day+1),
                                                firstDate: DateTime(dt.year,dt.month,dt.day+1),
                                                lastDate: DateTime(2021),
                                              ).then((date){
                                                setState(() {
                                                  datejadwal = DateFormat('EEEE, d MMM yyyy').format(date).toString();
                                                });
                                              }
                                              );
                                            },
                                            child: Icon(
                                              Icons.date_range_outlined,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.0,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                      width: double.infinity,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0,color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        isExpanded: true,
                                        hint: Text("Time",style: TextStyle(color: Colors.black),),
                                        value: _valtime,
                                        validator: (value) => value == null ? 'required' : null,
                                        items: _time.map((value) {
                                          return DropdownMenuItem(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Expanded(child: Text(value))
                                                ],
                                              ),
                                            ),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _valtime = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20.0,),
                                    GestureDetector(
                                      onTap:(){
                                        if(problem.text.isNotEmpty && _valFriends != null && _valtime!=null && datejadwal!="Date"){
                                          _createjadwal();
                                          Fluttertoast.showToast(
                                              msg: "successful Create",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }else{
                                          Fluttertoast.showToast(
                                              msg: "Failed Create",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }

                                      },
                                      child: FadeAnimation(1.0, Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.blue
                                        ),
                                        child: Center(
                                          child: Text("CREATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ),
                                      )),
                                    ),
                                    SizedBox(height: 20.0,),

                                  ],
                                ),
                              )
                          );
                        });
                  });
            },
            label: Text('New Schedule',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
            icon: Icon(Icons.message_outlined,color: Colors.blue,),
            backgroundColor: Colors.white,
          ),

          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                widget.refresh();
                Navigator.pop(context,true);

              },
            ),
            elevation: 0,
            title: Text('Chat Counseling'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: Container(
                margin: EdgeInsets.only(top: 0,bottom: 10.0,right: 20.0,left: 20.0),
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(25.0)
                ),
                child: TabBar(
                  indicator: BubbleTabIndicator(
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      indicatorHeight: 40.0,
                      indicatorColor: Colors.white
                  ),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Text("UpComing"),
                    Text("Expired")
                  ],
                  onTap: (index){
                  },
                ),
              ),
            ),
          ),

          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                color: Colors.blue,
              child: StreamBuilder<QuerySnapshot>(
                stream: query.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return new ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document) {
                      return document.data()['status'] == "open"?
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => Chat(conselor: document.data()["To"],doc_id: document.documentID,sendfrom: from, refresh: _getusername,id_sendto: document.data()["id_counseler"], id_card_screen: document.documentID,)
                                ),);
                              },
                              child: CardListChat(status: document.data()["status"],nama: document.data()['To'] ,tanggal: document.data()['date'], newmessage: document.data()["nmkonsul"],))
                              : CardListChat(status: document.data()["status"],nama: document.data()['To'] ,tanggal: document.data()['date'],);

                    }).toList(),
                  );
//
                },
              ),
              ),
              Container(color: Colors.blue,

              ),

            ],
          ),
        ),
      ),
    );
  }
}

