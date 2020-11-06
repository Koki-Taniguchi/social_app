import 'package:flutter/material.dart';
import 'widget/sign_up.dart';
import 'widget/sign_in.dart';
import 'widget/map.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signIn',
      routes: <String, WidgetBuilder>{
        '/signIn': (BuildContext context) => SignInPage(),
        '/signUp': (BuildContext context) => SignUpPage(),
        '/home': (BuildContext context) => MapApp(),
      },
    );
  }
}
