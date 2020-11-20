import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_model.dart';

class AddPage extends StatelessWidget {
  final MainModel model;

  AddPage(this.model);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<MainModel>.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODOを追加'),
        ),
        body: Consumer<MainModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ゴミを出す',
                        labelText: 'TODOを入力',
                      ),
                      onChanged: (text) {
                        model.newTodoText = text;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  RaisedButton(
                    child: Text('追加する'),
                    onPressed: () async {
                      await model.add();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
