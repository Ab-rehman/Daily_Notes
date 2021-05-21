import 'package:daily_notes/constants.dart';
import 'package:daily_notes/models/notes_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddNotesPage extends StatelessWidget {
  // String titleText, messageText;
  static const id = 'add_notes_page';
  var titleController = TextEditingController();
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?', style: kNotesTitleStyle),
              backgroundColor: Color(0xff323242),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'Any changes you made will not be saved.',
                      style: kNotesTextStyle,
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
          },
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xff1F1D2B),
        appBar: AppBar(
          title: Text(
            'Add Note',
            style: kAppbarTitleStyle,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (titleController.text != null &&
                          titleController.text.trim().length > 0 &&
                          messageController.text != null &&
                          messageController.text.trim().length > 0) {
                        Provider.of<NotesData>(context, listen: false)
                            .addToList(titleController.text.trim(),
                                messageController.text.trim());
                        Navigator.pop(context);
                      } else if ((titleController.text == null &&
                              messageController.text.trim().length == 0) ||
                          (titleController.text.trim().length == 0 &&
                              messageController.text == null) ||
                          (titleController.text.trim().length == 0 &&
                              messageController.text.trim().length == 0) ||
                          (titleController.text == null &&
                              messageController.text == null)) {
                        titleController.clear();
                        messageController.clear();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Note', style: kNotesTitleStyle),
                                backgroundColor: Color(0xff323242),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text(
                                        'The Title Field and Note Field cannot be left empty!',
                                        style: kNotesTextStyle,
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: kNotesTextStyle,
                                      ))
                                ],
                              );
                            });
                      } else if (titleController.text == null ||
                          titleController.text.trim().length == 0) {
                        titleController.clear();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Note', style: kNotesTitleStyle),
                                backgroundColor: Color(0xff323242),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text(
                                        'The Title Field cannot be left empty!',
                                        style: kNotesTextStyle,
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: kNotesTextStyle,
                                      ))
                                ],
                              );
                            });
                      } else if (messageController.text == null ||
                          messageController.text.trim().length == 0) {
                        messageController.clear();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Note', style: kNotesTitleStyle),
                                backgroundColor: Color(0xff323242),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text(
                                        'The Note Field cannot be left empty!',
                                        style: kNotesTextStyle,
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: kNotesTextStyle,
                                      ))
                                ],
                              );
                            });
                      }
                    },
                    style: ButtonStyle().copyWith(
                        elevation: MaterialStateProperty.all<double>(8.0),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xff323242))),
                    child: Text(
                      'Save',
                      style: kAppbarTitleStyle.copyWith(
                          color: Colors.grey, fontSize: 23.0),
                    ),
                  ),
                ],
              ),
            )
          ],
          //toolbarHeight: 188,
          automaticallyImplyLeading: false,
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          backgroundColor: Color(0xff1F1D2B),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: TextField(
                  autofocus: true,
                  controller: titleController,
                  onChanged: (value) {},
                  cursorColor: Colors.lightBlue.shade200,
                  // textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.bottom,
                  textCapitalization: TextCapitalization.sentences,
                  style: kNotesTitleStyle,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
                    labelText: 'Title',
                    filled: true,
                    fillColor: Color(0xff323242),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(
                          color: Color(0xff323242), /*width: 4.0*/
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(
                          color: Color(0xff323242), /*width: 4.0*/
                        )),
                  ),
                  // onChanged: ,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: (MediaQuery.of(context).size.height - 215)
                        .floor()
                        .toDouble(),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: Color(0xff323242),
                  ),
                  child: TextField(
                    controller: messageController,
                    cursorColor: Colors.lightBlue.shade200,
                    textAlignVertical: TextAlignVertical.bottom,
                    textCapitalization: TextCapitalization.sentences,
                    style: kNotesTextStyle,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintStyle: kNotesTextStyle.copyWith(
                          color: Color(0xffaaaaaa), fontSize: 17.0),
                      hintText: 'Note . . . . ',
                      filled: true,
                      fillColor: Color(0xff323242),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(
                            color: Color(0xff323242), /*width: 4.0*/
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(
                            color: Color(0xff323242), /*width: 4.0*/
                          )),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
