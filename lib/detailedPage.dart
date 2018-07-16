import 'dart:async';
import 'dart:convert';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:virtualdoor/loginPage.dart';
import 'package:virtualdoor/userjson.dart';

final GlobalKey<ScaffoldState> _detailedScaffoldState =
    new GlobalKey<ScaffoldState>();
DateTime _date = new DateTime.now();
TimeOfDay _time = new TimeOfDay.now();

String _dateForClass = "";
String _timeForClass = "";

var parsed;

class DetailPage extends StatelessWidget {
  DetailPage({this.name, this.value});

  Widget retVal;
  final String name;
  final String value;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    context = context;
    print(currentUser);
    switch (name) {
      case "Accounts":
        retVal = _accountsPage(context);
        break;
      case "Society":
        retVal = _societyPage(context);
        break;
      case "Newsletters":
        retVal = _newsletterPage(context);
        break;
      case "Staff":
        retVal = _staffPage(context);
        break;
      case "Booking":
        retVal = _bookingPage(context);
        break;
      case "Contacts":
        retVal = _ContactsPage(context);
        break;
      case "Vendors":
        retVal = _vendorsPage(context);
        break;
      case "Security":
        retVal = _securityPage(context);
        break;
    }

    return retVal;
  }

  Widget _accountsBody() {
    return new Container(
      child: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            backgroundColor: Colors.lightBlueAccent,
            pinned: true,
            expandedHeight: 100.0,
            title: new Text(
              "Accounts",
              style: new TextStyle(
                fontSize: 48.0,
                fontFamily: "Algerian",
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          new SliverFillRemaining(
            child: new Container(
                padding: new EdgeInsets.all(0.0),
                child: new FutureBuilder(
                  future: fetchPost(),
                  builder: (context, snapshot) {
                    var parsed = snapshot.data;
                    if (snapshot.hasData) {
                      if (parsed != null) {
                        return new Container(
                          child: new ListView.builder(
                            itemExtent: 100.0,
                            itemCount: parsed.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Card(
                                child: new ExpansionTile(
                                  title:
                                      new Text(parsed[index]["usn"].toString()),
                                  leading: new Icon(Icons.accessibility),
                                  initiallyExpanded: false,
                                  trailing: new Text(
                                      parsed[index]["identity"].toString()),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return new Text("");
                      }
                    } else if (snapshot.hasError) {
                      return new Text(snapshot.toString());
                    }

                    // By default, show a loading spinner
                    return new Center(
                      child: new Column(
                        children: <Widget>[
                          new LinearProgressIndicator(),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _accountsPage(context) {
    return new Scaffold(
      //key: _scaffoldstate,
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        //title: new Text(name),
        actions: <Widget>[
          new CircleAvatar(
            backgroundImage: new NetworkImage(
                "http://3.bp.blogspot.com/-zqhwSssP4nk/UmPyIZFyDjI/AAAAAAAAAS0/0zmB1FvSAIk/s1600/Joker-Desktop-HD-Wallpaper.jpg"),
          ),
        ],
      ),
      body: _accountsBody(),
    );
  }

  Widget _societyPage(context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text(name),
      ),
    );
  }

  Widget _newsletterPage(context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
    );
  }

  Scaffold _staffPage(context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
    );
  }

  Scaffold _bookingPage(context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
    );
  }

  Scaffold _ContactsPage(context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
    );
  }

  Scaffold _vendorsPage(context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(name),
      ),
    );
  }

  Widget _securityPage(context) {
    Response response = LoginResponse;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Visitors",
          style: new TextStyle(letterSpacing: 1.5),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Add new data",
        backgroundColor: Colors.lightBlueAccent,
        child: new Icon(Icons.add),
        onPressed: () => Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new SecuAddPage())),
      ),
      body: new Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("graphics/login.jpg"), fit: BoxFit.fill),
          ),
          child: new AsyncLoader(
              initState: ({parsed}) async => await fetchPost(),
              renderLoad: () {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              },
              renderError: ([error]) =>
                  new Text('There was an error loading, Please try again!'),
              renderSuccess: ({data}) {
                //parsed = data;
                if (parsed.length != null) {
                  return new Container(
                    child: new RefreshIndicator(
                      onRefresh: fetchPost,
                      child: new ListView.builder(
                        itemExtent: 100.0,
                        itemCount: parsed.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            child: new ListTile(
                              title: new Text(parsed[index]["Name"].toString()),
                              subtitle: new Text(
                                  parsed[index]["MobileNumber"].toString()),
                              leading:
                                  new Text(parsed[index]["Unit"].toString()),
                              trailing: new Text(
                                  parsed[index]["Date"].toString() +
                                      "\n" +
                                      parsed[index]["Time"].toString()),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return new Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new AssetImage("graphics/login.jpg"),
                          fit: BoxFit.fill),
                    ),
                    padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.13,
                      right: MediaQuery.of(context).size.width * 0.13,
                    ),
                  );
                }
              })),
    );
  }

  Future<Null> refreshPost() async {
    fetchPost();
  }

  Future<Null> fetchPost() async {
    const TIMEOUT = const Duration(seconds: 3);
    var jsoncodec = const JsonCodec();
    var Json = {"Name": "Arun"};
    var json = jsoncodec.encode(Json);

    var url = "http://arunva28.pythonanywhere.com/security/security/";

    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "cookie": sessionID.toString()
    });
    print(response.body);

    var responseJson = jsoncodec.decode(response.body);

    parsed = responseJson;

    //return responseJson;
  }
}

class SecuAddPage extends StatefulWidget {
  @override
  _SecuAddPageState createState() => new _SecuAddPageState(currentUser);
}

class _SecuAddPageState extends State<SecuAddPage> {
  var _groupValue;
  final CurrentUser currentUser;

  _SecuAddPageState(@required this.currentUser);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        title: new Text("Add new Visitor"),
      ),
      body: new Container(
        child: new Visitor(),
      ),
    );
  }
}

class Visitor extends StatelessWidget {
  BuildContext context;

  var jsoncodec = const JsonCodec();
  static TextEditingController _name = new TextEditingController();
  static TextEditingController _unit = new TextEditingController();
  static TextEditingController _mobile = new TextEditingController();
  static TextEditingController _email = new TextEditingController();
  static TextEditingController _meeting = new TextEditingController();
  static TextEditingController _refno = new TextEditingController();
  static TextEditingController _remarks = new TextEditingController();

  var visitorName = _name.text.toString();
  var unitName = _unit.text.toString();
  var mobileNo = _mobile.text.toString();
  var emailID = _email.text.toString();
  var meetingperson = _meeting.text.toString();
  var remarks = _remarks.text.toString();

  Future<Null> _selectDate(BuildContext context) async {
    _date = DateTime.now();
    final DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2017),
        lastDate: new DateTime(2030));

    if (datePicked != null && datePicked != _date) {
      _date = datePicked;
      print(_date);

      print("date is " + _date.year.toString());
      print("month is " + _date.month.toString());
      print("day is " + _date.day.toString());

      _dateForClass = _date.year.toString() +
          "-" +
          _date.month.toString() +
          "-" +
          _date.day.toString();

      print(_dateForClass);

      _selectTime(context);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    _time = TimeOfDay.now();
    final TimeOfDay timePicked =
        await showTimePicker(context: context, initialTime: _time);

    if (timePicked != null && timePicked != _date) {
      _time = timePicked;

      var hour = _time.hour;
      var minute = _time.minute;
      var second = 00;

      _timeForClass =
          (hour.toString() + ":" + minute.toString() + ":" + second.toString());
      print(_timeForClass);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("graphics/wallpaper.jpg"), fit: BoxFit.fill),
      ),
      height: double.infinity,
      width: double.infinity,
      padding: new EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      child: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Padding(padding: new EdgeInsets.only(top: 30.0)),
            new TextFormField(
              style: new TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              controller: _name,
              decoration: new InputDecoration(
                labelStyle: new TextStyle(color: Colors.white),
                labelText: "Enter a name",
              ),
            ),
            new TextFormField(
              textAlign: TextAlign.center,
              controller: _unit,
              style: new TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                labelText: "Enter a unit",
                labelStyle: new TextStyle(color: Colors.white),
              ),
            ),
            new TextFormField(
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.center,
              controller: _mobile,
              style: new TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                labelText: "Enter a mobile number",
                labelStyle: new TextStyle(color: Colors.white),
              ),
            ),
            new TextFormField(
              textAlign: TextAlign.center,
              controller: _email,
              style: new TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                labelText: "Enter an email ID",
                labelStyle: new TextStyle(color: Colors.white),
              ),
            ),
            new TextFormField(
              textAlign: TextAlign.center,
              controller: _meeting,
              style: new TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                labelText: "Person meeting mail ID",
                labelStyle: new TextStyle(color: Colors.white),
              ),
            ),
            new TextFormField(
              textAlign: TextAlign.center,
              controller: _remarks,
              style: new TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                labelText: "Remarks",
                labelStyle: new TextStyle(color: Colors.white),
              ),
            ),
            new Container(
              padding: new EdgeInsets.only(top: 4.0, bottom: 8.0),
            ),
            new Padding(padding: new EdgeInsets.only(top: 20.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new FlatButton(
                  child: new Text(
                    "Date and Time?",
                    style:
                        new TextStyle(color: Colors.lightBlue, fontSize: 18.0),
                  ),
                  onPressed: () {
                    _dismissKeyboard(context);
                    _selectDate(context);
                  },
                ),
                new FloatingActionButton(
                  backgroundColor: Colors.lightBlueAccent,
                  child: new Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _addUser(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future _addUser(BuildContext context) async {
    if (_date.isAtSameMomentAs(DateTime.now())) {
      _date = new DateTime(
          _date.year, _date.month, _date.day, _time.hour, (_time.minute + 5));
    }

    var jsoncodec = const JsonCodec();
    var Json = SecurityUserJson(visitorName, unitName, remarks, emailID,
        mobileNo, meetingperson, _dateForClass, _timeForClass);

    var json = jsoncodec.encode(Json);
    print(json);
    var url = "http://arunva28.pythonanywhere.com/security/security/";

    Response response = await http.post(url, body: json, headers: {
      "Content-Type": "application/json",
      "cookie": sessionID.toString()
    });

    print(response.statusCode);
    //print(response.body);

    if (response.statusCode == 201) {
      showSnackBar("Successful!", context);
      _date = DateTime.now();
      _name.clear();
      _remarks.clear();
      _mobile.clear();
      _email.clear();
      _meeting.clear();
      _unit.clear();
      _refno.clear();
      _time = TimeOfDay.now();

      var responseJson = jsoncodec.decode(response.body);
      return responseJson;
    } else {
      showSnackBar(response.body.toString(), context);
      return null;
    }
  }

  void showSnackBar(String value, BuildContext context) {
//    _detailedScaffoldState.currentState.showSnackBar(new SnackBar(
//      content: new Text(value),
//    ));

    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }
}
