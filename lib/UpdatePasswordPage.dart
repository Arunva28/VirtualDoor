import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:virtualdoor/loginPage.dart';
import 'package:virtualdoor/userjson.dart';

class UpdatePasswordPage extends StatefulWidget {
  final CurrentUser currentUser;

  UpdatePasswordPage({Key key, @required this.currentUser}) : super(key: key);
  @override
  _UpdatePasswordPageState createState() =>
      _UpdatePasswordPageState(currentUser);
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final GlobalKey<ScaffoldState> _updatePasswordGlobalKey =
      new GlobalKey<ScaffoldState>();

  BuildContext context;
  final CurrentUser currentUser;
  Response response;

  _UpdatePasswordPageState(@required this.currentUser);

  static TextEditingController _current_password = new TextEditingController();
  static TextEditingController _new_password = new TextEditingController();
  static TextEditingController _confirm_password = new TextEditingController();

  String current_password = "";
  String new_password = "";
  String confirm_password = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _updatePasswordGlobalKey,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text(
          "Update Password",
          style: new TextStyle(
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: new Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("graphics/login.jpg"), fit: BoxFit.fill),
          ),
          padding: new EdgeInsets.only(
            top: (MediaQuery.of(context).size.height * 0.11),
            left: (MediaQuery.of(context).size.width * 0.02),
            right: (MediaQuery.of(context).size.width * 0.02),
            bottom: (MediaQuery.of(context).size.height * 0.4),
          ),
          child: new Card(
            color: Colors.transparent,
            child: new ListView(
              reverse: true,
              children: <Widget>[
                new TextField(
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  controller: _current_password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: new InputDecoration(
                    labelStyle: new TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "   Current Password",
                    prefixIcon: new Icon(
                      Icons.phone_iphone,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
                new Padding(
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.0005)),
                new TextField(
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  controller: _new_password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: new InputDecoration(
                    labelStyle: new TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "   New Password",
                    prefixIcon: new Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
                new Padding(
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.0005)),
                new TextField(
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  controller: _confirm_password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: new InputDecoration(
                    labelStyle: new TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "   Confirm Password",
                    prefixIcon: new Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
                new Padding(
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.0005)),
                new PhysicalModel(
                  color: Colors.lightBlueAccent.withOpacity(0.8),
                  child: new FlatButton(
                      splashColor: Colors.white,
                      padding: new EdgeInsets.all(12.0),
                      onPressed: () {
                        _validatePassword(context);
                      },
                      child: new Text(
                        "Update",
                        style: new TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.0,
                          fontSize: 14.0,
                        ),
                      )),
                ),
              ].reversed.toList(),
            ),
          )),
    );
  }

  Future _validatePassword(BuildContext context) async {
    new_password = _new_password.text.toString();
    confirm_password = _confirm_password.text.toString();
    current_password = _current_password.text.toString();

    _dismissKeyboard(context);

    if (new_password.compareTo(confirm_password) == 0) {
      if ((new_password.isNotEmpty) && (confirm_password.isNotEmpty)) {
        fetchPost(context);
      } else {
        showSnackBar("All fields are mandatory");
      }
    } else {
      showSnackBar("Passwords do not match");
    }
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future fetchPost(BuildContext context) async {
    _dismissKeyboard(context);
    var jsoncodec = const JsonCodec();
    var Json =
        UpdatePasswordDetails(current_password, new_password, confirm_password);
    var json = jsoncodec.encode(Json);

    print(sessionID.toString());
    print(json);

    var url = "http://arunva28.pythonanywhere.com/user_info/updatepassword/";

    response = await http.post(url, body: json, headers: {
      "Content-Type": "application/json",
      "cookie": sessionID.toString()
    });

    print(response.body);
    var responseJson = jsoncodec.decode(response.body);
    _new_password.clear();
    _current_password.clear();
    _confirm_password.clear();
    if (response.statusCode == 200) {
      showSnackBar(responseJson);
      await new Future.delayed(const Duration(seconds: 1));
      _fetchsignout(context);
    } else {
      showSnackBar(responseJson);
    }

    return responseJson;
  }

  void showSnackBar(String value) {
    _updatePasswordGlobalKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future _fetchsignout(BuildContext context) async {
    var url = "http://arunva28.pythonanywhere.com/user_info/logout/";
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "cookie": sessionID.toString()
    });
    print(response.body);
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage(
              //title: "Login Page",
              ),
          fullscreenDialog: true,
        ));
  }
}
