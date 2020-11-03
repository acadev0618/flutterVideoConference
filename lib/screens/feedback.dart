import 'dart:convert';
import 'dart:core';

import 'package:bTalker_Guide/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  TextEditingController _subjectController = new TextEditingController();
  TextEditingController _messageController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String token;
  String userid;

  void submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('user_token');
      userid = json.decode(prefs.getString('current_user'))['id'].toString();
    });
    final String url = '${GlobalConfiguration().getString('api_base_url')}feedbacks';
    final client = new http.Client();
    print('url: $url');
    print('token: $token');
    print('userid: $userid');

    if (validation()) {
      final response = await client.post(
        url,
        headers: {
          "Authorization" : "Bearer $token"
        },
        body: {
          "user_id" : userid,
          "subject" : _subjectController.text,
          "message" : _messageController.text
        }
      );
      print('reponsebody: ${response.body.toString()}');
      setState(() {
        isLoading = false;
      });
      if (json.decode(response.body)['success']) {
        Flushbar(
          message: S.of(context).successfullySubmittedYourFeedback,
          flushbarPosition: FlushbarPosition.TOP,
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
            ),
          duration: Duration(seconds: 4),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      } else {
        if (json.decode(response.body)['error']['message'] != null) {
          Flushbar(
            message: "json.decode(response.body)['error']['message']",
            flushbarPosition: FlushbarPosition.TOP,
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
              ),
            duration: Duration(seconds: 4),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
        } else {
          Flushbar(
            message: S.of(context).somethingWentWrong,
            flushbarPosition: FlushbarPosition.TOP,
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
              ),
            duration: Duration(seconds: 4),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }  
  }

  validation() {
    if (_subjectController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillSubjectField,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
          ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      return false;
    }
    if (_messageController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillMessageField,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
          ),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).feedback), 
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Home(),
            ));
          },
          child: Icon(Icons.arrow_back),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                config.HexColor('#1D6285'),
                config.HexColor('#27ADDE'),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 60,),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: S.of(context).subject,
                hintText: S.of(context).enterFeedbackSubject
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: _messageController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: S.of(context).message,
              ),
            ),
            SizedBox(height: 60,),

            // Submit button
            Container(
              height: 51,
              width: config.App(context).appWidth(100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(29, 98, 133, 1), 
                    Color.fromRGBO(39, 173, 222, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  submit();
                },
                child: isLoading ? Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.white)))
                : Text(
                  S.of(context).submit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      )
    );
  }
}