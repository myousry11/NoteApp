import 'package:flutter/material.dart';
import 'package:note/app/notes/addnotes.dart';
import 'package:note/app/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/auth/login.dart';
import 'app/home.dart';
import 'app/notes/editnote.dart';

late SharedPreferences sharedPref;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      initialRoute: sharedPref.getString("id") == null ? "login" : "home",
      debugShowCheckedModeBanner: false,
      routes: {
        "login" : (context) => Login(),
        "signup" : (context) => Signup(),
        "home" : (context) => Home(),
        "addnotes" : (context) => AddNotes(),
        "editnotes" : (context) => EditNotes(),
      },
    );
  }

}