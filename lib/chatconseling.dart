import 'package:crud_firebase/LIstChat.dart';
import 'package:flutter/material.dart';

import 'Card/cardlistchat.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatConseling(),
    )
);

class ChatConseling extends StatefulWidget {
  @override
  _ChatConselingState createState() => _ChatConselingState();
}

class _ChatConselingState extends State<ChatConseling> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Chat Conseling'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('New Message'),
        icon: Icon(Icons.message_outlined),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal:4.0
            ),
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (BuildContext context, int index){
              return CardListChat(status: "open",);
            }
        ),
      ),
    );
  }
}
