import 'Category.dart';

class Entries {
  final int count;
  final List<dynamic> results;

  Entries({this.count, this.results});

  factory Entries.fromJson(Map<String, dynamic> json){
    return Entries(
      count: json['count'],
      results: json['results']
    );
  }

}

class Entry {
  final String id;
  final int index;
  final String name;
  final String desc;
  final Category category;

  Entry({this.id, this.index, this.name, this.desc, this.category});

  factory Entry.fromJson(Map<String, dynamic> json){
    String url = json['url'].toString();
    Category cat;
    if (url.contains('spells'))
      cat = Category.Spell;
    else if (url.contains('classes'))
      cat = Category.Class;
    else if (url.contains('equipment'))
      cat = Category.Equipment;
    else if (url.contains('features'))
      cat = Category.Feat;
    else if (url.contains('monsters'))
      cat = Category.Monster;
    else if (url.contains('subclasses'))
      cat = Category.Subclass;
    else if (url.contains('races'))
      cat = Category.Race;
    else if (url.contains('subraces'))
      cat = Category.Subrace;
    else if (url.contains('languages'))
      cat = Category.Language;
    else if (url.contains('proficiencies'))
      cat = Category.Proficiency;
    else if (url.contains('ability-scores'))
      cat = Category.AbilityScore;
    else
      cat = Category.Other;

    return Entry(id: json['_id'], index: json['index'], name: json['name'], desc: json['desc'][0], category: cat);
  }
}
