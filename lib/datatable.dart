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

class TablePage extends StatefulWidget {
  TablePage({Key key, this.title}): super(key: key);

  final String title;

  @override 
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {

  List<Todo> TableList;

  @override
  void initState(){
    TableList = slist;
    super.initState();
  }

  DataTable dataBody()
  {
    return DataTable(
      columns: [
        DataColumn(
          label: Text("Name"),
          numeric: false,
          tooltip: "This is the name of the event",
        ),
        DataColumn(
          label: Text("Location"),
          numeric: false,
          tooltip: "This is the location of the event",
        ),
        DataColumn(
          label: Text("Time & Date"),
          numeric: false,
          tooltip: "This is the Time and Date of the event",
        )
      ],
      rows: TableList.map(
        (user) => DataRow(
          cells: [
            DataCell(Text(user.name),),
            DataCell(Text(user.location),),
            DataCell(Text(user.dateTime),),
          ]
        ),
    ).toList(),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(
            child: dataBody(),
            )
        ],
      )
    );
  }

 
}
