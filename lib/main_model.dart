import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'todo.dart';

class MainModel extends ChangeNotifier {
  String newTodoText = '';
  List<Todo> todoList = [];

  void getTodoListRealTime() {
    final snapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots();
    snapshots.listen(
      (snapshot) {
        final docs = snapshot.docs;
        final todoList = docs.map((doc) => Todo(doc)).toList();
        todoList.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );
        this.todoList = todoList;
        notifyListeners();
      },
    );
  }

  Future add() async {
    final todoCollection = FirebaseFirestore.instance.collection('todoList');
    await todoCollection.add(
      {
        'title': newTodoText,
        'createdAt': Timestamp.now(),
      },
    );
  }

  void reload() {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    final references =
        checkedItems.map((todo) => todo.documentReference).toList();

    final batch = FirebaseFirestore.instance.batch();
    references.forEach(
      (reference) {
        batch.delete(reference);
      },
    );
    return batch.commit();
  }

  bool checkedItemsActiveButton() {
    final checkedItems = todoList.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}
