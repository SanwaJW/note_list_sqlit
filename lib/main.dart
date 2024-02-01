import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_list_sqlit/models/Note.dart';
import 'package:note_list_sqlit/screens/NoteList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var _date = DateFormat.yMMMd().format(DateTime.now());
    Note _note = Note("title", _date, 1);
    return MaterialApp(
      title: "Notes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NoteList(),
      //_note, "Test"
    );
  }
}
