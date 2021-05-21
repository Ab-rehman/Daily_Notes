import 'package:daily_notes/models/database_helper.dart';
import 'package:daily_notes/models/notes_data.dart';
import 'package:daily_notes/screens/add_notes_page.dart';
import 'package:daily_notes/screens/screen_decider.dart';
import 'package:daily_notes/screens/welcome_page.dart';
import 'package:daily_notes/widgets/notes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daily_notes/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotesPage extends StatefulWidget {
  static const id = 'notes_page';

  void ifOnlineUploadandDelete() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await NotesData().addToFirebase();
        await NotesData().removeFromFirebase();
        await NotesData().updatetoFirebase();
      }
    } on SocketException catch (_) {}
  }

  void isConnected() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.mobile ||
        await Connectivity().checkConnectivity() == ConnectivityResult.wifi) {
      ifOnlineUploadandDelete();
    }
  }

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLoad = false;
  var subscription;

  @override
  void initState() {
    super.initState();
    NotesPage().isConnected();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        NotesPage().ifOnlineUploadandDelete();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoad) {
      Provider.of<NotesData>(context).loadNoteToListFromDb();
      isLoad = true;
    }
    return WillPopScope(
      onWillPop: () {
        return SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Color(0xff1F1D2B),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          backwardsCompatibility: false,
          backgroundColor: Color(0xff1F1D2B),
          title: Text(
            'Notes',
            style: kAppbarTitleStyle,
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff1F1D2B)),
                      shadowColor: MaterialStateProperty.all(Color(0xff1F1D2B)),
                      elevation: MaterialStateProperty.all(0.0),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      )),
                  onPressed: () async {
                    bool test = await NotesData().allUploaded;
                    // ignore: unrelated_type_equality_checks
                    if (!test) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Are you sure?',
                                  style: kNotesTitleStyle),
                              backgroundColor: Color(0xff323242),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text(
                                      'we have noticed that you have Unsynced data. Please Sync to avoid losing data.',
                                      style: kNotesTextStyle,
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        NotesPage().isConnected();
                                        Navigator.pop(context);
                                      }
                                    } on SocketException catch (_) {
                                      Fluttertoast.showToast(
                                        msg:
                                            'Please make sure you have an active internet connection',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIos: 3,
                                        backgroundColor: Color(0xff323242),
                                        textColor: Colors.white,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Sync Now',
                                    style: kNotesTextStyle,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove('email');
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    _auth.signOut();
                                    Navigator.pushReplacementNamed(
                                        context, WelcomePage.id);
                                  },
                                  child: Text(
                                    'Log Out',
                                    style: kNotesTextStyle,
                                  ),
                                )
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Are you sure?',
                                  style: kNotesTitleStyle),
                              backgroundColor: Color(0xff323242),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text(
                                      'Do you want to Log out from daily notes?',
                                      style: kNotesTextStyle,
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove('email');
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    _auth.signOut();
                                    Navigator.pushReplacementNamed(
                                        context, WelcomePage.id);
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
                    }
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 32.0,
                  ),
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 7.0,
          onPressed: () {
            Navigator.pushNamed(context, AddNotesPage.id);
          },
          backgroundColor: Color(0xff6F6FC8),
          child: Image.asset(
            'images/add.png',
            width: 33.0,
            height: 33.0,
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Provider.of<NotesData>(context).noteLength != 0
              ? StaggeredGridView.countBuilder(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 4,
                  itemBuilder: (context, index) {
                    return NotesList(
                      index: index,
                    );
                  },
                  itemCount: Provider.of<NotesData>(context).noteLength,
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.fit(2);
                  },
                )
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/folder.png',
                          height: MediaQuery.of(context).size.width * 0.4,
                        ),
                        Text(
                          'No Notes Here',
                          style: kNotesTextStyle,
                        )
                      ]),
                ),
        ),
      ),
    );
  }
}
