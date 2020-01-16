import 'package:flutter/material.dart';
import 'notifications.dart';
import 'model/todo_model.dart';
import 'model/todo.dart';

import 'package:final_project_jarvis/Scheduling.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'voice.dart';
import 'welcome.dart';
import 'schedules.dart';
import 'map.dart';

//Author: Temi
class Scheduling {
  String name;
  String location;
  DateTime dateTime;

  Scheduling({this.name, this.location, this.dateTime});

  String toString() { return '$name $location ($dateTime)'; }
}

class SchedulingPage extends StatefulWidget {
  SchedulingPage({Key key, this.title}): super(key: key);

  final String title;

  @override 
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  var _notifications = Notifications(); 

  DateTime _eventDate = DateTime.now();
  String _eventName = '';
  String _eventLocation = '';

  var _todoItem1;
  var _todoItem2;

  @override 
  Widget build(BuildContext context) {
    _notifications.init(); 
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Name: ",
              ),
              onChanged: (String newValue) {
                setState(() {
                  _eventName = newValue;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Location: ",
                hintText: "2000 Simcoe Street North, Oshawa, ON"
              ),
              onChanged: (String newValue) {
                setState(() {
                  _eventLocation = newValue;
                  testaddress = newValue;
                });
              },
            ),
            RaisedButton(
              child: Text('lookup Location'), 
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  onPressed: () {
                    _maps(context);
                  }
            ),
             
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                  child: Text('Select Date'), 
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: now,
                      lastDate: DateTime(2100),
                      initialDate: now,
                    ).then((value) {
                      setState(() {
                        _eventDate = DateTime(
                          value.year,
                          value.month,
                          value.day,
                          _eventDate.hour,
                          _eventDate.minute,
                          _eventDate.second,
                        );
                      });
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(_toDateString(_eventDate)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                  child: Text('Select Time'),
                  color: Colors.deepOrangeAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay( 
                        hour: now.hour,
                        minute: now.minute,
                      ),
                    ).then((value) {
                      setState(() {
                        _eventDate = DateTime(
                          _eventDate.year,
                          _eventDate.month,
                          _eventDate.day,
                          value.hour,
                          value.minute,
                        );
                      });
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(_toTimeString(_eventDate)),
                ),
              ],
            ),
            Center(
              child: RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  Todo newTodotest = Todo(name: _eventName, dateTime: _eventDate.toString(), location: _eventLocation);
                Navigator.pop(context,newTodotest);
                _notificationNow();
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  String _twoDigits(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  String _toTimeString(DateTime dateTime) {
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
  }

  String _toDateString(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

   void _notificationNow() {
     _notifications.sendNotificationNow( 'V.A.A.S', 'The event "$_eventName" at "$_eventLocation" is on ($_eventDate)','payload');
   }  

   Future <void> _maps(BuildContext context) async {
  var event2 = await Navigator.pushNamed(context, '/map');
  }

}