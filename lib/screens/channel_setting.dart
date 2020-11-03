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

class ChannelSettings extends StatefulWidget {
  @override
  _ChannelSettingsState createState() => _ChannelSettingsState();
}

class _ChannelSettingsState extends State<ChannelSettings> {

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isLoadingDomain = false;
  String token;
  String userid;
  bool check;
  bool isvisible = true;
  int channel_id;
  String channel_name;
  String channel_pwd;
  int domain_id;
  bool isUpdate = false;
  List domainList;
  List<Domain> domains = new List<Domain>();
  Domain selectedDomain ;
  int currentindex;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoadingDomain = true;
      token = prefs.getString('user_token');
      userid = json.decode(prefs.getString('current_user'))['id'].toString();
    });
    final String url = '${GlobalConfiguration().getString('api_base_url')}domains';
    final String urlChannel = '${GlobalConfiguration().getString('api_base_url')}channels/user/$userid?page=1&per_page=1000';
    final client = new http.Client();
    final response = await client.get(
      url,
      headers: {
        "Authorization" : "Bearer $token"
      },
    );
    final responseChannel = await client.get(
      urlChannel,
      headers: {
        "Authorization" : "Bearer $token"
      },
    );
    print('responseChannel: ${responseChannel.body.toString()}');
    print('reponsebody: ${response.body.toString()}');
    setState(() {
      isLoadingDomain = false;
    });
    if (json.decode(responseChannel.body)['success']) {
      if (json.decode(responseChannel.body)['data']['data'].isNotEmpty) {
        setState(() {
          channel_name = json.decode(responseChannel.body)['data']['data'][json.decode(responseChannel.body)['data']['data'].length-1]['name'];
          _nameController.text = channel_name;
          channel_pwd = json.decode(responseChannel.body)['data']['data'][json.decode(responseChannel.body)['data']['data'].length-1]['password'];
          _passwordController.text = channel_pwd;
          channel_id = json.decode(responseChannel.body)['data']['data'][json.decode(responseChannel.body)['data']['data'].length-1]['id'];
          domain_id = json.decode(responseChannel.body)['data']['data'][json.decode(responseChannel.body)['data']['data'].length-1]['domain']['id'];
          if (channel_pwd != null) {
            isvisible = false;
          }
        });
        print('channel_name: $channel_name');
        print('channel_id: ${channel_id.toString()}');
        print('domain_id: ${domain_id.toString()}');
      }
      
    } else {
      if (json.decode(responseChannel.body)['error']['message'] != null) {
        if (json.decode(responseChannel.body)['error']['code'] == 1) {
          Flushbar(
            message: json.decode(responseChannel.body)['error']['validations'].toString(),
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
            message: json.decode(responseChannel.body)['error']['message'],
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
      } else {
        Flushbar(
          message: "Something went wrong!",
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
    if (json.decode(response.body)['success']) {
      setState(() {
        domainList = json.decode(response.body)['data']['data'];
        for(int i = 0; i < domainList.length; i++) {
          if (domain_id != null) {
            if (domainList[i]['id'] == domain_id) {
              currentindex = i;
            }
          }
          domains.add(Domain(domainList[i]['id'], domainList[i]['url']));
        }
      });
      print('domain: ${domainList.toString()}');
      print('domains: ${domains.toString()}');
    } else {
      if (json.decode(response.body)['error']['message'] != null) {
        if (json.decode(response.body)['error']['code'] == 1) {
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
        } else {
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
        }
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
  }

  void submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url; 
    String success_message;
    if (channel_id == null) {
      url = '${GlobalConfiguration().getString('api_base_url')}channels';
      success_message = "Successfully created your channel";
    } else {
      url = '${GlobalConfiguration().getString('api_base_url')}channels/$channel_id';
      success_message = "Successfully updated your channel";
    }
    final client = new http.Client();
    print('url: $url');
    print('token: $token');
    print('userid: $userid');

    if (validation()) {
      domain_id = selectedDomain == null ? domain_id : selectedDomain.id;
      final response = await client.post(
        url,
        headers: {
          "Authorization" : "Bearer $token"
        },
        body: {
          "name" : _nameController.text,
          "slug" : _nameController.text,
          "user_id" : userid,
          "domain_id" : domain_id.toString(),
          "password" : _passwordController.text
        }
      );
      print('reponsebody: ${response.body.toString()}');
      setState(() {
        isLoading = false;
      });
      if (json.decode(response.body)['success']) {
        Flushbar(
          message: success_message,
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
          if (json.decode(response.body)['error']['code'] == 1) {
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
          } else {
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
          }
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
    var i = 0;
    var is_digit = 0;
    var is_letter = 0;
    if (_nameController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillChannelNameField,
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
    check = _nameController.text.contains(' ');
    if (check) {
      Flushbar(
        message: S.of(context).channelNameMustBeOnlyOneWord,
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
    if (_passwordController.text.length != 3) {
      Flushbar(
        message: S.of(context).passwordMustBe3Characters,
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
    while (i < _passwordController.text.length){
      var character = _passwordController.text.substring(i,i+1);      
      if (isDigit(character , 0)){
        is_digit++;
      }else{
        is_letter++;
      }
      i++;
    }
    if (is_digit != 2) {
      Flushbar(
        message: S.of(context).passwordMustBe3Characters,
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
    if (selectedDomain == null && domain_id == null) {
      Flushbar(
        message: S.of(context).pleaseSelectDomain,
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
  bool isDigit(String s, int idx) =>
        "0".compareTo(s[idx]) <= 0 && "9".compareTo(s[idx]) >= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).channelSettings), 
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
      // drawer: AppDrawer(),
      body: isLoadingDomain ? Container(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.blue))))
      : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 60,),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: S.of(context).channelName,
                hintText: S.of(context).enterChannelName
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _passwordController,
              // obscureText: isvisible,
              obscureText: false,
              decoration: InputDecoration(
                labelText: S.of(context).channelPassword,
                hintText: S.of(context).enterChannelPassword
              ),
            ),
            Text(S.of(context).character,
              style: TextStyle(color: Colors.black26),
            ),
            SizedBox(height: 10,),
            DropdownButtonFormField<Domain>(
              value: currentindex != null ? domains[currentindex] : selectedDomain,
              decoration: InputDecoration(
                labelText: S.of(context).domain
              ),
              onChanged: (Domain newValue) {
                setState(() {
                  selectedDomain = newValue;
                });
              },
              items: domains.map((Domain domain) {
                return new DropdownMenuItem<Domain>(
                  value: domain,
                  child: new Text(
                    domain.url,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 60,),

            // Confirm button
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

class Domain {
  const Domain(this.id,this.url);

  final String url;
  final int id;
}