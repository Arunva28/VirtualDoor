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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: currentUser.isAdmin == false
          ? null
          : new FloatingActionButton(
              child: new Icon(Icons.add),
              backgroundColor: Colors.lightBlueAccent,
              onPressed: () => Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new UserAddPage())),
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
}

class UserAddPage extends StatefulWidget {
  @override
  _UserAddPageState createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final GlobalKey<ScaffoldState> _unitsPageKey = new GlobalKey<ScaffoldState>();
  bool switchvalue = false;

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _unitsPageKey,
      appBar: new AppBar(),
      body: new Container(
        height: double.infinity,
        width: double.infinity,
        padding: new EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: new Flex(
          direction: Axis.vertical,
          children: <Widget>[
            new Expanded(
                child: new Container(
              child: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.only(top: 10.0)),
                    new TextFormField(
                      textAlign: TextAlign.center,
                      controller: _name,
                      decoration: new InputDecoration(
                        labelText: "Enter Username*",
                      ),
                    ),
                    new TextFormField(
                      textAlign: TextAlign.center,
                      controller: _password,
                      obscureText: true,
                      decoration:
                          new InputDecoration(labelText: "Enter a password*"),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      controller: _mobile,
                      decoration: new InputDecoration(
                          labelText: "Enter a mobile number*"),
                    ),
                    new TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: new InputDecoration(
                          labelText: "Enter user's email ID*"),
                    ),
                    new TextFormField(
                      textAlign: TextAlign.center,
                      controller: _unit,
                      decoration:
                          new InputDecoration(labelText: "Unit Number*"),
                    ),
                    new TextFormField(
                      textAlign: TextAlign.center,
                      controller: _buildingNo,
                      decoration:
                          new InputDecoration(labelText: "Building Name*"),
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 5.0)),
                    new Container(
                      child: new Text(
                        "* represents mandatory field",
                        style: new TextStyle(
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.only(top: 10.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text("Is Admin?"),
                            new Checkbox(
                                value: switchvalue,
                                onChanged: (bool switchvalue) {
                                  _onChanged(switchvalue);
                                }),
                          ],
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

  void _onChanged(bool switchvalue) {
    setState(() {
      print(switchvalue);
      if (switchvalue == true) {
        switchvalue = false;
      } else {
        switchvalue = true;
      }
    });
  }

  void _addUser() {
    userName = _name.text.toString();
    password = _password.text.toString();
    mobileNo = _mobile.text.toString();
    emailID = _email.text.toString();
    buildingNo = _buildingNo.text.toString();
    unitNo = _unit.text.toString();
    isAdmin = "False";

//    if (isAdmin == false) {
//      String False = "False";
//      isAdmin = "False";
//    }

//    print("helo");
//    print(userName);
//    print(password);
//    print(mobileNo);
//    print(emailID);
//    print(unitNo);
//    print(buildingNo);

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
