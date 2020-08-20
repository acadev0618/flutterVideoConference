import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './setting.dart';

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

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController roomController = new TextEditingController();
  bool isLoading = false;

  String username = "Speaker1";
  String email = "speaker@gmail.com";
  String subject ="Guid.fm for Speaker";
  final String baseUrl = 'http://5.189.191.243/api/';


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
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('username')) {
        username = prefs.getString('username');
      }
      if (prefs.containsKey('email')) {
        email = prefs.getString('email');
      }
      if (prefs.containsKey('subject')) {
        subject = prefs.getString('subject');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

Future deleteRoom(String name) async {    
    final String url = baseUrl + 'deleteRoom';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: {"room_name" : name}
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('${json.decode(response.body)['message'].toString()}'),
        ));
      });
      print('result: ${json.decode(response.body)['message'].toString()}');
    }
  }


  Future createRoom(String name) async {    
    final String url = baseUrl + 'createRoom';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: {"room_name" : name}
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('${json.decode(response.body)['message'].toString()}'),
        ));
        if (json.decode(response.body)['message'].toString() != "Something went wrong.") {
          _joinMeeting(name);
        }
      });
      print('result: ${json.decode(response.body)['message'].toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
              controller: roomController,
              decoration: InputDecoration(
                labelText: 'Channel Name'
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () {
                if (roomController.text != "") {
                  setState(() {
                    isLoading = true;
                  });
                  createRoom(roomController.text);
                } else {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Please fill this field!'),
                  ));
                }
              },
              child: isLoading ? CircularProgressIndicator()
              : Text('Create Channel', style: TextStyle(fontSize: 16)),
            ),
          ],
        )
      ),
    );
  }
    
  _joinMeeting(String room) async {
    String serverUrl = "https://jitsi.guidyo.net";
        //serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {

      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags =
      {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED : false,
        FeatureFlagEnum.ADD_PEOPLE_ENABLED : false,
        FeatureFlagEnum.CALENDAR_ENABLED : false,
        FeatureFlagEnum.CHAT_ENABLED : false,
        FeatureFlagEnum.INVITE_ENABLED : false,
        FeatureFlagEnum.IOS_RECORDING_ENABLED : false,
        FeatureFlagEnum.LIVE_STREAMING_ENABLED : false,
        FeatureFlagEnum.RAISE_HAND_ENABLED : false,
        FeatureFlagEnum.RECORDING_ENABLED : false,
        FeatureFlagEnum.TILE_VIEW_ENABLED : false,
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
        ..room = room
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

            deleteRoom(options.room);
            debugPrint("${options.room} terminated with message: $message");
            
          }),
          // by default, plugin default constraints are used
          //roomNameConstraints: new Map(), // to disable all constraints
          //roomNameConstraints: customContraints, // to use your own constraint(s)
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
