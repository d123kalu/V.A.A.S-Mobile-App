import 'package:flutter/material.dart';
import 'model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class modelFireBase {
  CollectionReference dbReplies = Firestore.instance.collection('replies');
  
  Future <int> insertFirestoreItem(Todo todo)async{
    CollectionReference events = Firestore.instance.collection('Calendar Events');
    var newDocument = await events.add(todo.toMap());
    print(newDocument);
  }

  Future <void> deleteFirestoreItem(int id) async{
    CollectionReference events = Firestore.instance.collection('Calendar Events');
    await events.document(id.toString()).delete();
    print("ID has been deleted");
  }
  
}