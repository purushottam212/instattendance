import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instattendance/view/authentication_view/authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: GoogleFonts.titilliumWeb().fontFamily,
            //primarySwatch: Colors.indigo,
            primaryColor: Colors.indigoAccent),
        home: AuthenticationView());
    // home: const TeacherHome());
  }
}
