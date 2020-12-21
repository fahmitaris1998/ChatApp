// Copyright 2019 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/Card/mymessage.dart';
import 'package:crud_firebase/Card/othermessage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

const numberOfItems = 5001;
const minItemHeight = 20.0;
const maxItemHeight = 150.0;
const scrollDuration = Duration(seconds: 2);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScrollablePositionedListPage(),
  ));
}
class ScrollablePositionedListPage extends StatefulWidget {
  final String conselor;
  final String doc_id;
  final String sendfrom;
  final Function refresh;
  final String id_sendto;

  const ScrollablePositionedListPage({Key key, this.conselor, this.doc_id, this.sendfrom, this.refresh, this.id_sendto}) : super(key: key);


  @override
  _ScrollablePositionedListPageState createState() =>
      _ScrollablePositionedListPageState();
}

class _ScrollablePositionedListPageState
    extends State<ScrollablePositionedListPage> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();



  /// Listener that reports the position of items when the list is scrolled.
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  List<double> itemHeights;
  List<Color> itemColors;
  bool reversed = false;

  TextEditingController message = TextEditingController();
  ScrollController _controller = ScrollController();

  String id;
  String from;
  var role;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('jadwalkonseling');
  CollectionReference crnewmssg = FirebaseFirestore.instance.collection('user');
  Query query;


  /// The alignment to be used next time the user scrolls or jumps to an item.
  double alignment = 0;


  _getrole(doc_id)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      role = preferences.getString('role');
    });
    _updateNewMessage(doc_id,role);

  }
  Future<void> _sendmessage(doc_id){

    if(message.text.isNotEmpty){
      Map<String,dynamic> data = {
        "From": widget.sendfrom,
        "timestamp":DateTime.now().millisecondsSinceEpoch,
        "date":DateFormat('EEEE, d MMM, yyyy').format(DateTime.now()),
        "timesend":DateFormat('HH:mm a').format(DateTime.now()),
        "message":message.text
      };
      print(data);

      collectionReference
          .doc(doc_id)
          .collection("historichat")
          .add(data)
          .then((value) {

        crnewmssg
            .doc(widget.id_sendto)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if(documentSnapshot.data()['screen']!="chat"){

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
    collectionReference.doc(doc_id).update({"screen":"chat"});

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
  @override
  void initState() {
    super.initState();
    final heightGenerator = Random(328902348);
    final colorGenerator = Random(42490823);
    itemHeights = List<double>.generate(
        numberOfItems,
            (int _) =>
        heightGenerator.nextDouble() * (maxItemHeight - minItemHeight) +
            minItemHeight);
    itemColors = List<Color>.generate(
        numberOfItems,
            (int _) =>
            Color(colorGenerator.nextInt(pow(2, 32) - 1)).withOpacity(1));

    query = FirebaseFirestore.instance.collection("jadwalkonseling").doc(widget.doc_id).collection("historichat").orderBy('timestamp',descending: false);
    super.initState();
    _getusername();
    _getrole(widget.doc_id);


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
                      Timer(
                        Duration(milliseconds: 1),
                            () => _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.fastOutSlowIn),
                      );

                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      return new ScrollablePositionedList.builder(

                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context , index){
                            DocumentSnapshot document = snapshot.data.documents[index];
                            return document.data()["From"] == widget.sendfrom ?
                            MyMessage(ms: document.data()['message'],)
                                :OtherMessage(ms: document.data()["message"],);
                          }

                      );
//
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
                              _sendmessage(widget.doc_id);
                              message.clear();
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

  Widget get alignmentControl => Row(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      const Text('Alignment: '),
      SizedBox(
        width: 200,
        child: Slider(
          value: alignment,
          onChanged: (double value) => setState(() => alignment = value),
        ),
      ),
    ],
  );

  Widget list(Orientation orientation) => ScrollablePositionedList.builder(
    itemCount: numberOfItems,
    itemBuilder: (context, index) => item(index, orientation),
    itemScrollController: itemScrollController,
    itemPositionsListener: itemPositionsListener,
    reverse: reversed,
    scrollDirection: orientation == Orientation.portrait
        ? Axis.vertical
        : Axis.horizontal,
  );

  Widget get positionsView => ValueListenableBuilder<Iterable<ItemPosition>>(
    valueListenable: itemPositionsListener.itemPositions,
    builder: (context, positions, child) {
      int min;
      int max;
      if (positions.isNotEmpty) {
        // Determine the first visible item by finding the item with the
        // smallest trailing edge that is greater than 0.  i.e. the first
        // item whose trailing edge in visible in the viewport.
        min = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) =>
        position.itemTrailingEdge < min.itemTrailingEdge
            ? position
            : min)
            .index;
        // Determine the last visible item by finding the item with the
        // greatest leading edge that is less than 1.  i.e. the last
        // item whose leading edge in visible in the viewport.
        max = positions
            .where((ItemPosition position) => position.itemLeadingEdge < 1)
            .reduce((ItemPosition max, ItemPosition position) =>
        position.itemLeadingEdge > max.itemLeadingEdge
            ? position
            : max)
            .index;
      }
      return Row(
        children: <Widget>[
          Expanded(child: Text('First Item: ${min ?? ''}')),
          Expanded(child: Text('Last Item: ${max ?? ''}')),
          const Text('Reversed: '),
          Checkbox(
              value: reversed,
              onChanged: (bool value) => setState(() {
                reversed = value;
              }))
        ],
      );
    },
  );

  Widget get scrollControlButtons => Row(
    children: <Widget>[
      const Text('scroll to'),
      scrollButton(0),
      scrollButton(5),
      scrollButton(10),
      scrollButton(100),
      scrollButton(1000),
      scrollButton(5000),
    ],
  );

  Widget get jumpControlButtons => Row(
    children: <Widget>[
      const Text('jump to'),
      jumpButton(0),
      jumpButton(5),
      jumpButton(10),
      jumpButton(100),
      jumpButton(1000),
      jumpButton(5000),
    ],
  );

  Widget scrollButton(int value) => GestureDetector(
    key: ValueKey<String>('Scroll$value'),
    onTap: () => scrollTo(value),
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('$value')),
  );

  Widget jumpButton(int value) => GestureDetector(
    key: ValueKey<String>('Jump$value'),
    onTap: () => jumpTo(value),
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('$value')),
  );

  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index,
      duration: scrollDuration,
      curve: Curves.easeInOutCubic,
      alignment: alignment);

  void jumpTo(int index) =>
      itemScrollController.jumpTo(index: index, alignment: alignment);

  /// Generate item number [i].
  Widget item(int i, Orientation orientation) {
    return SizedBox(
      height: orientation == Orientation.portrait ? itemHeights[i] : null,
      width: orientation == Orientation.landscape ? itemHeights[i] : null,
      child: Container(
        color: itemColors[i],
        child: Center(
          child: Text('Item $i'),
        ),
      ),
    );
  }
}
