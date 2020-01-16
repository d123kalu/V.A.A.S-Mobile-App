import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'main.dart';
import 'notifications.dart';
import 'model/todo_model.dart';
import 'model/todo.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_firebase.dart';
import 'model/todoModelFirebase.dart';
import 'model/todoFirebase.dart';
import 'map.dart';

import 'schedules.dart';

//Author: Ajevan

//Chatbot System
   final _model = TodoModel();
   final _firebaseModel = TodoModelFireBase();
   var _notifications = Notifications();
   

class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageDialogflow createState() => new _HomePageDialogflow();
}


class _HomePageDialogflow extends State<HomePageDialogflow> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

//Function to build the set message textfield below the chat window
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

//Function handles the response based on the user input
  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/JARVIS-83743aeeb4f1.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage message = new ChatMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      name: "V.A.A.S",
      type: false,
    );
    setState((){
      _messages.insert(0, message);
      print(response.getMessage());
      
      var m = response.getMessage();
      var arr = m.split(" "); 

      //Parsing through the response to get the variables to add to the databases
      if (arr.length > 8){
        if (arr[0] == "Done!"){
          print("Hello");
          var start = "Event ";
          var end = " set";
          var startIndex = m.indexOf(start);
          var endIndex = m.indexOf(end, startIndex + start.length);

          var start2 = "set for";
          var end2 = " at";
          var startIndex2 = m.indexOf(start2);
          var endIndex2 = m.indexOf(end2, startIndex2 + start2.length);

          var start3 = "at ";
          var end3 = " ...";
          var startIndex3 = m.indexOf(start3);
          var endIndex3 = m.indexOf(end3, startIndex3 + start3.length);


          var _eventName = m.substring(startIndex + start.length, endIndex);
          var _eventDate = m.substring(startIndex2 + start2.length, endIndex2);
          var _eventLocation = m.substring(startIndex3 + start3.length, endIndex3);

          insert(_eventName,_eventDate,_eventLocation);

        }
      }
    });
  }

//Function helps to insert into the local and online database then creates a notification as the message is popped up
  void insert(var one, var two, var three) async {
    var _lastInsertedId = 1;

    Todo newTodotest = Todo(name: one, dateTime: two.toString(), location: three);
        _lastInsertedId = await _model.insertTodo(newTodotest);
        _firebaseModel.insertTodo(newTodotest);
          
        //Creating a notification of the newly added elements of the table
        _notifications.sendNotificationNow( 'V.A.A.S', 'The event "$one" at "$two" is on ($three)','payload');
        
        List<Todo> to = await _model.getAllTodos();

        print(to);

        setState(() => slist = to);
          
  }

//Function handles the printing of the user message to the chatbot system
  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }

  Future <void> _showhelp(BuildContext context) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Need Help?"),
          content: new Text("Set an event called #NAME# for #DATE# at #TIME# #LOCATION#"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Chat with V.A.A.S"),
        actions: <Widget>
        [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () 
            { 
              _showhelp(context);
            },
          ),
        ]
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

//Chat message class
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;


//These functions set the styles for the bot and user message 
  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text('V')),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            child: new Text(
          this.name[0],
          style: new TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _notifications.init();
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}