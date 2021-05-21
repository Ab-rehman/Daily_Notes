import 'package:daily_notes/screens/notes_page.dart';
import 'package:daily_notes/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';

class ScreenDecider extends StatelessWidget {
  static const id = 'screen_decider';
  bool showSpinner = false;

  void autoLogIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('email') != null
        ? Navigator.pushNamed(context, NotesPage.id)
        : Navigator.pushNamed(context, WelcomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            autoLogIn(context);
          }


          return Scaffold(
            backgroundColor: Color(0xff1F1D2B),
            body: Center(
              child: SpinKitWave(color: Colors.white),
            ),
          );
        }
    );
  }
}

