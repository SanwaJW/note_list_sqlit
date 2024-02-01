import 'package:flutter/material.dart';
import 'package:note_list_sqlit/models/Note.dart';
import 'package:note_list_sqlit/screens/NoteDetails.dart';
import 'package:note_list_sqlit/utils/DatabaseHelper.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? nList;
  int? count;
  @override
  Widget build(BuildContext context) {
    // if (noteList == null) {
    //   noteList = List<Note>();
    // }
    if (nList == null) {
      nList;
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("hope"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigateToDetail(Note('', '', 2), "Create note");
          //  NoteDetails();
        },
        tooltip: "add note",
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (ctx, p) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(1), //noteList[p].priority
              child: getPriorityIcon(1), //noteList[p].priority
            ),
            title: Text("title"), //noteList![p].title
            subtitle: Text("subtitle"), //noteList![p].date
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
              ),
              onTap: () {
                _delete(context, nList![p]);
              },
            ),
            onTap: () {
              navigateToDetail(nList![p], "Edit note");
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int? priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int? priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
      case 2:
        return Icon(Icons.keyboard_arrow_right);

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int? result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  navigateToDetail(Note note, String appBarTitle) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail("", appBarTitle: appBarTitle, note: note); //
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    var initializeDatabase = databaseHelper.initializeDatabase();
    initializeDatabase.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          nList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
