import 'package:flutter/material.dart';
import '../config/app_config.dart' as config;
import 'package:bTalker_Guide/locale/app_localization.dart';

class SelectionPickMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(140, 140, 140, 1),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: Icon(Icons.close, color: Colors.white,),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(100)/2-55,
            child: Container(
              height: 45,
              width: config.App(context).appWidth(100),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 45,
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
                    Navigator.pop(context, 'gallery');
                  },
                  child: Text(
                    S.of(context).pickFromGallery,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )
                  ),
                ),
              ),
            )
          ),
          Positioned(
            top: config.App(context).appHeight(100)/2+10,
            child: Container(
              height: 45,
              width: config.App(context).appWidth(100),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 45,
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
                    Navigator.pop(context, 'camera');
                  },
                  child: Text(
                    S.of(context).pickFromCamera,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}