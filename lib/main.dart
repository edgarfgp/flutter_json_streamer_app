import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Photo Stramer",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ), //ThemeData
      home: new PhotoList(),
    );
  }

}

class PhotoList extends StatefulWidget {
  @override
  PhotoListState createState() => PhotoListState();
}

class PhotoListState extends State<PhotoList> {
  StreamController<Photo> streamController;
  List<Photo> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Json Stramer"),
        ),
        body: Center(
          child: ListView.builder(
            //scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) =>
                _makeElement(index),
          ), //ListView Builder
        ) //Center,
    );
  }

  Widget _makeElement(int index) {
    if (index >= list.length) {
      return null;
    }

    return Container(
        padding: EdgeInsets.all(5.0),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Column(
            children: <Widget>[
              Image.network(list[index].url, scale: 0.8,),
              Text(list[index].title, textScaleFactor: 2.0,),
            ],
          ),
        ));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamController = StreamController.broadcast();

    streamController.stream.listen((p) =>
        setState(() => list.add(p)
        ));

    load(streamController);
  }


  void load(StreamController<Photo> streamController) async {
    String uri = "https://jsonplaceholder.typicode.com/photos";
    var client = http.Client();
    var req = new http.Request('get', Uri.parse(uri));

    var streamedResponse = await client.send(req);
    streamedResponse.stream
        .transform(UTF8.decoder)
        .transform(json.decoder)
        .expand((e) => e)
        .map((map) => Photo.fromJsonMap(map))

        .pipe(streamController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamController?.close();
  }

}

class Photo {
  final String title;
  final String url;

  Photo.fromJsonMap(Map map)
      :title= map['title'],
        url = map['url'];
}


