import 'package:daily_notes/models/database_helper.dart';
import 'package:daily_notes/models/notes_data.dart';
import 'package:daily_notes/screens/add_notes_page.dart';
import 'package:daily_notes/screens/edit_notes_page.dart';
import 'package:daily_notes/screens/login_screen_page.dart';
import 'package:daily_notes/screens/notes_page.dart';
import 'package:daily_notes/screens/register_screen_page.dart';
import 'package:daily_notes/screens/screen_decider.dart';
import 'package:daily_notes/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
          ),
          primarySwatch: Colors.blue,
        ),
        initialRoute: ScreenDecider.id,
        routes: {
          WelcomePage.id: (context) => WelcomePage(),
          ScreenDecider.id: (context) => ScreenDecider(),
          LoginScreenPage.id: (context) => LoginScreenPage(),
          RegisterScreenPage.id: (context) => RegisterScreenPage(),
          NotesPage.id: (context) => NotesPage(),
          AddNotesPage.id: (context) => AddNotesPage(),
          EditNotesPage.id: (context) => EditNotesPage()
        },
      ),
    );
  }
}
