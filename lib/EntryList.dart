import 'package:http/http.dart' as http;
import 'Entry.dart';
import 'EntryDialog.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class EntryList extends StatefulWidget {
  EntryList({this.entries});
  final Future<Entries> entries;

  @override
  _EntryListState createState() => _EntryListState();
}

class _EntryListState extends State<EntryList> {


  Future<Entry> fetchEntry(String type, int index) async {
    final response = await http.get('http://dnd5eapi.co/api/' + type + '/' + index.toString() + '/');
    if (response.statusCode == 200)
      return Entry.fromJson(json.decode(response.body));
    else
      throw Exception('failed to load entry');
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
            onTap: () { _openEntryDialog(entries.results.elementAt(index)['url']);},
          ),
          new Divider(height: 2.0)
        ],);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<Entries>(
          future: widget.entries,
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
      ),
    );
  }
}
