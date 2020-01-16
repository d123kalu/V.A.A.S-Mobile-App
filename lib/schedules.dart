import 'package:final_project_jarvis/main.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'voice.dart';
import 'welcome.dart';

import 'model/todo_model.dart';
import 'model/todo.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_firebase.dart';
import 'model/todoModelFirebase.dart';
import 'model/todoFirebase.dart';
import 'map.dart';


//Author: Dikachi and Temi

Todo t;

CollectionReference dbReplies = Firestore.instance.collection('replies');



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.darkThemeEnabled}) : super(key: key);

  final String title;
  final bool darkThemeEnabled;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SnackBar {

  String title;
  IconData icon;

  SnackBar({this.title, this.icon});
}

  List<Todo> slist = [
   
  ];

   List indexids = [];
  

  int listilelengthcheck = 1;

    final _model = TodoModel();
    final _firebaseModel = TodoModelFireBase();
    bool isSelected;

    bool isEmpty = true;

     bool toedit = false;

     int _selectedIndex = 0;
   

  var _todoItem1;
  var _todoItem2;
  var _todoItem3;

class _MyHomePageState extends State<MyHomePage> {

List<SnackBar> _pages = [
    SnackBar(title: 'Add', icon: Icons.add),
    SnackBar(title: 'Chat', icon: Icons.chat),
  ];

  int _pageIndex = 0;

  var _lastInsertedId = 1;

  @override
  
  void initState()
  {
    super.initState();
    
    _updateTodo();
   
  }
  
  Widget build(BuildContext context) {
    _updateTodo();
    return Scaffold(
      appBar: AppBar
      (
        title: Text("Schedule list"),
        actions: <Widget>
        [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () 
            { 
              _updateTodo();
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () 
            { 
              _edit();
                toedit = true;
            }
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () 
            { 
              _deleteTodo();
            }
          ),
         
    
        ]

      ),
      body: 
      Container(
        
       child: new ListView.builder
        (
          itemCount: slist.length != null ?  slist.length: 0 ,
          itemBuilder: (BuildContext ctxt, int index) 
          {         
            return new Card
            ( 
              child: Container(
                child: GestureDetector(
                  child: tilebuild(slist[index], index),
                  onTap: () => setState((){ _selectedIndex = index; isSelected = true;})
                )
              )
            );
          }
        ),
        

      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("DarK Mode"),
              trailing: Switch(
                value: widget.darkThemeEnabled,
                onChanged: bloc.changeTheme,
              ),
            ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () 
            { 
              _showchart(context);
            },
          ),

          IconButton(
            icon: Icon(Icons.g_translate),
            onPressed: ()
            {
              _translate(context);
            },  
          ),


          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
       items: _pages.map((SnackBar page) {
         return BottomNavigationBarItem(
           icon: Icon(page.icon),
           title: Text(page.title),
         );
       }).toList(),
       onTap: (int index) {
         setState(() {
           if(index == 0)
           {
              _showDialog(context);
              
           }
           if(index == 1)
           {
              _showchat(context);
           }
         });
       },     
     ),
    );
  }

   Widget tilebuild(Todo passedindex,int index)
  {
    bool isSelected = _selectedIndex == index;
    return Container(
      decoration: BoxDecoration(color: isSelected ? Colors.orange[500] :Colors.orange[200]),
      child: ListTile(
          title: Text(passedindex.name + "    " + passedindex.dateTime),
          subtitle: Text(passedindex.location),
        )
      );
  }

Future <void> _showchart(BuildContext context) async {
    var event1 = await Navigator.pushNamed(context, '/chart');
  }

Future <void> _showchat(BuildContext context) async {
    var event1 = await Navigator.pushNamed(context, '/chat');
  }

Future <void> _showvoice(BuildContext context) async {
    var event = await Navigator.pushNamed(context, '/voice');
  }




Future <void> _translate(BuildContext context) async {
  var event2 = await Navigator.pushNamed(context, '/translate');
}


 Future<void> _edit() async {
       _showmanual(context);
    }

   Future<void> _editTodo() async {
    Todo todoToUpdate = Todo(
      id: indexids[_selectedIndex],
      name: t.name,
      dateTime: t.dateTime,
      location: t.location
    );
    _model.updateTodo(todoToUpdate);

 
    toedit = false;
    _updateTodo();
  }

Future<void> _addTodo() async {
    Todo newTodo = Todo(name: t.name, dateTime: t.dateTime, location: t.location);

    _lastInsertedId = await _model.insertTodo(newTodo);
    _firebaseModel.insertTodo(newTodo);
    isEmpty = false;
    
    _updateTodo();
  
}

   Future<void> _updateTodo() async {
    List<Todo> to = await _model.getAllTodos();

    List templist = [];
    for (int i = 0; i < to.length;i++)
    {
      templist.add(to[i].id);
    }

    setState(() => slist = to);

    setState(() => indexids = templist);
    
  }

  Future<void> _deleteTodo() async {
    _model.deleteTodo(indexids[_selectedIndex]);
    slist.removeAt(_selectedIndex);
    isEmpty = true; 
    _updateTodo();
    
  }

  Future<void> _listTodos() async {
    List<Todo> todos = await _model.getAllTodos();
    print('To Dos:');
    for (Todo todo in todos) {
      print(todo);
    }
  }

Future <void> _showmanual(BuildContext context) async {
    var event = await Navigator.pushNamed(context, '/manual');
     t = event;

    if(t.name != null && t.dateTime != null && t.location != null)
    {
        if(toedit)
      {
        _editTodo();
      }
      else{
         _addTodo();
      }
    }

  }

//Function for the dialog box 
  Future <void> _showDialog(BuildContext context) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add Options"),
         
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
             new FlatButton(
              child: new Text("Manual"),
              onPressed: () {
                _showmanual(context);
              },
            ),
            new FlatButton(
              child: new Text("Chat"),
              onPressed: () {
                _showchat(context);
              },
            ),
            new FlatButton(
              child: new Text("Voice"),
              onPressed: () {
                _showvoice(context);
              },
            ),
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

  CollectionReference dbReplies = Firestore.instance.collection('replies');
  
  Future <int> insertFirestoreItem(Todo todo)async{
    CollectionReference events = Firestore.instance.collection('Calendar Events');
    var newDocument = await events.add(todo.toMap());
    
  }

  Future <void> deleteFirestoreItem(int id) async{
    CollectionReference events = Firestore.instance.collection('Calendar Events');
    await events.document(id.toString()).delete();
    print("ID has been deleted");
  }
}

