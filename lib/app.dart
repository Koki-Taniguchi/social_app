import 'package:flutter/material.dart';
import 'package:social_picture/widget/loading.dart';
import 'package:social_picture/widget/map.dart';
import 'package:social_picture/widget/photo_form.dart';
import 'package:social_picture/widget/sign_in.dart';
import 'package:social_picture/widget/sign_up.dart';

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signIn',
      routes: <String, WidgetBuilder>{
        '/signIn': (BuildContext context) => SignInPage(),
        '/signUp': (BuildContext context) => SignUpPage(),
        '/home': (BuildContext context) => MapApp(),
        '/photoForm': (BuildContext context) => PhotoFrom(),
        '/loading': (BuildContext context) => Loading(routeObserver),
      },
      navigatorObservers: [
        routeObserver,
      ],
    );
  }
}
