import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterstream_todo/main_model.dart';
import 'package:provider/provider.dart';

import 'add_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getTodoListRealTime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODO'),
          actions: [
            Consumer<MainModel>(
              builder: (context, model, child) {
                final isActive = model.checkedItemsActiveButton();
                return FlatButton(
                  onPressed: isActive
                      ? () {
                          model.deleteCheckedItems();
                        }
                      : null,
                  child: Text(
                    '完了',
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<MainModel>(
          builder: (context, model, child) {
            final todoList = model.todoList;
            return ListView(
              children: todoList
                  .map(
                    (todo) => CheckboxListTile(
                      title: Text(todo.title),
                      value: todo.isDone,
                      onChanged: (bool value) {
                        todo.isDone = !todo.isDone;
                        model.reload();
                      },
                    ),
                  )
                  .toList(),
            );
          },
        ),
        floatingActionButton:
            Consumer<MainModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(model),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Icon(Icons.add),
            tooltip: 'increment',
          );
        }),
      ),
    );
  }
}
