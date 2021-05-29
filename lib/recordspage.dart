import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_manage/Data/APIs.dart';
import 'package:inventory_manage/Data/TablesData.dart' as data;
import 'package:inventory_manage/trono/jsonbuilder.dart';
// ignore: unused_import
import 'package:inventory_manage/trono/main.dart';

// ignore: must_be_immutable
class RecordsPage extends StatefulWidget {
  var _username, _password;
  var _qrCode;

  RecordsPage(this._username, this._password, this._qrCode);

  @override
  State<StatefulWidget> createState() {
    return RecordsPageState(_username, _password, _qrCode);
  }
}

class RecordsPageState extends State<RecordsPage> {
  var machineData;
  // ignore: unused_field
  var _username, _password;
  var _qrCode;

  Widget icons = Container(
    decoration: BoxDecoration(
        color: Color(0xFFffe5b4),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0), bottomLeft: Radius.circular(50.0))),
    child: Center(
      child: Icon(
        Icons.menu,
        color: Colors.black,
        size: 90,
      ),
    ),
  );

  RecordsPageState(this._username, this._password, this._qrCode);

  Future _getRecords(String qrCode) async {
    var x = await api.getData();
    if (qrCode == null) {
      qrCode = "6e4b4f53-3f9d-457b-85e0-889f6a5d3097";
    }
    var response = await api.getMachine(qrCode);
    return response;
  }

  Widget getRecordList(var data) {
    Widget l = ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: 200,
          height: 115,
          decoration: BoxDecoration(
              color: Color(0xFFffe5b4),
              borderRadius: BorderRadius.circular(50.0)),
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              //Add a function to display all the details in the file
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                print(data[index]["record"]);
                return JsonBuilder(jsonDecode(data[index]["record"]),
                    isResponse: false);
              }));
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: icons,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Center(
                            child: Text(
                              data[index]["dos"],
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text(
                            data[index]["wid_s"].toString(),
                            style: TextStyle(fontSize: 18.0),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 30.0,
        );
      },
    );
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Records of Machine",
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () async{
            var x = await api.getData();
            setState(() {
            });
          }, icon: Icon(Icons.replay_outlined,color: Colors.black,)),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getRecords(_qrCode),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var response = json.decode(snapshot.data.body);
              var recordData = response["records"];
              var x = [
                {
                  "uid": this._qrCode,
                  "status": "True",
                  "wid_c": " ",
                  "wid_s": " ",
                  "dos": "No Records yet",
                  "doc": " ",
                  "template": " ",
                  "sno": " ",
                }
              ];
              if (recordData == null) {
                recordData = x;
              }
              var machineExists = "false";
              for (var i in data.machines) {
                if (i.uid == this._qrCode) {
                  this.machineData = i;
                  machineExists = "True";
                  break;
                }
              }
              if (machineExists == "false") {
                this.machineData = new data.MachineData({
                  "uid": this._qrCode,
                  "model": "Not A Existing Machine",
                  "brand": "Not A Existing Machine",
                  "sno": "Not A Existing Machine",
                  "tname": "Not A Existing Machine",
                  "doi": "Not A Existing Machine",
                  "eqtype": "Not A Existing Machine",
                });
              }
              var template = "false";
              for (var i in data.templates) {
                if (i.tname == this.machineData.tname) {
                  template = i.template;
                  break;
                }
              }

              return Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 150,
                    left: -130,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Color(0xFF00003f),
                          borderRadius:
                              BorderRadius.all(Radius.circular(600.0))),
                    ),
                  ),
                  Positioned(
                    top: -150,
                    right: -130,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.9,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Color(0xFF06beb6),
                          borderRadius:
                              BorderRadius.all(Radius.circular(600.0))),
                    ),
                  ),
                  Positioned(
                    bottom: -200,
                    left: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Color(0xFFeb3349),
                          borderRadius:
                              BorderRadius.all(Radius.circular(600.0))),
                    ),
                  ),
                  Positioned(
                    right: -190,
                    bottom: 0,
                    height: 300,
                    width: 300,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF7b4397),
                            borderRadius:
                                BorderRadius.all(Radius.circular(300.0))),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Machine Details and Icon
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0.0, 10.0),
                                      color: Colors.grey,
                                      blurRadius: 25.0)
                                ]),
                            padding: EdgeInsets.all(20.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  //Machine Details Column
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text(
                                              "Model of Machine:" +
                                                  this.machineData.model,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MachineDetailsPage(machineData);
                                }));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          flex: 5,
                          child: getRecordList(recordData),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (template.toString() != "null" &&
                                  template.toString().length > 10) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return JsonBuilder(
                                    json.decode(template),
                                    isResponse: true,
                                    uid: _qrCode,
                                    uname: _password,
                                  );
                                }));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("No Such Machine Exists"),
                                        content: Text(
                                            "The QR Code you scanned had no record in the DataBase. Please check with the supervisor"),
                                        actions: [
                                          TextButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(30.0),
                              width: 200,
                              child: Center(
                                child: Text("Add Record",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20.0)),
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xFFc4e0e5),
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.0, 6.0),
                                      color: Colors.black,
                                      blurRadius: 10.0,
                                    )
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  ),
                ],
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                  ),
                ),
              );
            }
          },
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}

// ignore: must_be_immutable
class MachineDetailsPage extends StatelessWidget {
  var machineData;

  MachineDetailsPage(this.machineData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Machine Data",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Model:",
                    style: TextStyle(fontSize: 28.0),
                  ),
                  Text(machineData.model, style: TextStyle(fontSize: 24.0)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Brand:",
                    style: TextStyle(fontSize: 28.0),
                  ),
                  Text(
                    machineData.brand,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Equipment Type:",
                    style: TextStyle(fontSize: 28.0),
                  ),
                  Text(
                    machineData.eqtype,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Serial No:",
                    style: TextStyle(fontSize: 28.0),
                  ),
                  Text(
                    machineData.sno,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Date of Installation:",
                    style: TextStyle(fontSize: 28.0),
                  ),
                  Text(
                    machineData.doi,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        child: FloatingActionButton(
          child: Text("Go back"),
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        width: 200,
        decoration: BoxDecoration(
            color: Color(0xFF00003f),
            borderRadius: BorderRadius.circular(50.0),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 10.0),
                  color: Colors.grey,
                  blurRadius: 25.0)
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
