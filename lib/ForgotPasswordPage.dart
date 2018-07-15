import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:virtualdoor/loginPage.dart';
import 'package:virtualdoor/userjson.dart';

TextEditingController _forgotemailID = new TextEditingController();
String emailID;

final GlobalKey<ScaffoldState> _forgotpasswordstate =
    new GlobalKey<ScaffoldState>();

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static TextEditingController _OTP = new TextEditingController();
  static TextEditingController _new_password = new TextEditingController();
  static TextEditingController _confirm_password = new TextEditingController();

  String OTP = "";
  String new_password = "";
  String confirm_password = "";
  Response response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text(
          "Forgot Password",
          style: new TextStyle(letterSpacing: 2.0),
        ),
        automaticallyImplyLeading: false,
      ),
      body: new Container(
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
              enabled: false,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.grey,
              ),
              controller: _forgotemailID,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: new TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
                labelText: "  email - ID",
                counterStyle: new TextStyle(
                  letterSpacing: 1.2,
                ),
                prefixIcon: new Icon(
                  Icons.email,
                  color: Colors.grey,
                  size: 25.0,
                ),
              ),
            ),
            new TextField(
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.white,
              ),
              controller: _OTP,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: new TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                labelText: "   OTP",
                prefixIcon: new Icon(
                  Icons.phone_iphone,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
            new TextField(
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.white,
              ),
              controller: _new_password,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: new TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                labelText: "   New Password",
                prefixIcon: new Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
            new TextField(
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.white,
              ),
              controller: _confirm_password,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                labelStyle: new TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                labelText: "   Confirm Password",
                prefixIcon: new Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
            new PhysicalModel(
              color: Colors.lightBlueAccent.withOpacity(0.8),
              child: new FlatButton(
                  splashColor: Colors.white,
                  padding: new EdgeInsets.all(12.0),
                  onPressed: () {
                    _resetPassword(context);
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
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4)),
          ].reversed.toList(),
        ),
      ),
    );
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void _resetPassword(BuildContext context) {
    OTP = _OTP.text.toString();
    new_password = _new_password.text.toString();
    confirm_password = _confirm_password.text.toString();

    if ((OTP != null) && (new_password != null) && (confirm_password != null)) {
      if ((OTP.isNotEmpty) &&
          (new_password.isNotEmpty) &&
          (confirm_password.isNotEmpty)) {
        if (new_password == confirm_password) {
          _OTP.clear();
          _new_password.clear();
          _confirm_password.clear();
          _forgotemailID.clear();
          fetchPost();
        } else {
          showSnackBar("Passwords don't match");
        }
      } else {
        showSnackBar("All fields are mandatory");
      }
    } else {
      showSnackBar("Internal error, please try again");
    }
  }

  Future<Null> fetchPost() async {
    var jsoncodec = const JsonCodec();
    var Json = ForgotPasswordOTP(emailID, OTP, new_password, confirm_password);
    var json = jsoncodec.encode(Json);

    print(json);

    var url = "http://arunva28.pythonanywhere.com/user_info/forgot_password/";

    response = await http
        .post(url, body: json, headers: {"Content-Type": "application/json"});
    print(response.body);

    var responseJson = jsoncodec.decode(response.body);

    if (response.statusCode == 200) {
      await new Future.delayed(const Duration(seconds: 2));

      _showDialog(responseJson);
    } else {
      //showSnackBar(responseJson);
    }

    //return responseJson;
  }

  void showSnackBar(String value) {
    _forgotpasswordstate.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future _showDialog(var text) {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text(text),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  emailID = "";
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) => new LoginPage(
                            //title: "Login Page",
                            ),
                        fullscreenDialog: true,
                      ));
                },
                child: new Text('OK'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class ForgotpasswordemailPage extends StatefulWidget {
  @override
  _ForgotpasswordemailPageState createState() =>
      _ForgotpasswordemailPageState();
}

class _ForgotpasswordemailPageState extends State<ForgotpasswordemailPage> {
  Response response;
  String _errorText = "Enter the email to change password";
  Color colorValue = Colors.white;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _forgotpasswordstate,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text(
          "Forgot Password",
          style: new TextStyle(letterSpacing: 2.0),
        ),
        automaticallyImplyLeading: false,
      ),
      body: new Container(
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
              onChanged: (emailID) {
                if (emailID.isEmpty) {
                  setState(() {
                    _errorText = "Enter the email to change password";
                    colorValue = Colors.white;
                  });
                } else if (emailID.contains("@") &&
                    (emailID.contains(".com"))) {
                  setState(() {
                    _errorText = "email ID format valid";
                    colorValue = Colors.lightGreen;
                  });
                } else {
                  setState(() {
                    _errorText = "Please type a correct email - ID";
                    colorValue = Colors.red;
                  });
                }
              },
              maxLines: 1,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.white,
              ),
              controller: _forgotemailID,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                suffixIcon: new IconButton(
                  onPressed: () {
                    emailID = _forgotemailID.text.toString();
                    _dismissKeyboard(context);
                    if (emailID != null) {
                      if (emailID.isNotEmpty) {
                        _validateEmail();
                      }
                    }
                  },
                  icon: new Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                labelStyle: new TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
                labelText: "  email - ID",
                counterText: _errorText,
                counterStyle: new TextStyle(
                  letterSpacing: 1.2,
                  color: colorValue,
                ),
                prefixIcon: new Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
            new Padding(
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.7)),
          ].reversed.toList(),
        ),
      ),
    );
  }

  void showSnackBar(String value) {
    _forgotpasswordstate.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future fetchPost() async {
    var jsoncodec = const JsonCodec();
    var Json = ForgotPasswordemail(emailID);
    var json = jsoncodec.encode(Json);

    print(json);

    var url =
        "http://arunva28.pythonanywhere.com/user_info/new_password_change/";

    response = await http
        .post(url, body: json, headers: {"Content-Type": "application/json"});
    print(response.body);

    var responseJson = jsoncodec.decode(response.body);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new ForgotPasswordPage(
                //title: "Login Page",
                ),
            fullscreenDialog: true,
          ));
    } else {
      showSnackBar(responseJson);
    }

    return responseJson;
  }

  Future _validateEmail() async {
    await new Future.delayed(const Duration(seconds: 2));
    print(emailID);
    if (emailID != null) {
      if (emailID.contains("@") && (emailID.contains(".com"))) {
        //request backend
        var response = fetchPost();
        showSnackBar(response.toString());
      } else {
        showSnackBar("Please enter an valid email ID");
      }
    } else {
      showSnackBar("Please enter an email ID");
    }
  }
}
