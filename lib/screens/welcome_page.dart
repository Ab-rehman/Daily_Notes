import 'package:daily_notes/constants.dart';
import 'package:daily_notes/screens/login_screen_page.dart';
import 'package:daily_notes/screens/register_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatelessWidget {
  static const id = 'welcome_page';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return WillPopScope(
      onWillPop: () {
        return SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Color(0xff1F1D2B),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'images/notes.png',
                      height: MediaQuery.of(context).size.width * 0.4,

                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Hero(
                  tag: 'dailynotes',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      'Daily Notes',
                      style: kAppbarTitleStyle.copyWith(fontSize: 40.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Take notes, reminders, set targets, collect resources, and much more',
                  style: kNotesTextStyle.copyWith(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 25.0,
                ),
                Hero(
                  tag: 'login',
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreenPage.id);
                      },
                      child: Text('Login',style: kNotesTitleStyle),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Color(0xff6F6FC8)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Hero(
                  tag: 'register',
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreenPage.id);
                      },
                      child: Text('Register',style: kNotesTitleStyle),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Color(0xff6F6FC8)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
