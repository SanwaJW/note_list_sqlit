import 'package:flutter/material.dart';
import 'package:note_list_sqlit/models/Note.dart';
import 'package:note_list_sqlit/utils/DatabaseHelper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(String s,
      {super.key, required this.appBarTitle, required this.note});

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(appBarTitle: appBarTitle, note: this.note);
  }
}

class NoteDetailState extends State<NoteDetail> {
  final String appBarTitle;
  final Note note;
  NoteDetailState({required this.appBarTitle, required this.note});

  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = Theme.of(context).textTheme.title;

    // String? title = note.title;
    // String? description = note.description;
    // if (title == null) {
    //   titleController.text = "sj";
    // } else {
    //   titleController.text = title;
    // }
    // if (description == null) {
    //   descriptionController.text = "test description";
    // } else {
    //   descriptionController.text = note.description;
    // }
    titleController.text = "sj";
    descriptionController.text = "test description";

    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // First element
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),

                  // style: textStyle,

                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      if (valueSelectedByUser != null) {
                        updatePriorityAsInt(valueSelectedByUser);
                      }
                    });
                  }),
            ),

            // Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                // style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    // labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Third Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                // style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    // labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Fourth Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      // color: Theme.of(context).primaryColorDark,
                      // textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        // textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Save button clicked");
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      // color: Theme.of(context).primaryColorDark,
                      // textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        // textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete button clicked");
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority = _priorities[0];
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}


























// class NoteDetails extends StatefulWidget {
//   //  const NoteDetails({super.key});
//   final String appBarTitle;
//   final Note note;
//   const NoteDetails(this.note, this.appBarTitle);
//   @override
//   State<StatefulWidget> createState() {
//     return _MyWidgetState(this.note, this.appBarTitle);
//   }
// }

// class _MyWidgetState extends State<NoteDetails> {
//   DatabaseHelper databaseHelper = DatabaseHelper();
//   final String appBarTitle;
//   final Note note;

//   static final _priorities = ["Hight", "Low"];
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   _MyWidgetState(this.note, this.appBarTitle);

//   @override
//   Widget build(BuildContext context) {
//     titleController.text = note.title;
//     descriptionController.text = note.description!;
//     return Scaffold(
//       appBar: AppBar(title: Text("test")), //appBarTitle
//       body: Padding(
//           padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
//           child: ListView(
//             children: [
//               // first element
//               ListTile(
//                 title: DropdownButton(
//                   items: _priorities.map((String dropDownStringItem) {
//                     return DropdownMenuItem<String>(
//                       value: dropDownStringItem,
//                       child: Text(dropDownStringItem),
//                     );
//                   }).toList(),
//                   value: getPriorityAsString(1), //note.priority
//                   onChanged: (valueSelectedByUse) {
//                     setState(() {
//                       debugPrint('User selected $valueSelectedByUse');
//                       if (valueSelectedByUse != null) {
//                         updatePriorityAsInt(valueSelectedByUse);
//                       }
//                     });
//                   },
//                 ),
//               ),

//               //Second element
//               Padding(
//                 padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                 child: TextField(
//                   controller: titleController,
//                   onChanged: (value) {
//                     debugPrint("in titleController tile text field");
//                     updateTitle();
//                   },
//                   decoration: InputDecoration(
//                       labelText: 'title',
//                       // labelStyle: TextStyle,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0))),
//                 ),
//               ),

//               //third element
//               Padding(
//                 padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                 child: TextField(
//                   controller: descriptionController,
//                   onChanged: (value) {
//                     debugPrint("in descriptionController tile text field");
//                     updateDescription();
//                   },
//                   decoration: InputDecoration(
//                       labelText: 'descriptionController',
//                       // labelStyle: TextStyle,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0))),
//                 ),
//               ),

//               Padding(
//                   padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               debugPrint("in titleController tile text field");
//                               // _save();
//                             });
//                           },
//                           // color: Theme.of(context).primaryColorDark,
//                           // textColor: Theme.of(context).primaryColorLight,
//                           child: const Text(
//                             'Save',
//                             // textScaleFactor: 1.5,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 5.0,
//                       ),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               debugPrint("Delete button clicked");
//                               _delete();
//                             });
//                           },
//                           // color: Theme.of(context).primaryColorDark,
//                           // textColor: Theme.of(context).primaryColorLight,
//                           child: const Text(
//                             'Delete',
//                             // textScaleFactor: 1.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//             ],
//           )),
//     );
//   }

//   // Convert the String priority in the form of integer before saving it to Database
//   void updatePriorityAsInt(String value) {
//     switch (value) {
//       case 'High':
//         note.priority = 1;
//         break;
//       case 'Low':
//         note.priority = 2;
//         break;
//     }
//   }

//   // Convert int priority to String priority and display it to user in DropDown
//   String getPriorityAsString(int value) {
//     String priority = '';
//     switch (value) {
//       case 1:
//         priority = _priorities[0]; // 'High'
//         break;
//       case 2:
//         priority = _priorities[1]; // 'Low'
//         break;
//     }
//     return priority;
//   }

//   void updateTitle() {
//     note.title = titleController.text;
//   }

//   // Update the description of Note object
//   void updateDescription() {
//     note.description = descriptionController.text;
//   }

//   void _save() async {
//     moveToLastScreen();

//     note.date = DateFormat.yMMMd().format(DateTime.now());
//     int result;
//     if (note.id != null) {
//       // Case 1: Update operation
//       result = await databaseHelper.updateNote(note);
//     } else {
//       // Case 2: Insert Operation
//       result = await databaseHelper.insertNote(note);
//     }

//     if (result != 0) {
//       // Success
//       _showAlertDialog('Status', 'Note Saved Successfully');
//     } else {
//       // Failure
//       _showAlertDialog('Status', 'Problem Saving Note');
//     }
//   }

//   void _showAlertDialog(String title, String message) {
//     AlertDialog alertDialog = AlertDialog(
//       title: Text(title),
//       content: Text(message),
//     );
//     showDialog(context: context, builder: (_) => alertDialog);
//   }

//   void moveToLastScreen() {
//     Navigator.pop(context, true);
//   }

//   void _delete() async {
//     moveToLastScreen();

//     // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
//     // the detail page by pressing the FAB of NoteList page.
//     if (note.id == null) {
//       _showAlertDialog('Status', 'No Note was deleted');
//       return;
//     }

//     // Case 2: User is trying to delete the old note that already has a valid ID.
//     int result = await databaseHelper.deleteNote(note.id);
//     if (result != 0) {
//       _showAlertDialog('Status', 'Note Deleted Successfully');
//     } else {
//       _showAlertDialog('Status', 'Error Occured while Deleting Note');
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:note_list_sqlit/models/Note.dart';
// import 'package:note_list_sqlit/utils/DatabaseHelper.dart';

// class NoteDetails extends StatefulWidget {
//   final String appBarTitle;
//   final Note note;

//   const NoteDetails(this.note, this.appBarTitle);

//   @override
//   _NoteDetailsState createState() =>
//       _NoteDetailsState(this.note, this.appBarTitle);
// }

// class _NoteDetailsState extends State<NoteDetails> {
//   DatabaseHelper databaseHelper = DatabaseHelper();
//   final String appBarTitle;
//   final Note note;

//   static final _priorities = ["High", "Low"];
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   _NoteDetailsState(this.note, this.appBarTitle);

//   @override
//   void initState() {
//     super.initState();
//     titleController.text = note.title;
//     descriptionController.text = note.description!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(appBarTitle)),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: ListView(
//           children: [
//             ListTile(
//               title: DropdownButton(
//                 items: _priorities.map((String dropDownStringItem) {
//                   return DropdownMenuItem<String>(
//                     value: dropDownStringItem,
//                     child: Text(dropDownStringItem),
//                   );
//                 }).toList(),
//                 value: getPriorityAsString(note.priority!),
//                 onChanged: (valueSelectedByUser) {
//                   setState(() {
//                     updatePriorityAsInt(valueSelectedByUser!);
//                   });
//                 },
//               ),
//             ),
//             buildTextField(titleController, 'Title', updateTitle),
//             buildTextField(
//                 descriptionController, 'Description', updateDescription),
//             buildButtonBar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//       TextEditingController controller, String labelText, Function onChanged) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//       child: TextField(
//         controller: controller,
//         onChanged: (value) {
//           debugPrint("Text field changed");
//           onChanged();
//         },
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
//         ),
//       ),
//     );
//   }

//   Widget buildButtonBar() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _save();
//                 });
//               },
//               child: const Text('Save'),
//             ),
//           ),
//           const SizedBox(width: 5.0),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _delete();
//                 });
//               },
//               child: const Text('Delete'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void updatePriorityAsInt(String value) {
//     switch (value) {
//       case 'High':
//         note.priority = 1;
//         break;
//       case 'Low':
//         note.priority = 2;
//         break;
//     }
//   }

//   String getPriorityAsString(int value) {
//     return _priorities[
//         value - 1]; // Assumes priorities are 1 for High and 2 for Low
//   }

//   void updateTitle() {
//     note.title = titleController.text;
//   }

//   void updateDescription() {
//     note.description = descriptionController.text;
//   }

//   void _save() async {
//     note.date = DateFormat.yMMMd().format(DateTime.now());
//     int result;
//     if (note.id != null) {
//       result = await databaseHelper.updateNote(note);
//     } else {
//       result = await databaseHelper.insertNote(note);
//     }

//     if (result != 0) {
//       _showAlertDialog('Status', 'Note Saved Successfully');
//       moveToLastScreen();
//     } else {
//       _showAlertDialog('Status', 'Problem Saving Note');
//     }
//   }

//   void _delete() async {
//     if (note.id == null) {
//       _showAlertDialog('Status', 'No Note was deleted');
//       return;
//     }

//     int result = await databaseHelper.deleteNote(note.id);
//     if (result != 0) {
//       _showAlertDialog('Status', 'Note Deleted Successfully');
//       moveToLastScreen();
//     } else {
//       _showAlertDialog('Status', 'Error Occurred while Deleting Note');
//     }
//   }

//   void _showAlertDialog(String title, String message) {
//     AlertDialog alertDialog = AlertDialog(
//       title: Text(title),
//       content: Text(message),
//     );
//     showDialog(context: context, builder: (_) => alertDialog);
//   }

//   void moveToLastScreen() {
//     Navigator.pop(context, true);
//   }
// }
