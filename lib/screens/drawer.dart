import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bTalker_Guide/screens/home.dart';
import 'package:bTalker_Guide/screens/login.dart';
import 'package:bTalker_Guide/screens/profile.dart';
import 'package:bTalker_Guide/screens/channel_setting.dart';
import 'package:bTalker_Guide/screens/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class AppDrawer extends StatefulWidget {
  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer> {

  Map currentUser;
  String photo = '';
  String fullname = '';
  bool isloading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = json.decode(prefs.getString('current_user'));
      photo = currentUser['photo'];
      fullname = currentUser['full_name'];
    });
    print('currentUser: ${currentUser.toString()}');
    setState(() {
      isloading = false;
    });
  }

  void removeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove('user_token');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return isloading ? Container(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.blue))))
      : Container(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 185,
              child: DrawerHeader(
                child: Container(
                  height: 185,
                  width: 250,
                  child: Column(
                    children: [
                      photo != null ? Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network('$photo', fit: BoxFit.fill)
                        ),
                      ) : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: Colors.red[300]
                        ),
                        child: Center(child: Text('${fullname[0].toUpperCase()}', style: TextStyle(fontSize: 30),)),
                      ),
                      SizedBox(height: 10,),
                      Text('$fullname', style: TextStyle(fontSize: 14),)
                    ],
                  ),
                )
              ),
            ),
            ListTile(
              title: Text(S.of(context).menu, style: TextStyle(color: Colors.black54),),
              onTap: () {},
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.home),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).home),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Home(),
                ));
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.person),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).profileSettings),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Profile(),
                ));
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.playlist_add_check),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).channelSettings),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChannelSettings(),
                ));
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.star),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).feedback),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FeedbackScreen(),
                ));
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.work),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).privacyRules),
                  )
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.poll),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).terms),
                  )
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.book),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).about),
                  )
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.input),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(S.of(context).logout),
                  )
                ],
              ),
              onTap: () {
                removeSession();
              },
            ),
          ],
        ),
      ),
    );
  }
}