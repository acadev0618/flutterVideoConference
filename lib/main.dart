import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/setting.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Broadcast'),
        actions: [
          Container(
            height: MediaQuery.of(context).padding.top,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right:20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Settings(),
                ));
              },
              child: Text('Setting', style: TextStyle(fontSize: 15)),
            ),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 100,),
            Text(
              'Guid.fm for Speaker',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              decoration: InputDecoration(
                labelText: 'Channel Name'
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () {},
              child: const Text('Create Channel', style: TextStyle(fontSize: 16)),
            ),
          ],
        )
      ),
    );
  }
}
