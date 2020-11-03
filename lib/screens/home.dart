import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bTalker_Guide/screens/drawer.dart';
import 'package:bTalker_Guide/screens/login.dart';
import 'package:global_configuration/global_configuration.dart';
import '../setting.dart';
import 'package:http/http.dart' as http;
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart' as config;
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _urlController = new TextEditingController();
  bool isLoading = false;

  String username = "Speaker1";
  String email = "speaker@gmail.com";
  String subject ="Guid.fm for Speaker";
  String serverUrl = "https://meet.jit.si";
  String domainUrl;
  String channelname;
  String _copy;
  String token;
  String userid;
  bool isenagled = true;
  bool isLoadingDomain = false;
  bool isLoadingChannel = false;
  String currentLanguageName;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError
      )
    );
    loadData();
    setLanguage();
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

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map currentUser = json.decode(prefs.getString('current_user'));
    setState(() {
      token = prefs.getString('user_token');
      userid = json.decode(prefs.getString('current_user'))['id'].toString();
      username = currentUser['username'];
      email = currentUser ['email'];
      if (json.decode(prefs.getString('current_user'))['language_id'].toString() == '6') {
        print('Turkish=============================');
        prefs.setString('language', 'Turkish');
        S.load(Locale('tk','TK'));
      }
      if (json.decode(prefs.getString('current_user'))['language_id'].toString() == '1') {
        print('English=============================');
        prefs.setString('language', 'English');
        S.load(Locale('en','EN'));
      }
    });
    print('currentUser: ${json.decode(prefs.getString('current_user'))}');
    final String url = '${GlobalConfiguration().getString('api_base_url')}servers/user/$userid';
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
    print('response: ${response.body.toString()}');
    print('responseChannel: ${responseChannel.body.toString()}');
    if (json.decode(response.body)['success']) {
      if(json.decode(response.body)['data']['data'].isNotEmpty) {
        setState(() {
          serverUrl = json.decode(response.body)['data']['data'][0]['url'];
        });
      }
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
    if (json.decode(responseChannel.body)['success']) {
      if(json.decode(responseChannel.body)['data']['data'].isNotEmpty) {
        setState(() {
          channelname = json.decode(responseChannel.body)['data']['data'][json.decode(responseChannel.body)['data']['data'].length-1]['name'];
          domainUrl = json.decode(responseChannel.body)['data']['data'][json.decode(responseChannel.body)['data']['data'].length-1]['domain']['url'];
          domainUrl = domainUrl + '/' + channelname;
          if (domainUrl != null) {
            _urlController.text = domainUrl;
          }
        });
        print('channelname: $channelname');
        print('domainUrl: $domainUrl');
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
      isLoadingDomain = false;
    });
  }

  void loadChannel() async {
    final String url = '${GlobalConfiguration().getString('api_base_url')}channels/user/$userid?page=1&per_page=1000';
    final client = new http.Client();
    final response = await client.get(
      url,
      headers: {
        "Authorization" : "Bearer $token"
      },
    );
    print('response: ${response.body.toString()}');
    setState(() {
      isLoadingChannel = false;
    });
    if (json.decode(response.body)['success']) {
      if (json.decode(response.body)['data']['data'].isNotEmpty) {
        setState(() {
          channelname = json.decode(response.body)['data']['data'][json.decode(response.body)['data']['data'].length-1]['name'];
        });
        print('channelName: $channelname');
      }
      if (channelname == null) {
        Flushbar(
          message: S.of(context).youHaveToCreateFirstYourChannel,
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
        _joinMeeting();
      }
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

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text(S.of(context).oK),
      onPressed: () {
        SystemNavigator.pop();
      },
    );

    Widget cancleButton = FlatButton(
      child: Text(S.of(context).cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).bTalkerGuide),
      content: Text(S.of(context).areYouSureToClosebTalkerApp),
      actions: [
        okButton,
        cancleButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).bTalkerGuide),
        centerTitle: true,
        actions: [
          Container(
            height: MediaQuery.of(context).padding.top,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right:10.0),
            child: GestureDetector(
              onTap: () {
                showAlertDialog(context);
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => LoginScreen(),
                // ));
              },
              child: Text(S.of(context).exit, style: TextStyle(fontSize: 15)),
            ),
          )
        ],
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
      drawer: AppDrawer(),
      body: isLoadingDomain ? Container(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.blue))))
      : Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 60,),
            RaisedButton(
              onPressed: () {
                setState(() {
                  isLoadingChannel = true;
                });
                loadChannel();
              },
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              color: Colors.red,
              child: isLoadingChannel ? CircularProgressIndicator()
              : Text(S.of(context).start, style: TextStyle(fontSize: 17,color: Colors.white)),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: _urlController,
                enabled: isenagled,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffix: GestureDetector(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: _urlController.text));
                      scaffoldKey.currentState.showSnackBar(
                          new SnackBar(content: new Text(S.of(context).copiedToClipboard),)
                      );
                      // isenagled = false;
                    },
                    child: Text(S.of(context).copy, style: TextStyle(
                      color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500
                    ),),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: config.HexColor('#1D6285')),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: config.HexColor('#1D6285')),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: config.HexColor('#1D6285')),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                  labelText: S.of(context).listenerURL,
                  labelStyle: TextStyle(fontSize: 15)
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
    
  _joinMeeting() async {
        //serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {

      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags =
      {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED : false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid)
      {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      }
      else if (Platform.isIOS)
      {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = channelname
        ..serverURL = serverUrl
        ..subject = subject
        ..userDisplayName = username
        ..userEmail = email
        ..iosAppBarRGBAColor = "#0080FF80"
        ..audioOnly = true
        ..audioMuted = false
        ..videoMuted = true
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(options,
          listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
            debugPrint("${options.room} will join with message: $message");
          }, onConferenceJoined: ({message}) {
            debugPrint("${options.room} joined with message: $message");
          }, onConferenceTerminated: ({message}) {
            debugPrint("${options.room} terminated with message: $message");   
          }),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint> customContraints =
  {
    RoomNameConstraintType.MAX_LENGTH : new RoomNameConstraint(
            (value) { return value.trim().length <= 50; },
            "Maximum room name length should be 30."),

    RoomNameConstraintType.FORBIDDEN_CHARS : new RoomNameConstraint(
            (value) { return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false).hasMatch(value) == false; },
            "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
