import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dioexp/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Dio demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: MyHomePage(title: 'NASA PICTURE OF THE DAY'),
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
  String _date;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  _formatDate(DateTime date) {
    _date = formatter.format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
        context: context,
        initialDate: _setMidweekDate(DateTime.now()),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        selectableDayPredicate: (DateTime val) {
          if (val.weekday == DateTime.saturday ||
              val.weekday == DateTime.sunday) {
            return false;
          }
          return true;
        }).then((value) {
      _formatDate(value);
      _getData();
    });
  }

  _getData() {
    dio
        .get<Map<String, dynamic>>(
            "https://api.nasa.gov/planetary/apod?api_key=w42dJezDhZsu7eEBdueADBUSPZqH7fetdplKfGcy&date=$_date")
        //"https://api.nasa.gov/planetary/apod?api_key=w42dJezDhZsu7eEBdueADBUSPZqH7fetdplKfGcy")
        .then(
      (response) {
        setState(
          () {
            _title = response.data["title"];
            _copyright = response.data["copyright"];
            _explanation = response.data["explanation"];
            _url = response.data["url"];
          },
        );
      },
    ).catchError(print);
  }

  @override
  void initState() {
    super.initState();
    _formatDate(_setMidweekDate(DateTime.now()));
  }

  DateTime _setMidweekDate(DateTime date){
    DateTime d = date.subtract(
      Duration(days: _checkWhetherSaturdaySundayOrWeekday(date)));
    return d;
  }

  int _checkWhetherSaturdaySundayOrWeekday(DateTime data){
    if (data.weekday == DateTime.saturday){
      return 1;
    }
    if (data.weekday == DateTime.sunday){
      return 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text('Selecionar a data'),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Text(_title ?? 'Título: $_title'),
                  Container(
                    child: _url != "" ? Image.network(_url) : null,
                  ),
                  Text(_copyright ?? 'Autor: $_copyright'),
                  Text(_explanation ?? 'Informação: $_explanation'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
