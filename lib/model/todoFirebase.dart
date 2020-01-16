import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFirebase {
  TodoFirebase({this.name,this.dateTime,this.location});

  //int id;
  String name;
  String dateTime;
  String location;
  DocumentReference reference;

  TodoFirebase.fromMap(Map<String, dynamic> map, {this.reference}) {
    //this.id = map['id'];
    this.name = map['name'];
    this.dateTime = map['dateTime'];
    this.location = map['location'];
  }

  Map<String,dynamic> toMap() {
    return {
      //'id': this.id,
      'name': this.name,
      'dateTime': this.dateTime,
      'location': this.location
    };
  }

  @override 
  String toString() {
    return 'Todo{name: $name, dateTime: $dateTime, location: $location}';
  }
}