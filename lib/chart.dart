import 'package:flutter/material.dart';
import 'notifications.dart';
import 'model/todo_model.dart';
import 'model/todo.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';

import 'package:final_project_jarvis/Scheduling.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'voice.dart';
import 'welcome.dart';
import 'schedules.dart';


//Author: Dikachi

//Class for Calculating the frequency of Events
class EventFrequency {
  String location;
  int frequency;

  EventFrequency({this.location, this.frequency});

  String toString() {
    return 'GradeFrequency($location, $frequency)';
  }
}

class ChartPage extends StatefulWidget {
  ChartPage({Key key, this.title}): super(key: key);

  final String title;

  @override 
  _ChartPageState createState() => _ChartPageState();
}

List<String> locations = [];

var map = Map();

var keys = [];


class _ChartPageState extends State<ChartPage> {

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>
        [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () 
            { 
              getinfo();
            },
          ),
          IconButton(
            icon: Icon(Icons.table_chart),
            onPressed: () 
            { 
              table(context);
            },
          ),
        ]
      ),
      body:Container(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 500.0,
          child: charts.BarChart(
            [
              charts.Series<EventFrequency, String>(
                id: 'Grade Frequency',
                colorFn: (a,b) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (EventFrequency freq, unused) => freq.location,
                measureFn: (EventFrequency freq, unused) => freq.frequency,
                data: _calculateGradeFrequencies2(),
              ),
            ], 
            animate: true,
            vertical: false,
          ),
        ),
      ),
    );
  }

  //Function to open the table Page
   Future <void> table(BuildContext context) async {
    var event1 = await Navigator.pushNamed(context, '/table');
  }

  
  Future<void> getinfo() async { 
    print("Getting location");
    for (Todo location in slist) {
      locations.add(location.location);
    }
  }

  //Gets the top five frequencies
  Future<void> getTopFive() async {

  locations.forEach((element) {
    if(!map.containsKey(element)) {
      map[element] = 1;
    } else {
      map[element] +=1;
    }
  });

    keys = map.keys.toList();
    print(keys);
  }

   List<EventFrequency> _calculateGradeFrequencies2() {
    getinfo();
    getTopFive();

    return keys.map((location) => EventFrequency(
      location: location,
      frequency: map[location]
    )).toList();
  }
}



