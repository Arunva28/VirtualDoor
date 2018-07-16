import 'dart:async';
import 'dart:convert';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtualdoor/loginPage.dart';
import 'package:virtualdoor/userjson.dart';

class UnitsPage extends StatefulWidget {
  final CurrentUser currentUser;

  UnitsPage({Key key, @required this.currentUser}) : super(key: key);

  @override
  _UnitsPageState createState() => new _UnitsPageState(currentUser);
}

class _UnitsPageState extends State<UnitsPage> {
  final CurrentUser currentUser;
  var expanded = 100.0;
  var parsed;
  _UnitsPageState(this.currentUser);

  static TextEditingController _name = new TextEditingController();
  static TextEditingController _unit = new TextEditingController();
  static TextEditingController _mobile = new TextEditingController();
  static TextEditingController _email = new TextEditingController();
  static TextEditingController _remarks = new TextEditingController();

  var visitorName = _name.text.toString();
  var unitName = _unit.text.toString();
  var mobileNo = _mobile.text.toString();
  var emailID = _email.text.toString();
  var remarks = _remarks.text.toString();

  final GlobalKey<ScaffoldState> _unitsPage = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _name.clear();
    _unit.clear();
    _mobile.clear();
    _email.clear();
    _remarks.clear();
    return new Scaffold(
      key: _unitsPage,
      backgroundColor: Colors.white,
      floatingActionButton: currentUser.isAdmin == false
          ? null
          : new FloatingActionButton(
              child: new Icon(Icons.add),
              backgroundColor: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new UserAddPage()));

                //_floatingButtonAction();
              },
            ),
      appBar: new AppBar(
        title: new Text(
          "Units",
          style: new TextStyle(letterSpacing: 2.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: new AsyncLoader(
          initState: ({data}) async => await fetchPost(),
          renderLoad: () {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          },
          renderError: ([error]) =>
              new Text('There was an error loading, Please try again!'),
          renderSuccess: ({data}) {
            return new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage(
                        "graphics/homePage.jpg",
                      ),
                      fit: BoxFit.fill)),
              child: new OrientationBuilder(
                builder: (context, orientation) {
                  return new Container(
                    child: new CustomScrollView(
                      slivers: <Widget>[
                        new SliverFillRemaining(
                          child: new Container(
                              padding: new EdgeInsets.all(0.0),
                              child: new FutureBuilder(
                                future: fetchPost(),
                                builder: (context, snapshot) {
                                  parsed = snapshot.data;
                                  if (parsed != null) {
                                    if (snapshot.hasData) {
                                      return new Container(
                                        child: new ListView.builder(
                                          itemExtent: 100.0,
                                          itemCount: parsed.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Card(
                                              child: new ListTile(
                                                leading: new Text(parsed[index]
                                                        ["unitNo"]
                                                    .toString()),
                                                title: new Text(parsed[index]
                                                        ["user"]["username"]
                                                    .toString()),
                                                trailing: new Text(parsed[index]
                                                        ["phoneNo"]
                                                    .toString()),
                                                subtitle: new Text(parsed[index]
                                                        ["user"]["email"]
                                                    .toString()),
                                                onLongPress: () {
                                                  _floatingButtonAction(
                                                      parsed[index]["user"]
                                                              ["email"]
                                                          .toString(),
                                                      parsed[index]["isAdmin"]
                                                          .toString());
                                                },
                                                onTap: () {
                                                  if (parsed[index]
                                                          ["phoneNo"] !=
                                                      null) {
                                                    _launchURL(parsed[index]
                                                            ["phoneNo"]
                                                        .toString());
                                                  } else {
                                                    showDialog(
                                                          context: context,
                                                          child:
                                                              new AlertDialog(
                                                            title: new Text(
                                                                'No number found'),
                                                            content:
                                                                new Text(data),
                                                            actions: <Widget>[
                                                              new FlatButton(
                                                                onPressed: () =>
                                                                    Navigator
                                                                        .of(
                                                                            context)
                                                                        .pop(
                                                                            true),
                                                                child: new Text(
                                                                    'OK'),
                                                              ),
                                                            ],
                                                          ),
                                                        ) ??
                                                        false;
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return new Text(snapshot.toString());
                                    }
                                  }
                                  // By default, show a loading spinner
                                  return new Center(
                                    child: new CircularProgressIndicator(),
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

  _launchURL(phone) async {
    var url = 'tel://+91' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future fetchPost() async {
    var jsoncodec = const JsonCodec();
    print(sessionID);

    var url = "http://arunva28.pythonanywhere.com/user_info/addqueryuser/";
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "cookie": sessionID.toString()
    });
    print(response.body);
    var responseJson = jsoncodec.decode(response.body);
    return responseJson;
  }

  Future _floatingButtonAction(String emailID, String isAdmin) {
    return showDialog(
          context: context,
          child: new SimpleDialog(
            title: new Text(
              "Select an option",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 16.0,
                letterSpacing: 1.5,
                color: Colors.lightBlueAccent,
                fontFamily: "Algerian",
              ),
            ),
            children: <Widget>[
              new FlatButton(
                  splashColor: Colors.red,
                  onPressed: () {
                    return showDialog(
                          context: context,
                          child: new AlertDialog(
                            title: new Text('Are you sure?'),
                            content:
                                new Text('Do you want to delete this user'),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  Navigator.of(context).pop(false);
                                },
                                child: new Text('No'),
                              ),
                              new FlatButton(
                                onPressed: () {
                                  print(isAdmin);
                                  print(emailID);
                                  if (isAdmin == "true") {
                                    fetchPostdeleteUser(emailID, isAdmin);
                                  } else {
                                    showSnackBar(
                                        "You do not have permissions to do it, Please contact your admin");
                                  }
                                },
                                child: new Text('Yes'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  child: new Text(
                    "Delete user",
                    style: new TextStyle(color: Colors.red, fontSize: 14.0),
                  )),
            ],
          ),
        ) ??
        false;
  }

  Future fetchPostdeleteUser(String emailID, String IsAdmin) async {
    print("1");
    var jsoncodec = const JsonCodec();
    var url = "http://arunva28.pythonanywhere.com/user_info/delete/" + emailID;

    print(url);

    var response = await http.delete(url, headers: {
      "Accept": "application/json",
      "cookie": sessionID.toString()
    });

    print(response.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pop(false);
      Navigator.of(context).pop(false);
      await new Future.delayed(const Duration(seconds: 1));
      showSnackBar(response.body.toString());
      await new Future.delayed(const Duration(seconds: 2));
    }

    var responseJson = jsoncodec.decode(response.body);
  }

  void showSnackBar(String value) {
    _unitsPage.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }
}

class UserAddPage extends StatefulWidget {
  @override
  _UserAddPageState createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final GlobalKey<ScaffoldState> _unitsPageKey = new GlobalKey<ScaffoldState>();

  bool _ischecked = false;

  static TextEditingController _name = new TextEditingController();
  static TextEditingController _password = new TextEditingController();
  static TextEditingController _mobile = new TextEditingController();
  static TextEditingController _email = new TextEditingController();
  static TextEditingController _unit = new TextEditingController();
  static TextEditingController _buildingNo = new TextEditingController();
  static TextEditingController _isAdmin = new TextEditingController();

  String userName = "";
  String password = "";
  String mobileNo = "";
  String emailID = "";
  String buildingNo = "";
  String unitNo = "";
  String isAdmin = "";

  String isAdminValue;

  void onChanged(bool value) {
    setState(() {
      _ischecked = value;
    });
    if (value == true) {
      isAdminValue = "True";
    } else {
      isAdminValue = "False";
    }
  }

  @override
  Widget build(BuildContext context) {
    _name.clear();
    _password.clear();
    _mobile.clear();
    _email.clear();
    _unit.clear();
    _isAdmin.clear();
    _buildingNo.clear();
    return new Scaffold(
      key: _unitsPageKey,
      appBar: new AppBar(),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("graphics/login.jpg"), fit: BoxFit.fill),
        ),
        padding: new EdgeInsets.only(
          top: (MediaQuery.of(context).size.height * 0.02),
          left: (MediaQuery.of(context).size.width * 0.1),
          right: (MediaQuery.of(context).size.width * 0.1),
        ),
        child: new Flex(
          direction: Axis.vertical,
          children: <Widget>[
            new Expanded(
                child: new Container(
              child: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.only(top: 10.0)),
                    new TextField(
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      controller: _name,
                      decoration: new InputDecoration(
                        labelStyle: new TextStyle(color: Colors.white),
                        labelText: "Enter Username*",
                      ),
                    ),
                    new TextField(
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      controller: _password,
                      obscureText: true,
                      decoration: new InputDecoration(
                        labelText: "Enter a password*",
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new TextField(
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      controller: _mobile,
                      decoration: new InputDecoration(
                        labelText: "Enter a mobile number*",
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      controller: _email,
                      decoration: new InputDecoration(
                        labelText: "Enter user's email ID*",
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new TextField(
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      controller: _unit,
                      decoration: new InputDecoration(
                        labelText: "Unit Number*",
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new TextField(
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      controller: _buildingNo,
                      decoration: new InputDecoration(
                        labelText: "Building Name*",
                        labelStyle: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 5.0)),
                    new CheckboxListTile(
                        title: new Text(
                          "Is Admin?",
                          style: new TextStyle(color: Colors.white),
                        ),
                        activeColor: Colors.brown,
                        value: _ischecked,
                        onChanged: (bool value) {
                          //print(value);
                          print(_ischecked);
                          onChanged(value);
                        }),
                    new Container(
                      child: new Text(
                        "* represents mandatory field",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[],
                        ),
                        new FloatingActionButton(
                          backgroundColor: Colors.lightBlueAccent,
                          child: new Icon(Icons.check),
                          notchMargin: 3.0,
                          onPressed: _addUser,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _addUser() {
    userName = _name.text.toString();
    password = _password.text.toString();
    mobileNo = _mobile.text.toString();
    emailID = _email.text.toString();
    buildingNo = _buildingNo.text.toString();
    unitNo = _unit.text.toString();
    isAdmin = isAdminValue;

    fetchPost();
  }

  Future fetchPost() async {
    var jsoncodec = const JsonCodec();
    var userJson = UserJson(userName, password, emailID);
    //var user = jsoncodec.encode(userJson);

    //print(user);

    var userdetails =
        UserDtails(userJson.toJson(), mobileNo, unitNo, buildingNo, isAdmin);

    //print(userdetails.toJson().toString());

    var userdetailsJson = jsoncodec.encode(userdetails.toJson());
    print(userdetailsJson);

    var url = "http://arunva28.pythonanywhere.com/user_info/addqueryuser/";

    Response response = await http.post(url,
        body: userdetailsJson.toString(),
        headers: {
          "Content-Type": "application/json",
          "cookie": sessionID.toString()
        });
    print(response.body);
    var responseJson = jsoncodec.decode(response.body);

    if (response.statusCode == 200) {
      //print("Success");
      showSnackBar("Success");
    } else {
      print("Failure");
      //showSnackBar(responseJson);
    }

    return responseJson;
  }

  void showSnackBar(String value) {
    _unitsPageKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}

class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Delete User",
          style: new TextStyle(letterSpacing: 2.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
