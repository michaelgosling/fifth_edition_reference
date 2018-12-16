import 'package:flutter/material.dart';
import 'Entry.dart';
import 'Category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EntryDialog extends StatefulWidget {
  final String url;

  EntryDialog({this.url});

  @override
  EntryDialogState createState() => new EntryDialogState();
}

class EntryDialogState extends State<EntryDialog> {

  Future<Entry> fetchEntryByURL(String url) async{
    final response = await http.get(url);
    if (response.statusCode == 200)
      return Entry.fromJson(json.decode(response.body));
    else
      throw Exception('failed to load entry');
  }

  List<Widget> getDialog(AsyncSnapshot snapshot){
    Entry entry = snapshot.data;
    switch (entry.category){
      case Category.Spell:
        return <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(entry.name, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
          ),
          new Divider(height: 2.0),
          new Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: new Text("Description: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left),
          ),
          new Text(entry.desc, textAlign: TextAlign.justify,),
          ];
      default:
        return <Widget>[];
    }
    
  }


  @override
  Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        body: Center(
          child: FutureBuilder<Entry>(
            future: fetchEntryByURL(widget.url),
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: getDialog(snapshot),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                    )),
                    margin: EdgeInsets.fromLTRB(20, 70, 20, 20),
                  );
              }
            }
          ),
        ),
      );      
    }
}