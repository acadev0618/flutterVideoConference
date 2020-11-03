import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController _oldController = new TextEditingController();
  TextEditingController _newController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool obsecurepwd = true;
  bool obsecureconfirm = true;
  bool obsecureold = true;
  String token;

  void submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('user_token');
    });
    final String url = '${GlobalConfiguration().getString('api_base_url')}change-password';
    final client = new http.Client();
    print('url: $url');

    if (validation()) {
      final response = await client.post(
        url,
        headers: {
          "Authorization" : "Bearer $token"
        },
        body: {
          "old_password" : _oldController.text,
          "password" : _newController.text
        }
      );
      print('reponsebody: ${response.body.toString()}');
      setState(() {
        isLoading = false;
      });
      if (json.decode(response.body)['error'] == null) {
        Flushbar(
          message: S.of(context).successfullyUpdatedPassword,
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
        if (json.decode(response.body)['error']['message'] == "Validation Failed") {
          Flushbar(
            message: json.decode(response.body)['error']['validations'].toString(),
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
    if (_oldController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillOldPasswordField,
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
    if (_newController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillNewPasswordField,
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
    if (_newController.text.length < 6) {
      Flushbar(
        message: S.of(context).passwordMustBe6CharactersAtLeast,
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
    if (_confirmController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillConfirmPasswordField,
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
    if (_newController.text != _confirmController.text) {
      Flushbar(
        message: S.of(context).nomatchPasswordandconfirmPassword,
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
        title: Text(S.of(context).changePassword), 
        centerTitle: true,
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
              controller: _oldController,
              obscureText: obsecureold,
              decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecureold = !obsecureold;
                    });
                  },
                  icon: Icon(obsecureold ? Icons.visibility : Icons.visibility_off),
                ),
                labelText: S.of(context).oldPassword,
                hintText: S.of(context).enterYourOldPassword
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _newController,
              obscureText: obsecurepwd,
              decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecurepwd = !obsecurepwd;
                    });
                  },
                  icon: Icon(obsecurepwd ? Icons.visibility : Icons.visibility_off),
                ),
                labelText: S.of(context).newPassword,
                hintText: S.of(context).enterYourNewPassword
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _confirmController,
              obscureText: obsecureconfirm,
              decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecureconfirm = !obsecureconfirm;
                    });
                  },
                  icon: Icon(obsecureconfirm ? Icons.visibility : Icons.visibility_off),
                ),
                labelText: S.of(context).confirmNewPassword,
                hintText: S.of(context).enterYourNewPassword
              ),
            ),
            SizedBox(height: 80,),

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