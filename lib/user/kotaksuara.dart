import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class KotakSuara extends StatefulWidget {
  @override
  _KotakSuaraState createState() => _KotakSuaraState();
}

class _KotakSuaraState extends State<KotakSuara> {
  String _valGender;
  String _valFriends;
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List _myFriends = [
    "Mamik Laila",
  ];
  var user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getusername();
  }
  _getusername() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("username");
    });
  }
  String date = DateFormat('yMd').format(DateTime.now());
  var datefix;
  var split1;

  Future<void> _addkotakmasuk() async{
    await Firebase.initializeApp();
//    for (int i = 0; i < 9; i++){
//      print(date.toString()[i]);
//    }
    split1 = date.toString().split("/");
    print(split1);
    datefix = split1[0]+""+split1[1]+""+split1[2];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map<String,dynamic> data = {
      "From":user,
      "To": _valFriends,
      "subject":subject.text,
      "message":message.text,
      "tanggal":date,
      "tanggaldetail":DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()),
      "taggalsort":DateTime.now().millisecondsSinceEpoch,
      "read":"nonread"
    };

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('kotakmasuk');
    collectionReference
    .add(data);
    Navigator.of(context).pop();
  }

  void validate(){
    if(formkey.currentState.validate()){
      print("validasi");
      _addkotakmasuk();
      Fluttertoast.showToast(
          msg: "successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      print("no validasi");
    }
  }

  String validasiform(value){
    if(value.isEmpty){
      return "Required";
    }else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:
        AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text("Kotak Suara", style: TextStyle(color: Colors.grey[900]),),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.send_outlined,
                  color: Colors.grey[600],
                ),
                onPressed: validate),
          ],
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1.0,color: Colors.grey[300])
                        )
                    ),
                    child: Row(
                      children: [
                        Text("TO", style: TextStyle(fontSize: 18.0,color: Colors.grey),),
                        SizedBox(width: 35.0,),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none),
                            isExpanded: true,
                            hint: Text("Select Conselator"),
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
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1.0,color: Colors.grey[300])
                        )
                    ),
                    child: TextFormField(
                      controller: subject,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Topic',
                      ),
                      style: TextStyle(
                          fontSize: 18.0
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: validasiform,
                    ),
                  ),
                  Container(padding: EdgeInsets.symmetric(horizontal: 15.0),
                    width: double.infinity,
                    child: TextFormField(
                      controller: message,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                      ),
                      maxLines: 20,
                      style: TextStyle(
                          fontSize: 18.0
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: validasiform,
                    ),)
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}


