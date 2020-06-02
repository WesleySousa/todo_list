import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();
  List _todoList = [];

  @override
  void initState() {
    super.initState();
    _readData().then((value) => setState(() => _todoList = json.decode(value)));
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> todo = Map();
      todo['title'] = _todoController.text;
      _todoController.text = '';
      todo['ok'] = false;
      _todoList.add(todo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'New Task',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    controller: _todoController,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'ADD',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_todoList[index]['title']),
                  value: _todoList[index]['ok'],
                  secondary: CircleAvatar(
                    child: Icon(
                        _todoList[index]['ok'] ? Icons.check : Icons.error),
                  ),
                  onChanged: (check) {
                    setState(() {
                      _todoList[index]['ok'] = check;
                      _saveData();
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return new File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (err) {
      return null;
    }
  }
}
