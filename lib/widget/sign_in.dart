import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Text(
                      'Vestigium',
                      style: TextStyle(fontSize: 50.0),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: Icon(
                      Icons.public,
                      size: 100.0,
                    ),
                  ),
                  Text(
                    'Sign  In',
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.mail,
                          color: Colors.black45,
                        ),
                        title: TextFormField()),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: Colors.black45,
                        ),
                        title: TextFormField(
                          obscureText: true,
                        )),
                  ),
                  Container(
                    height: 50.0,
                    width: 150.0,
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    child: RaisedButton(
                      child: Text('Sign In', style: TextStyle(fontSize: 20.0)),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        goToHomePage(context);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 40),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signUp');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToHomePage(context) async {
    await Navigator.of(context).pushReplacementNamed('/loading');
  }
}
