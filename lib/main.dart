import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtualdoor/loginPage.dart';

final ThemeData _theme = new ThemeData(
  primaryColor: Colors.black,
  backgroundColor: Colors.black,
  fontFamily: 'Algerian',
);

void main() => runApp(new virtualdoor());

class virtualdoor extends StatefulWidget {
  @override
  _virtualdoorState createState() => new _virtualdoorState();
}

class _virtualdoorState extends State<virtualdoor> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Virtual Door',
        theme: _theme,
        home: new LoginPage());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _switchPage();
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  flex: 2,
                  child: new Container(
                      child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.black,
                        child: new Icon(
                          Icons.all_inclusive,
                          color: Colors.white,
                          size: 80.0,
                        ),
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 50.0),
                        child: new Text(
                          "Virtual Door",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Algerian",
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ))),
              new Expanded(
                  flex: 1,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircularProgressIndicator(),
                      new Text(
                        "Endless \n Opportunities",
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Future _switchPage() async {
    await new Future.delayed(const Duration(seconds: 3));

//    Navigator.pushReplacement(context,
//        new CustomRoute(builder: (BuildContext context) => new LoginPage()));
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}
