// ignore_for_file: public_member_api_docs, sort_constructors_first
class Note {
  late int? _id;
  late String? _title;
  String? _description;
  late String? _date;
  late int? _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => _id!;

  String get title => _title!;

  String get description => _description!;

  int get priority => _priority!;

  String get date => _date!;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}












// class Note {
//   int? _id;
//   late String _title;
//   String? _description;
//   late String _date;
//   late int _priority;

//   Note(this._title, this._date, this._priority, [this._description]);

//   Note.withId(this._id, this._title, this._date, this._priority,
//       [this._description]);

//   int? get id => _id;
//   String get title => _title;
//   String? get description => _description;
//   String get date => _date;
//   int get priority => _priority;

//   set title(String? newTitle) {
//     if (newTitle != null) {
//       if (newTitle.length <= 50) {
//         _title = newTitle;
//       }
//     }
//   }

//   set description(String? description) {
//     if (description != null) {
//       if (description.length <= 200) {
//         _description = description;
//       }
//     }
//   }

//   set priority(int? newPriority) {
//     if (newPriority != null) {
//       if (newPriority >= 1 && newPriority <= 2) {
//         _priority = newPriority;
//       }
//     }
//   }

//   set date(String? newDate) {
//     if (newDate != null) {
//       _date = newDate;
//     }
//   }

//   // Map<String, dynamic> toMap() {
//   //   return <String, dynamic>{
//   //     '_id': _id,
//   //     '_title': _title,
//   //     '_description': _description,
//   //     '_date': _date,
//   //     '_priority': _priority,
//   //   };
//   // }

//   Map<String, dynamic> toMap() {
//     var map = Map<String, dynamic>();
//     if (id != null) {
//       map['id'] = _id;
//     }
//     map['title'] = _title;
//     map['description'] = _description;
//     map['priority'] = _priority;
//     map['date'] = _date;
//     return map;
//   }

//   Note.formMapObject(Map<String, dynamic> map) {
//     this._id = map['id'];
//     _title = map["title"];
//     _description = map['description'];
//     _priority = map['priority'];
//     _date = map['date'];
//   }
// }
