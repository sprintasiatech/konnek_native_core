import 'package:flutter/material.dart';
import 'package:flutter_module1/screen/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      // home: const MyHomePage(
      //   title: 'Flutter Demo Home Page',
      // ),
    );
  }
}
