import 'dart:async';

//import 'package:sqflite/sqflite.dart';

//import 'db_utils.dart';
import 'todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModelFireBase {
  Future<int> insertTodo(Todo todo) async {
    CollectionReference products = Firestore.instance.collection('Calendar Events');
    var newDocument = await products.add(todo.toMap());
    print(newDocument);
    /*
    final db = await DBUtils.init();
    return await db.insert(
      'todo_items',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    */
  }

  Future<int> updateTodo(Todo todo, String dI) async {
    var updateID = Firestore.instance.collection('grades').document(dI).updateData(todo.toMap());
    print(updateID);
    /*
    final db = await DBUtils.init();
    return await db.update(
      'todo_items',
      todo.toMap(), // data to replace with
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    */
  }

  Future<int> deleteTodo(String id) async {
    var deleteID = Firestore.instance.collection('grades').document(id).delete();
    print(deleteID);
    /*
    final db = await DBUtils.init();
    return await db.delete(
      'todo_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    */
  }
  /*
  Future<List<Todo>> getAllTodos() async {
    final db = await DBUtils.init();
    List<Map<String,dynamic>> maps = await db.query('todo_items');
    List<Todo> todos = [];
    for (int i = 0; i < maps.length; i++) {
      todos.add(Todo.fromMap(maps[i]));
    return todos;
  }
  }

  Future<Todo> getTodoWithId(int id) async {
    final db = await DBUtils.init();
    List<Map<String,dynamic>> maps = await db.query(
      'todo_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Todo.fromMap(maps[0]);
    } else {
      return null;
    }
  }
  */
}