import 'package:flutter/material.dart';

import '../http.dart';

class RequestRoute extends StatefulWidget {
  @override
  _RequestRouteState createState() => _RequestRouteState();
}

class _RequestRouteState extends State<RequestRoute> {
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('New page')),
        body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                RaisedButton(child: Text("Request"), 
                onPressed: () {
                  dio.get<String>("http://httpbin.org/get")
                    .then((response) {
                      setState(() {
                        _text = response.data;
                      });
                    });
                },),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(_text),
                  ),
                )
              ],
            )));
  }
}
