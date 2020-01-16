

import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

import 'notifications.dart';
import 'model/todo_model.dart';
import 'model/todo.dart';

import 'model/todoModelFirebase.dart';

import 'schedules.dart';

 final _model = TodoModel();
   final _firebaseModel = TodoModelFireBase();
   var _notifications = Notifications();

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";
  String pastetext = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  void entervoice(String m)
  {
    var arr = m.split(" ");

    var _eventName = arr[4];
    var _eventDate = arr[6] + " at " + arr[8] + arr[9];
    var _eventLocation = arr[10];

    insertfromvoice(_eventName,_eventDate,_eventLocation);
  }

  void insertfromvoice(var one, var two, var three) async {
    var _lastInsertedId = 1;

    Todo newTodotest = Todo(name: one, dateTime: two.toString(), location: three);
        _lastInsertedId = await _model.insertTodo(newTodotest);
        _firebaseModel.insertTodo(newTodotest);
          
        //Creating a notification of the newly added elements of the table
        _notifications.sendNotificationNow( 'V.A.A.S', 'The event "$one" at "$two" is on ($three)','payload');
        
        List<Todo> to = await _model.getAllTodos();

        setState(() => slist = to);
          
  }

   Future <void> _showhelp(BuildContext context) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Need Help?"),
          content: new Text("Click Microphone and SAY Set an event called #NAME# for #DATE# at #TIME# #LOCATION#"),
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
    _notifications.init();
    return Scaffold(
      //App BAr
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Talk to V.A.A.S"),
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    if (_isListening)
                      _speechRecognition.cancel().then(
                            (result) => setState(() {
                                  _isListening = result;
                                  resultText = "";
                                }),
                          );
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed: () {
                    if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: "en_US")
                          .then((result) => print('$result'));
                  },
                  backgroundColor: Colors.pink,
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    if (_isListening)
                      _speechRecognition.stop().then(
                            (result) => setState(() => _isListening = result),
                          );
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.content_paste),
                  backgroundColor: Colors.black12,
                  onPressed: () {
                   pastetext =  resultText;
                   entervoice(pastetext);
                  },
                ),

              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Container(
              child: Text(
                pastetext
              )
            )
          ],
        ),
      ),
    );
  }
}