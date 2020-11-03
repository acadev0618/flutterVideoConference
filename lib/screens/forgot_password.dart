
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bTalker_Guide/screens/login.dart';
import '../config/app_config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  RegExp exp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  void submit() async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}forgot-password';
    final client = new http.Client();
    print('url: $url');

    if (validation()) {
      final response = await client.post(
        url,
        body: {
          "email" : _emailController.text,
          "password" : _passwordController.text
        }
      );
      print('reponsebody: ${response.body.toString()}');
      setState(() {
        isLoading = false;
      });
      if (json.decode(response.body)['error'] == null) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      } else {
        if (json.decode(response.body)['error']['message'] != null) {
          Flushbar(
            message: json.decode(response.body)['error']['message'],
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
    if (_emailController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillEmailField,
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
    if (_passwordController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillPasswordField,
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
    if (_passwordController.text.length < 6) {
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
    if (!exp.hasMatch(_emailController.text)) {
      Flushbar(
        message: S.of(context).enterValidEmailAddress,
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
    return true;
  }

  Widget getBackButton() {
    return Container(
      padding: EdgeInsets.only(top: config.App(context).appHeight(4)),
      alignment: Alignment.bottomLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 5,),
            getBackButton(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text(S.of(context).forgotPassword, style: TextStyle(color: Color.fromRGBO(29, 98, 133, 1),fontSize: 30,fontWeight: FontWeight.w800),),
                  SizedBox(height: 40,),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: S.of(context).emailAddress,
                      hintText: S.of(context).enterYourEmailAddress
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: S.of(context).password,
                      hintText: S.of(context).enterYourPassword
                    ),
                  ),
                  SizedBox(height: 100,),

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
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}