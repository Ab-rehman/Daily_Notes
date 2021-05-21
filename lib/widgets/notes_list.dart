import 'package:daily_notes/screens/edit_notes_page.dart';
import 'package:flutter/material.dart';
import 'package:daily_notes/constants.dart';
import 'package:daily_notes/models/notes_data.dart';
import 'package:provider/provider.dart';



class NotesList extends StatelessWidget {
  final int index;

  NotesList({this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.025,
          MediaQuery.of(context).size.width * 0.025,
          MediaQuery.of(context).size.width * 0.025,
          MediaQuery.of(context).size.width * 0.025),
      child: ElevatedButton(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure?', style: kNotesTitleStyle),
                  backgroundColor: Color(0xff323242),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text(
                          'Do you want to delete this note?',
                          style: kNotesTextStyle,
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Provider.of<NotesData>(context,listen: false).deleteTask(index);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Yes',
                        style: kNotesTextStyle,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No',
                        style: kNotesTextStyle,
                      ),
                    )
                  ],
                );
              });
        },
        style: ButtonStyle().copyWith(
          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          backgroundColor: MaterialStateProperty.all(Color(0xff1F1D2B)),
          shadowColor: MaterialStateProperty.all(Color(0xff1F1D2B)),
          elevation: MaterialStateProperty.all(0.0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNotesPage(
                index: index,
                titleText: Provider.of<NotesData>(context).notes[index].title,
                messageText:
                    Provider.of<NotesData>(context).notes[index].message,
              ),
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: 90.0,
            minWidth: MediaQuery.of(context).size.width / 2 -
                (MediaQuery.of(context).size.width * 0.025 * 2),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xff323242),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.025,
              vertical: MediaQuery.of(context).size.width * 0.025,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  Provider.of<NotesData>(context).notes[index].title,
                  style: kNotesTitleStyle,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  Provider.of<NotesData>(context).notes[index].message,
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: kNotesTextStyle,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  Provider.of<NotesData>(context).notes[index].timeStamp,
                  style: kNotesTimeStampStyle,
                ),
                SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
