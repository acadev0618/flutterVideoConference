
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bTalker_Guide/screens/forgot_password.dart';
import 'package:bTalker_Guide/screens/home.dart';
import 'package:bTalker_Guide/screens/register.dart';
import '../config/app_config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String token;
  String currentLanguage = "English";

  @override
  void initState() {
    super.initState();
    getData();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 120.0, end: 40.0).animate(_controller)
    ..addListener(() {
      setState(() {});
    });

    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();

    super.dispose();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('user_token')) {
        token = prefs.getString('user_token');
      }
      if (prefs.containsKey('language')) {
        currentLanguage = prefs.getString('language');
      }
      if (currentLanguage == "English") {
        S.load(Locale('en','EN'));
      }
      if (currentLanguage == "Turkish") {
        S.load(Locale('tk','TK'));
      }
    });
    if (token != null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Home(),
      ));
    }
  }

  void login() async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}login';
    final client = new http.Client();
    print('url: $url');

    if (validation()) {
      final response = await client.post(
        url,
        body: {
          "username" : _nameController.text,
          "password" : _pwdController.text
        }
      );
      print('reponsebody: ${response.body.toString()}');
      setState(() {
        isLoading = false;
      });
      if (json.decode(response.body)['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user', json.encode(json.decode(response.body)['data']['user']));
        await prefs.setString('user_token', json.decode(response.body)['data']['token']);
        await prefs.setString('language', json.decode(response.body)['data']['user']['language']['name']);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Home(),
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
    if (_nameController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillUsernameField,
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
    if (_pwdController.text == "") {
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
    if (_pwdController.text.length < 6) {
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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              // SizedBox(height: 120,),
              SizedBox(height: _animation.value),
              Text(S.of(context).login, style: TextStyle(color: Color.fromRGBO(29, 98, 133, 1),fontSize: 30,fontWeight: FontWeight.w800),),
              SizedBox(height: 20,),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: S.of(context).username,
                  hintText: S.of(context).enterYourUsername
                ),
                focusNode: _focusNode1,
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _pwdController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context).password,
                  hintText: S.of(context).enterYourPassword
                ),
                focusNode: _focusNode2,
              ),

              //Forgotten password button
              Container(
                padding: EdgeInsets.only(top: 7, right: 0, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ));
                      },
                      child: new Text(
                        S.of(context).forgetPassword,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10),
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: _animation.value),

              //login button
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
                    login();
                  },
                  child: isLoading ? Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.white)))
                  : Text(
                    S.of(context).login,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )
                  ),
                ),
              ),

              //Go to Signup page
              Container(
                padding: EdgeInsets.only(top: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).dontyouHaveAnAccountAlready} ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        )
                      ),
                      TextSpan(
                        text: S.of(context).signupHere,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ));
                          }
                      )
                    ]
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}