import 'package:flutter/material.dart';
import 'chat.dart';
import 'voice.dart';


class MyHomePageWelcome extends StatefulWidget {
  MyHomePageWelcome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageStateWelcome createState() => _MyHomePageStateWelcome();
}

class _MyHomePageStateWelcome extends State<MyHomePageWelcome> {
   bool isSelected;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
      (
        title: Text("Schedule list"),
        actions: <Widget>
        [
          
    
        ]

      ),
      body: 
      Container(
        child: 
        Text("Welcome"),

      ),
      floatingActionButton: FloatingActionButton(
          onPressed:(){
              _showmain(context);
            },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange,
        ),
    );
  }
}

Future <void> _showmain(BuildContext context) async {
    var event1 = await Navigator.pushNamed(context, '/schedules');
  }





