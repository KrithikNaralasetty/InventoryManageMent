import 'package:flutter/material.dart';
import 'package:inventory_manage/Data/APIs.dart';
import './loginpage.dart';
import 'package:permission_handler/permission_handler.dart';
import './Caching.dart' as cache;
// ignore: unused_import
import 'package:json_to_form/json_to_form.dart';
import 'package:inventory_manage/Data/TablesData.dart' as data;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

Future getPermission() async {
  cache.saveValue("qrData", "");
  cache.saveValue("recordData", "");
  cache.saveValue("machineData", "");
  var x = await api.getData();
  var status = await Permission.camera.request();
  Map<Permission, PermissionStatus> sts = await [
    Permission.storage,
  ].request();
  final info = sts[Permission.storage];
  if (status.isGranted && info.isGranted) {
    return true;
  } else
    return false;
}

class MyApp extends StatelessWidget {
  var recordData, machineData, qrData;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: getPermission(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              cache.getValue("qrData").then((data) {
                qrData = data;
              });
              cache.getValue("machineData").then((data) {
                machineData = data;
              });
              cache.getValue("recordData").then((data) {
                recordData = data;
              });
              if (machineData != "") {
                var response = api.putTemplate(json.encode(machineData));
                print("$response");
                cache.saveValue("qrData", response.toString());
              }
              if (recordData != "") {
                var response = api.putRecord(json.encode(recordData));
                print("$response");
              }
              return IntroAnimation();
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      Text("Please wait for a few moment"),
                      CircularProgressIndicator(color: Colors.black,),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class IntroAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IntroAnimationState();
  }
}

class IntroAnimationState extends State<IntroAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 3,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 75.0,
                backgroundColor: Color(0xFFffe5b4),
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.black,
                  size: 100.0,
                ),
              ),
              Container(
                child: Text(
                  "You record, \nWe simplify",
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                ),
                padding: EdgeInsets.only(top: 20),
              ),
              Container(
                height: 80.0,
              ),
              Center(
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  },
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 70,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF00003f),
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        child: Text(
          "Lets Get Started",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        padding: EdgeInsets.only(top: 25.0, left: 25.0),
      );
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
