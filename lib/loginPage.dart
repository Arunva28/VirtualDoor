import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:virtualdoor/ForgotPasswordPage.dart';
import 'package:virtualdoor/myHomePage.dart';
import 'package:virtualdoor/userjson.dart';
//import 'package:jaguar_serializer/jaguar_serializer.dart';

CurrentUser currentUser;
Response LoginResponse;
var sessionID;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  Response response;
  static TextEditingController _username = new TextEditingController();
  static TextEditingController _password = new TextEditingController();

  String userName;
  String passWord;

  bool value = true;

  Future _validate() async {
    userName = _username.text.toString();
    passWord = _password.text.toString();

    if (userName.isEmpty) {
      showSnackBar("Please enter a username");
    } else if (passWord.isEmpty) {
      showSnackBar("Please enter a password");
    } else {
      fetchPost();
    }
  }

  Future fetchPost() async {
    var jsoncodec = const JsonCodec();
    var Json = UserLoginJson(userName, passWord);
    var json = jsoncodec.encode(Json);

    print(json);
    var url = "http://arunva28.pythonanywhere.com/user_info/login/";
    response = await http
        .post(url, body: json, headers: {"Content-Type": "application/json"});

    LoginResponse = response;

    var responseJson = jsoncodec.decode(response.body);
    print(response.headers);
    print(responseJson);
    if (response.statusCode == 200) {
      showSnackBar("Authentication Pass");
      var cookie = response.headers['set-cookie'].split(";");
      cookie = cookie[3].split(",");
      sessionID = cookie[1];
      print(cookie[1]);
      _username.clear();
      _password.clear();

      //SerializerRepo serializer = new JsonRepo();

      var user = new CurrentUser.fromJson(responseJson);

      await new Future.delayed(const Duration(seconds: 1));

      user.buildingName = responseJson["building_name"];
      user.unitNo = responseJson["unit_no"];
      user.isAdmin = responseJson["is_Admin"];

      print(user.isAdmin.toString());

      Navigator.pushReplacement(
          context,
          new CustomRoute(
              builder: (BuildContext context) => new MyHomePage(
                    currentUser: user,
                    response: response,
                  )));
    } else {
      showSnackBar(responseJson.toString());
    }

    return responseJson;
  }

  Response getResponse() {
    return response;
  }

  void showSnackBar(String value) {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  _loginBody() {
    return new WillPopScope(
      onWillPop: _willPopScope,
      child: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("graphics/login.jpg"), fit: BoxFit.fill),
        ),
        padding: new EdgeInsets.only(
          //top: MediaQuery.of(context).size.height * 0.1,
          left: MediaQuery.of(context).size.width * 0.13,
          right: MediaQuery.of(context).size.width * 0.13,
        ),
        child: new ListView(
          shrinkWrap: true,
          reverse: true,
          children: <Widget>[
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01)),
            new TextField(
              maxLines: 1,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.white,
              ),
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: new TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
                labelText: "  Username",
                prefixIcon: new Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01)),
            new TextField(
              maxLines: 1,
              textAlign: TextAlign.center,
              style: new TextStyle(
                decorationColor: Colors.white,
                color: Colors.white,
              ),
              controller: _password,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                suffixIcon: new IconButton(
                    icon: new Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    splashColor: Colors.teal,
                    onPressed: _redEyePressed),
                labelText: "    Password",
                prefixIcon: new Icon(
                  Icons.enhanced_encryption,
                  color: Colors.white,
                  size: 30.0,
                ),
                labelStyle: new TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
              obscureText: value,
            ),
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03)),
            new PhysicalModel(
              color: Colors.lightBlueAccent.withOpacity(0.8),
              child: new FlatButton(
                  splashColor: Colors.blueAccent,
                  padding: new EdgeInsets.all(15.0),
                  onPressed: () {
                    _validate();
                    _dismissKeyboard(context);
                  },
                  child: new Text(
                    "Login",
                    style: new TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontSize: 14.0,
                    ),
                  )),
            ),
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01)),
            new FlatButton(
                onPressed: () {
                  _username.clear();
                  _password.clear();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ForgotpasswordemailPage(
                                //title: "Login Page",
                                ),
                        fullscreenDialog: true,
                      ));
                },
                child: new Text(
                  "Forgot Password?",
                  style: new TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                )),
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1)),
            new Center(
              child: new CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.transparent,
                backgroundImage: new AssetImage("graphics/icon.png"),
              ),
            ),
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1)),
          ].reversed.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text(
          "Login",
          style: new TextStyle(letterSpacing: 2.0),
        ),
        automaticallyImplyLeading: false,
      ),
      key: _scaffoldstate,
      body: _loginBody(),
    );
  }

  void _redEyePressed() {
    setState(() {
      if (value) {
        value = false;
      } else {
        value = true;
      }
    });
  }

  Future<bool> _willPopScope() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
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
    return new ScaleTransition(child: child, scale: animation);
  }
}

class UserLoginJson {
  String _name;
  String _password;

  UserLoginJson(this._name, this._password);

  Map toJson() {
    return {
      "username": _name.toString(),
      "password": _password.toString(),
    };
  }
}
