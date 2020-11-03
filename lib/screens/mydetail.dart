import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:bTalker_Guide/screens/select_pick_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
import 'package:image/image.dart' as Img;
import 'package:flushbar/flushbar.dart';
import 'package:bTalker_Guide/locale/app_localization.dart';

class MyDetail extends StatefulWidget {
  @override
  _MyDetailState createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {

  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  RegExp exp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  File profileFile;
  Map currentUser;
  List<Language> languages = new List<Language>();
  Language selectedlanguage ;
  String currentlanguageid;
  int currentindex = 0;
  String token;
  bool isLoading = false;
  bool isLoadinglanguages = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      isLoadinglanguages = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = '${GlobalConfiguration().getString('api_base_url')}languages?page=1&per_page=1000';
    final client = new http.Client();
    print('url: $url');
    currentUser = json.decode(prefs.getString('current_user'));
    print('currentUser: ${currentUser.toString()}');
    print('phone: ${currentUser['phone']}');

    setState(() {
      token = prefs.getString('user_token');
      _fullnameController.text = currentUser['full_name'];
      _usernameController.text = currentUser['username'];
      _emailController.text = currentUser['email'];
      _phoneController.text = currentUser['phone'].toString();
      _countryController.text = currentUser['country'];
      _cityController.text = currentUser['city'];
      currentlanguageid = currentUser['language_id'].toString();
    });

    final response = await client.get(url, headers: {'Authorization': 'Bearer $token'});
    print('reponsebody: ${response.body.toString()}');
    setState(() {
      isLoadinglanguages = false;
    });
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
    print('languages: ${languages.toString()}');
    print('index: ${currentindex.toString()}');
  }

  void _chooseprofilemage(BuildContext context) async {
    File file;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectionPickMode()),
    );
    if (result != null) {
      file = await ImagePicker.pickImage(source: result == 'gallery' ? ImageSource.gallery : ImageSource.camera, maxHeight: 500, maxWidth: 500, imageQuality: 88);
    } else {
      return;
    }
    print('file.path: '+file.path);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        showCropGrid: false,
        toolbarColor: config.HexColor('#1D6285'),
        toolbarTitle: S.of(context).profilePhoto,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
    if (croppedFile != null) {
      setState(() {
        profileFile = croppedFile;
      });
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    print('imageUrl: $imageUrl');
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + 'photo' + (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(imageUrl);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
  
  void submit() async {
    String language_id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = '${GlobalConfiguration().getString('api_base_url')}edit-profile';
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    print('url: $url');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };

    if (validation()) {
      var stream_photo, length_photo, multipartFile;
      if (profileFile != null || currentUser['photo'] != null) {
        if (profileFile == null) {
          print('right');
          profileFile = await urlToFile(currentUser['photo']);
        }
        Img.Image imagetemp = Img.decodeImage(profileFile.readAsBytesSync());
        if (imagetemp.width > 500 || imagetemp.height > 500) {
          imagetemp = Img.copyResize(imagetemp,width: 500, height: 500);
        }
        stream_photo = new http.ByteStream(DelegatingStream.typed(profileFile.openRead()));
        length_photo = await profileFile.length();
        // multipartFile = new http.MultipartFile('photo', stream_photo, length_photo, filename: basename(profileFile.path));
        multipartFile = new http.MultipartFile.fromBytes('photo', Img.encodeJpg(imagetemp), filename: "profile.jpg");
        // print(basename(profileFile.path));
        request.files.add(multipartFile);
      }
      language_id  = selectedlanguage == null ? currentlanguageid.toString() : selectedlanguage.id.toString();
      request.fields['full_name'] = _fullnameController.text;
      request.fields['username'] = _usernameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['country'] = _countryController.text;
      request.fields['city'] = _cityController.text;
      request.fields['language_id'] = language_id;
      request.headers.addAll(headers);
      var response = await request.send();
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) async {
        print('value;');
        if (json.decode(value)['data'] != null) {
          await prefs.setString('current_user', json.encode(json.decode(value)['data']));
          if (language_id == '6') {
            print('Turkish=============================');
            prefs.setString('language', 'Turkish');
            S.load(Locale('tk','TK'));
          }
          if (language_id == '1') {
            print('English=============================');
            prefs.setString('language', 'English');
            S.load(Locale('en','EN'));
          }
          Flushbar(
            message: S.of(context).successfullyUpdatedProfile,
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
        if (json.decode(value)['error'] != null) {
          if (json.decode(value)['error']['message'] == 'Validation Failed') {
            Flushbar(
              message: json.decode(value)['error']['validations'].toString(),
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
      });
      if (response.statusCode == 200) {
        print("success!!!!!!!!!!!!!!!!!!!!!!!!!!");
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }  
  }

  validation() {
    if (_fullnameController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillFullNameField,
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
    if (_usernameController.text == "") {
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
    if (_phoneController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillPhoneNumberField,
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
    if (_countryController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillCountryField,
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
    if (_cityController.text == "") {
      Flushbar(
        message: S.of(context).pleaseFillCityField,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).myDetails), 
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
        child: isLoadinglanguages ? Container(
          height: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation(Colors.blue))),
        )
          : Column(
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                _chooseprofilemage(context);
              },
              child: Container(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    Container(
                      width: 80, height: 80,
                      child: profileFile == null ? currentUser['photo'] == null ? Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Colors.blue[100]
                        ),
                        child: Icon(Icons.photo_camera, size: 40,)
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network('${currentUser['photo']}', fit: BoxFit.fill,)
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.file(profileFile, fit: BoxFit.fill)
                      ),
                    ),
                    Positioned(
                      top: 0, right: 0,
                      child: Icon(Icons.edit, color: Colors.blueAccent,size: 20,),
                    )
                  ],
                )
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration(
                labelText: S.of(context).fullName,
                hintText: S.of(context).enterYourFullName
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: S.of(context).username,
                hintText: S.of(context).enterYourUsername
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: S.of(context).emailAddress,
                hintText: S.of(context).enterYourEmailAddress
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: S.of(context).phoneNumber,
                hintText: S.of(context).enterYourPhoneNumber
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: S.of(context).country,
                hintText: S.of(context).enterYourCountry
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: S.of(context).city,
                hintText: S.of(context).enterYourCity
              ),
            ),
            SizedBox(height: 10,),
            DropdownButtonFormField<Language>(
              value: languages[currentindex],
              decoration: InputDecoration(
                labelText: S.of(context).language
              ),
              onChanged: (Language newValue) {
                setState(() {
                  selectedlanguage = newValue;
                });
              },
              items: languages.map((Language language) {
                return new DropdownMenuItem<Language>(
                  value: language,
                  child: new Text(
                    language.name,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30,),

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

class Language {
  const Language(this.id,this.name);

  final String name;
  final int id;
}