import 'package:flutter/material.dart';
import 'package:picking_app/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenStem Picking App',
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.transparent,
        primarySwatch: Colors.green,
        fontFamily: "Montserrat",
      ),
      home: SplashScreen(),
    );
  }
}
