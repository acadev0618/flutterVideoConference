
import 'dart:convert';

import 'package:bTalker_Guide/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bTalker_Guide/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart' as config;
import 'package:http/http.dart' as http;
import './mydetail.dart';
import './change_password.dart';
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  String token;
  List<Language> languages = new List<Language>();
  Language selectedlanguage ;
  String currentlanguageid;
  int currentindex = 0;
  String currentLanguageName;

  @override
  void initState() {
    getData();
    setLanguage();
    super.initState();
  }

  void setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('user_token');
      currentLanguageName = prefs.getString('language');
      print('currentLanguageName: $currentLanguageName');
      if (currentLanguageName == "English") {
        S.load(Locale('en','EN'));
      }
      if (currentLanguageName == "Turkish") {
        S.load(Locale('tk','TK'));
      }
    });
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = '${GlobalConfiguration().getString('api_base_url')}languages?page=1&per_page=1000';
    final client = new http.Client();
    print('url: $url');
    print('currentuser: ${prefs.getString('current_user')}');

    setState(() {
      token = prefs.getString('user_token');
      currentlanguageid = json.decode(prefs.getString('current_user'))['language_id'].toString();
    });

    final response = await client.get(url, headers: {'Authorization': 'Bearer $token'});
    if (json.decode(response.body)['data'] != null) {
      setState(() {
        for(int i = 0; i < json.decode(response.body)['data']['data'].length; i++) {
          if (json.decode(response.body)['data']['data'][i]['id'] == int.parse(currentlanguageid)) {
            currentindex = i;
          }
          languages.add(Language(json.decode(response.body)['data']['data'][i]['id'], json.decode(response.body)['data']['data'][i]['name']));
        }
      });
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
    setState(() {
      isLoading = false;
    });
    print('reponsebody: ${response.body.toString()}');
    print('languages: ${languages.toString()}');
    print('selectedlanguage_name: ${languages[0].name}');
    print('index: ${currentindex.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).profileSettings, style: TextStyle(fontSize: 20),),
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text(S.of(context).account, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),

              // Change Pasword button
              Container(
                height: 50,
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MyDetail(),
                    ));
                  },
                  child: Text(
                    S.of(context).myDetails,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                    )
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Text(S.of(context).security, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),

              // Change Pasword button
              Container(
                height: 50,
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
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ));
                  },
                  child: Text(
                    S.of(context).changePassword,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                    )
                  ),
                ),
              ),
              // SizedBox(height: 30,),

              // Text(S.of(context).language, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              // SizedBox(height: 27,),

              // // Languages
              // isLoading ? Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.blue)))
              // : DropdownButtonFormField<Language>(
              //   value: languages[currentindex],
              //   decoration: InputDecoration(
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: config.HexColor('#1D6285')),
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: config.HexColor('#1D6285'), width: 1.0),
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     ),
              //     contentPadding: EdgeInsets.only(left: 10)
              //   ),
              //   onChanged: (Language newValue) async {
              //     SharedPreferences prefs = await SharedPreferences.getInstance();
              //     setState(() {
              //       selectedlanguage = newValue;
              //       if (selectedlanguage.name == "English") {
              //         S.load(Locale('en','EN'));
              //       }
              //       if (selectedlanguage.name == "Turkish") {
              //         S.load(Locale('tk','TK'));
              //       }
              //     });
              //     await prefs.setString('language', selectedlanguage.name);
              //   },
              //   items: languages.map((Language language) {
              //     return new DropdownMenuItem<Language>(
              //       value: language,
              //       child: new Text(
              //         language.name,
              //         style: new TextStyle(color: Colors.black),
              //       ),
              //     );
              //   }).toList(),
              // ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      )
    );
  }
}