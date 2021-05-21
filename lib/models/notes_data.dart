import 'package:daily_notes/models/database_helper.dart';
import 'package:daily_notes/screens/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notes.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_notes/encrypt_decrypt.dart';

class NotesData extends ChangeNotifier {
  List<Notes> notes = [];

  int get noteLength {
    return notes.length;
  }

  get allUploaded async {
    List queries = await DatabaseHelper.instance.queryAllRowsDesc();
    for(var query in queries) {
      if(query[DatabaseHelper.columnUploaded]=='false'||query[DatabaseHelper.columnUpdated]=='true'||query[DatabaseHelper.columnDeleted]=='true') {
        return false;
      }
    }
    return true;
  }

  void removeFromFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List queries = await DatabaseHelper.instance.queryAllRowsDesc();
    for (var query in queries) {
      if (query[DatabaseHelper.columnDeleted] == 'true') {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(prefs.getString('uid'))
            .collection('Notes')
            .doc(query[DatabaseHelper.columnId].toString())
            .delete();
        await DatabaseHelper.instance.delete(query[DatabaseHelper.columnId]);
      }
    }
  }

  void updatetoFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List queries = await DatabaseHelper.instance.queryAllRowsDesc();
    for (var query in queries) {
      if (query[DatabaseHelper.columnUpdated] == 'true') {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(prefs.getString('uid'))
            .collection('Notes')
            .doc(query[DatabaseHelper.columnId].toString())
            .update({
          'title': EncryptDecrypt.encryptAes(query[DatabaseHelper.columnTitle]),
          'message':
          EncryptDecrypt.encryptAes(query[DatabaseHelper.columnMessage]),
          'timestamp':
          EncryptDecrypt.encryptAes(query[DatabaseHelper.columnTimestamp]),
        });
        await DatabaseHelper.instance.updateColumnUpdated('false',query[DatabaseHelper.columnId]);
      }
    }
  }

  void addToFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List queries = await DatabaseHelper.instance.queryAllRowsDesc();
    for (var query in queries) {
      if (query[DatabaseHelper.columnUploaded] == 'false') {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(prefs.getString('uid'))
            .collection('Notes')
            .doc(query[DatabaseHelper.columnId].toString())
            .set({
          'title': EncryptDecrypt.encryptAes(query[DatabaseHelper.columnTitle]),
          'message':
              EncryptDecrypt.encryptAes(query[DatabaseHelper.columnMessage]),
          'timestamp':
              EncryptDecrypt.encryptAes(query[DatabaseHelper.columnTimestamp]),
        });
        await DatabaseHelper.instance
            .updateColumnUploaded('true', query[DatabaseHelper.columnId]);
      }
    }
  }

  void loadNoteToListFromDb() async {
    List queries = await DatabaseHelper.instance.queryAllRowsDesc();
    notes = [];
    for (var query in queries) {
      if (query[DatabaseHelper.columnDeleted] == 'false') {
        notes.add(Notes(
            id: query[DatabaseHelper.columnId],
            title: query[DatabaseHelper.columnTitle],
            message: query[DatabaseHelper.columnMessage],
            timeStamp: query[DatabaseHelper.columnTimestamp]));
      }
    }
    notifyListeners();
  }

  void deleteTask(int index) async {
    var queries = await DatabaseHelper.instance.isUploaded(notes[index].id);
    for (var query in queries)
      if (query[DatabaseHelper.columnUploaded] == 'false') {
        await DatabaseHelper.instance.delete(notes[index].id);
        notes.removeAt(index);
      } else {
        await DatabaseHelper.instance
            .updateColumnDeleted('true', notes[index].id);
        notes.removeAt(index);
      }
    NotesPage().isConnected();
    notifyListeners();
  }

  void updateDB(
      String titleText, String messageText, String timestamp, int index) async {
    await DatabaseHelper.instance.update({
      DatabaseHelper.columnTitle: titleText,
      DatabaseHelper.columnMessage: messageText,
      DatabaseHelper.columnTimestamp: timestamp,
      DatabaseHelper.columnUpdated: 'true'
    }, notes[index].id);
    loadNoteToListFromDb();
    NotesPage().isConnected();
    notifyListeners();
  }

  void addToList(String titleText, String messageText) async {
    await DatabaseHelper.instance.insert(
      {
        DatabaseHelper.columnTitle: titleText,
        DatabaseHelper.columnMessage: messageText,
        DatabaseHelper.columnTimestamp:
            DateFormat.yMMMd().format(DateTime.now()).toString(),
        DatabaseHelper.columnUploaded: 'false',
        DatabaseHelper.columnDeleted: 'false',
        DatabaseHelper.columnUpdated: 'false',
      },
    );
    NotesPage().isConnected();
    loadNoteToListFromDb();
    notifyListeners();
  }
}
