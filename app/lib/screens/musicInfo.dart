import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../musicFunctions.dart';

class MusicInformation extends StatefulWidget {
  MusicInformation({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MusicInformation createState() => _MusicInformation();
}

class _MusicInformation extends State<MusicInformation> {
  String _currentSong = "";
  String _currentArtist = "";
  String _imageUrl = "";
  int _songProgress = 0;
  int _songDuration = 0;
  String _songAlbum = "";

  void getSongData() async {
    const url = 'http://localhost:5000/musicinfo';
    var response = await http.get(url, headers: {'Content-Type': 'application/json'});
    setState(() {
      _currentSong = jsonDecode(response.body)['info']['title'].toString();
      _currentArtist = jsonDecode(response.body)['info']['artist'].toString();
      _imageUrl = jsonDecode(response.body)['info']['images'][0]['url'].toString();
      _songProgress = int.parse(jsonDecode(response.body)['info']['progress'].toString());
      _songDuration = int.parse(jsonDecode(response.body)['info']['current_song_duration'].toString());
      _songAlbum = jsonDecode(response.body)['info']['album'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 20.0),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 60.0),
              child: Image.network(_imageUrl, width: 400.0, height: 400.0),
            ),
          ],
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: SizedBox(
                    width: 400.0,
                    child: Center(
                        child: Text('$_currentSong',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)))),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: SizedBox(
                    width: 375.0,
                    child: Center(
                        child: Text('$_currentArtist',
                            style: TextStyle(fontSize: 30)))),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: SizedBox(
                    width: 375.0,
                    child: Center(
                        child: Text('Album: $_songAlbum',
                            style: TextStyle(fontSize: 25)))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 40.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0),
                          height: 60.0,
                          width: 60.0,
                          child: FloatingActionButton(
                              onPressed: previousSong,
                              tooltip: 'Previous song',
                              child: Icon(Icons.skip_previous))),
                      Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0),
                          height: 60.0,
                          width: 60.0,
                          child: FloatingActionButton(
                              onPressed: playSong,
                              tooltip: 'Play Song',
                              child: Icon(Icons.play_arrow))),
                      Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0),
                          height: 60.0,
                          width: 60.0,
                          child: FloatingActionButton(
                              onPressed: nextSong,
                              tooltip: 'Next Song',
                              child: Icon(Icons.skip_next))),
                    ]),
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          height: 60.0,
                          width: 60.0,
                          child: FloatingActionButton(
                              onPressed: getSongData,
                              tooltip: 'Get Song Data',
                              child: Icon(Icons.refresh))),
                    ]),
              )
            ],
          ),
        )
      ]),
    ));
  }
}
