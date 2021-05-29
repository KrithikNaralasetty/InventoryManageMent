import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_to_form/json_to_form.dart';
// ignore: unused_import
import 'models/template.dart';
import '../Caching.dart' as cache;
// ignore: unused_import
import 'package:giffy_dialog/giffy_dialog.dart';

// ignore: must_be_immutable
class JsonBuilder extends StatefulWidget {
  var form;
  String uid;
  bool isResponse;
  String uname;
  JsonBuilder(this.form,
      {this.isResponse = false, this.uid, this.uname});
  @override
  JsonBuilderState createState() => new JsonBuilderState(this.uid, this.uname);
}

class JsonBuilderState extends State<JsonBuilder> {
  dynamic response;
  DateTime day = DateTime.now();

  var _qrcode, _uid;
  JsonBuilderState(this._qrcode, this._uid);

  Widget giveButton() {
    if (widget.isResponse) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: new ElevatedButton(
            child: new Text(
              'Send',
              style: TextStyle(color: Color.fromARGB(250, 18, 70, 255)),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow)),
            onPressed: () async {
              var sendRecord = {
                "s_no": "",
                "dos": day.toString().substring(0, 10),
                "wid_s": this._uid,
                "doc": "",
                "wid_c": "",
                "record": jsonEncode(response),
                "status": "true",
                "uid": this._qrcode
              };
              print(widget.uid);
              cache.saveValue("recordData", json.encode(sendRecord).toString());
              var respons = await http.post(
                  "https://formfield.azurewebsites.net/putrecord",
                  body: json.encode(sendRecord),
                  headers: {"Content-Type": "application/json"});
              print(respons.body);
              Navigator.pop(context);
              print("1000000000000" + this.response);
//              print(json.encode());
            }),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: new ElevatedButton(
            child: new Text(
              'go back',
              style: TextStyle(color: Color.fromARGB(250, 18, 70, 255)),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow)),
            onPressed: () {
              Navigator.pop(context);
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromARGB(250, 18, 70, 255),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          child: new Column(children: <Widget>[
            new CoreForm(
              form: jsonEncode(widget.form),
              onChanged: (dynamic response) {
                this.response = response;
              },
            ),
            giveButton()
          ]),
        ),
      ),
    );
  }
}
