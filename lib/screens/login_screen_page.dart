// import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_notes/encrypt_decrypt.dart';
import 'package:daily_notes/models/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_notes/constants.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'notes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreenPage extends StatefulWidget {
  static const id = 'login_screen_page';

  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ModalProgressHUD(
      progressIndicator: SpinKitWave(color: Colors.white),
      color: Color(0xff1F1D2B),
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff1F1D2B),
          title: Hero(
            tag: 'dailynotes',
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                'Daily Notes',
                style: kAppbarTitleStyle,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xff1F1D2B),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width * 0.9)),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'images/notes.png',
                        height: MediaQuery.of(context).size.width * 0.35,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50.0,
                    child: TextField(
                      controller: email,
                      decoration: kTextFieldEmailDecoration,
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50.0,
                      child: TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: kTextFieldPasswordDecoration,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  SizedBox(height: 30.0),
                  Hero(
                    tag: 'login',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final result = await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final user = await _auth.signInWithEmailAndPassword(
                                    email: email.text, password: pass.text);
                                if (user != null) {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  prefs.setString('uid', user.user.uid);
                                  prefs.setString('email', email.text);
                                  DatabaseHelper.instance.truncate();
                                  QuerySnapshot queries = await FirebaseFirestore.instance.collection('Users').doc(prefs.getString('uid')).collection('Notes').get();
                                  for(var query in queries.docs) {
                                    //print(query.reference.id);
                                    DatabaseHelper.instance.insert({
                                      DatabaseHelper.columnId: query.reference.id,
                                      DatabaseHelper.columnTitle: EncryptDecrypt.decryptAes(query['title']),
                                      DatabaseHelper.columnMessage: EncryptDecrypt.decryptAes(query['message']),
                                      DatabaseHelper.columnTimestamp: EncryptDecrypt.decryptAes(query['timestamp']),
                                      DatabaseHelper.columnUploaded: 'true',
                                      DatabaseHelper.columnDeleted: 'false',
                                      DatabaseHelper.columnUpdated: 'false',
                                    });
                                  }
                                  pass.clear();
                                  email.clear();
                                  Navigator.pushNamed(context, NotesPage.id);
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });

                                Fluttertoast.showToast(
                                  msg:
                                  e.message,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 3,
                                  backgroundColor: Color(0xff323242),
                                  textColor: Colors.white,
                                );
                              }
                            }
                          } on SocketException catch (_) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                    Text('No Internet', style: kNotesTitleStyle),
                                    backgroundColor: Color(0xff323242),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Text(
                                            'Please make sure you have an active internet connection',
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
                                          'Okay',
                                          style: kNotesTextStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }

                        },
                        child: Text('Login', style: kNotesTitleStyle),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff6F6FC8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
