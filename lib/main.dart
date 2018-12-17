import 'package:flutter/material.dart';
import 'EntryList.dart';
import 'Entry.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(FifthEditionReference());

class FifthEditionReference extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifth Edition Reference',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Fifth Edition Reference'),
    );
  }
}

class Home extends StatefulWidget {

  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  EntryList _spellsWidget, _equipmentWidget, _featuresWidget;
  int _currentIndex = 0;
  final List<Widget> _children = [];
  Future<Entries> _spells, _equipment, _features;

  @override
  void initState(){
    super.initState();
    _spells = fetchEntryList('spells');
    _equipment = fetchEntryList('equipment');
    _features = fetchEntryList('features');
    _spellsWidget = new EntryList(entries: _spells);
    _equipmentWidget = new EntryList(entries: _equipment);
    _featuresWidget = new EntryList(entries: _features);
    _children.add(_spellsWidget);
    _children.add(_equipmentWidget);
    _children.add(_featuresWidget);
  }



  Future<Entries> fetchEntryList(String type) async {
    final response = await http.get('http://dnd5eapi.co/api/' + type);
    if (response.statusCode == 200)
      return Entries.fromJson(json.decode(response.body));
    else
      throw Exception('failed to load entries');
  }

  void onTabTapped(int index){
    setState(() {
          _currentIndex = index;
        });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.bubble_chart),
            title: new Text("Spells"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.colorize),
            title: new Text("Equipment"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.description),
            title: new Text("Features"),
          )
        ],
      ), 
      );
    }
}
