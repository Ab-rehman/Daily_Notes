import 'package:flutter/material.dart';

const kNotesTextStyle = TextStyle(color: Color(0xffeeeeee),fontFamily: 'Karla',letterSpacing: 0.8,fontSize: 17);

const kNotesTitleStyle = TextStyle(color: Color(0xffEAEAEC),fontFamily: 'Karla',fontWeight: FontWeight.bold,fontSize: 20.0,letterSpacing: 0.5);

const kAppbarTitleStyle = TextStyle(color: Color(0xffEAEAEC),fontFamily: 'Karla',fontWeight: FontWeight.bold,fontSize: 24.0);

const kNotesTimeStampStyle = TextStyle(color: Color(0xffaaaaaa),fontFamily: 'Karla',letterSpacing: 0.8,fontSize: 12);

const kTextFieldEmailDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xff323242),
  hintText: 'Enter your email',
  hintStyle: TextStyle(
    color: Colors.grey
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff323242), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff323242), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTextFieldPasswordDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xff323242),
  hintText: 'Enter your password  ',
  hintStyle: TextStyle(
      color: Colors.grey
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff323242), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff323242), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

