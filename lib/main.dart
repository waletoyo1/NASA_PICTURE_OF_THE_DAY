import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dioexp/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'routes/request.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void main() {
  dio.interceptors.add(LogInterceptor());
  dio.options.receiveTimeout = 1500;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MyHomePage(title: 'Dio demo home page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _copyright = "";
  String _explanation = "";
  String _title = "";
  String _url = "";
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              //selecionar a data primeiro
              RaisedButton(
                child: Text('Mostar imagem do dia'),
                onPressed: () {
                  dio
                      .get<Map<String, dynamic>>(
                          "https://api.nasa.gov/planetary/apod?api_key=w42dJezDhZsu7eEBdueADBUSPZqH7fetdplKfGcy&date=$_date")
                      //"https://api.nasa.gov/planetary/apod?api_key=w42dJezDhZsu7eEBdueADBUSPZqH7fetdplKfGcy")
                      .then(
                    (response) {
                      setState(
                        () {
                          print('data:');
                          print(response);
                          _title = response.data["title"];
                          _copyright = response.data["copyright"];
                          _explanation = response.data["explanation"];
                          _url = response.data["url"];
                        },
                      );
                    },
                  ).catchError(print);
                },
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    Text('Título: $_title'),
                    Image.network(_url),
                    Text('Autor: $_copyright'),
                    Text('Informação: $_explanation'),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
