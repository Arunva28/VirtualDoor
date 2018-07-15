import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:virtualdoor/UnitsPage.dart';
import 'package:virtualdoor/UpdatePasswordPage.dart';
import 'package:virtualdoor/detailedPage.dart';
import 'package:virtualdoor/loginPage.dart';
import 'package:virtualdoor/userjson.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final CurrentUser currentUser;
  final Response response;

  Response getResponse() {
    return this.response;
  }

  MyHomePage({Key key, @required this.currentUser, @required this.response})
      : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(currentUser, response);
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _homePagestate =
      new GlobalKey<ScaffoldState>();
  final CurrentUser currentUser;
  final response;
  _MyHomePageState(@required this.currentUser, @required this.response);
  List<Container> homePageItems = new List();

  var homepagelistnames = [
    {"name": "Accounts", "value": "accounts.png"},
    {"name": "Society", "value": "society.png"},
    {"name": "Newsletters", "value": "newsletter.png"},
    {"name": "Staff", "value": "staff.png"},
    {"name": "Booking", "value": "booking.png"},
    {"name": "Contacts", "value": "contacts.png"},
    {"name": "Vendors", "value": "vendors.png"},
    {"name": "Security", "value": "security.png"}
  ];

  _namelist() async {
    for (var i = 0; i < homepagelistnames.length; ++i) {
      final homepageitemslist = homepagelistnames[i];
      final String imagevalue = homepageitemslist["value"];

      homePageItems.add(
        new Container(
          //padding: new EdgeInsets.all(0.0),
          child: new GridTile(
            child: new Container(
              margin: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(),
              //padding: new EdgeInsets.all( 8.0),
              child: new Column(
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.only(top: 10.0)),
                  new Hero(
                    tag: homepageitemslist["name"],
                    child: new InkWell(
                        onTap: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new DetailPage(
                                      name: homepageitemslist["name"],
                                      value: imagevalue,
                                    ))),
                        child: new Image.asset(
                          "graphics/$imagevalue",
                          fit: BoxFit.fill,
                        )),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new FlatButton(
                        child: new Text(
                          homepageitemslist["name"],
                          style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new DetailPage(
                                      name: homepageitemslist["name"],
                                      value: imagevalue,
                                    ))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text("Overview"),
          backgroundColor: Colors.lightBlueAccent,
        ),
        drawer: new Drawer(
            child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(currentUser.unitNo.toString() +
                  "   " +
                  currentUser.buildingName.toString()),
              accountEmail: new Text(currentUser.emailID.toString()),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("graphics/background.jpg"),
                    fit: BoxFit.fill),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    "http://www.psdgraphics.com/file/user-icon.jpg"),
              ),
            ),
            new ListTile(
              title: new Text("Dashboard"),
              trailing: new Icon(Icons.dashboard),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              title: new Text("Complaints"),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: new Icon(Icons.assignment_late),
            ),
            new ListTile(
              title: new Text("Units"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new UnitsPage(
                              currentUser: currentUser,
                            )));
              },
              trailing: new Icon(Icons.format_list_numbered),
            ),
            new ListTile(
              title: new Text("Update Password"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new UpdatePasswordPage(
                              currentUser: currentUser,
                            )));
              },
              trailing: new Icon(Icons.thumbs_up_down),
            ),
            new ListTile(
              title: new Text("Sign Out"),
              onTap: () {
                Navigator.pop(context);
                //showSnackBar("Logging Out", context);
                _signout();
              },
              trailing: new Icon(Icons.power_settings_new),
            ),
          ],
        )),
        body: new AsyncLoader(
            initState: ({data}) async => await _namelist(),
            renderLoad: () => new LinearProgressIndicator(),
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
                    return new GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        addRepaintBoundaries: true,
                        shrinkWrap: true,
                        primary: true,
                        children: homePageItems);
                  },
                ),
              );
            }));
  }

  Future _fetchsignout() async {
    var url = "http://arunva28.pythonanywhere.com/user_info/logout/";
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    //await new Future.delayed(const Duration(seconds: 1));

    print(response.body);
  }

  void showSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(value),
        ));
  }

  _signout() async {
    _fetchsignout();

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage(
              //title: "Login Page",
              ),
          fullscreenDialog: true,
        ));

    //Navigator.pop(context);
  }

  Future waitsetstate() async {
    await new Future.delayed(const Duration(seconds: 10));
  }
}
