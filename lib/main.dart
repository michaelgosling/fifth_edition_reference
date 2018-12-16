import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Entry.dart';
import 'EntryDialog.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifth Edition Reference',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fifth Edition Reference'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Future<Entry> fetchEntry(String type, int index) async {
    final response = await http.get('http://dnd5eapi.co/api/' + type + '/' + index.toString() + '/');
    if (response.statusCode == 200)
      return Entry.fromJson(json.decode(response.body));
    else
      throw Exception('failed to load entry');
  }

  Future<Entries> fetchEntryList(String type) async {
    final response = await http.get('http://dnd5eapi.co/api/' + type);
    if (response.statusCode == 200)
      return Entries.fromJson(json.decode(response.body));
    else
      throw Exception('failed to load entries');
  }

  void _openEntryDialog(String url) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new EntryDialog(url: url);
      },
      fullscreenDialog: true
    ));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot){
    Entries entries = snapshot.data;
    return new ListView.builder(
      itemCount: entries.count,
      itemBuilder: (BuildContext context, int index){
        return new Column(children: <Widget>[
          new ListTile(
            title: new Text(entries.results.elementAt(index)['name']),
            //TODO: Open sheet with url values
            onTap: () { _openEntryDialog(entries.results.elementAt(index)['url']);},
          ),
          new Divider(height: 2.0)
        ],);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<Entries>(
          future: fetchEntryList('spells'),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return createListView(context, snapshot);
            }
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
