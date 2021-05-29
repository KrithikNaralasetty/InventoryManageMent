import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:inventory_manage/Data/APIs.dart';
import 'package:inventory_manage/recordspage.dart';
import 'package:inventory_manage/trono/main.dart';
import './addmachinepage.dart';

import 'package:qrscan/qrscan.dart' as scanner;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String _username;
  String _password;

  HomePage(this._username, this._password);
  @override
  State<StatefulWidget> createState() {
    return HomePageState(_username, _password);
  }
}

class HomePageState extends State<HomePage> {
  String _username;
  String _password;
  TextEditingController tname = new TextEditingController();

  HomePageState(this._username, this._password);
  @override
  void initState() {
    super.initState();
  }

  String barcode = "MyQRCode";

  Future _qrscan(BuildContext context) async {
    try {
      String barcode = await scanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == scanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
    Navigator.push(context,MaterialPageRoute(builder: (context){
      return  RecordsPage(_username, _password, barcode);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(accountName: Text(this._username),accountEmail: Text(""),),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.arrow_right,color: Colors.black,),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: () async {
            var x = await api.getData();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return HomePage(_username, _password);
            }));
          },icon: Icon(Icons.replay_outlined,color: Colors.black,),)
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: 70.0,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(seconds: 2),
              child: InkWell(
                onTap: (){_qrscan(context);},
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF00003f),
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0, 12.0),
                            color: Colors.grey,
                            blurRadius: 25.0)
                      ]),
                  width: 300,
                  height: 250,
                  child: Center(
                    child: Text(
                      "Scan QR Code",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeIn,
              child: InkWell(
                child: Container(
                  child: Center(
                    child: Text(
                      "Add New Machine",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color(0xFFffe5b4),
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0, 8.0),
                            color: Colors.grey,
                            blurRadius: 25.0)
                      ]),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(
                            name: "HomePage",
                          ),
                          builder: (context) {
                            return MachinePage(_username, _password);
                          }));
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeIn,
              child: InkWell(
                child: Container(
                  child: Center(
                    child: Text(
                      "Add New Template",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color(0xFFffe5b4),
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0, 8.0),
                            color: Colors.grey,
                            blurRadius: 25.0)
                      ]),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Enter Name For Template'),
                          content: TextField(
                            controller: tname,
                            decoration: InputDecoration(hintText: "Car_template"),
                          ),
                          actions: <Widget>[
                            new TextButton(
                              child: new Text('Make Template'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return MyHomePage(title: "Add Template Page",tname: tname.text,);
                                }));

                              },
                            )
                          ],
                        );
                      });

                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
