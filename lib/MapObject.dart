import "dart:convert";
import 'package:geodesy/geodesy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
class StaticDataHolder{
  static LatLng center;
  static LatLng myPosition;
  static MapObject currentObject;
  static bool lastScreenFavorites;
}


class MapObject {
  dynamic operator [](String key){
    return this.data[key];
  }
  static var tags = ["amenity","building","craft","historic","leisure","man_made","military","place","public_transport","shop","tourism", "office"];
  static Map<String, List<String>> trashObjects = {"amenity":["waste_basket", "waste_disposal", "waste_transfer_station", "watering_place", "recycling", "bench"], "man_made":["tar_kiln"]};
  int id;
  double lat;
  double lon;
  final Map<String, dynamic> data;
  MapObject(this.data){
    this.lat = this.data["lat"];
    this.lon = this.data["lon"];
    this.id = this.data["id"];
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'lon': lon,
      'data': jsonEncode(data),
    };
  }
}

class MapObjectVisualRepresentation{
  final MapObject mapObject;
  String title;
  String subtitle;
  IconData icon;

  Widget description;

  String _capitalize(String str) {
    if (str.length==0) return str;
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  String _normalizeTagValue(String name) {
    return _capitalize(name.replaceAll("_", " "));
  }
  String _normalizeTagName(String name) {
    return _capitalize(name.replaceAll("_", " ").replaceAll(":", " "));
  }
  Widget _generateDescription() {
    var negative = ["paid", "no"];
    var slightlyNegative= ["limited"];
    var positive = ["free", "yes"];
    var customDisplayTags = MapObject.tags+["website", "addr:city", "addr:street", "addr:housenumber", "addr:city", "addr:postcode", "description", "opening_hours"];

    var tags = this.mapObject["tags"] as Map<String, dynamic>;
    List<Widget> list = [];

    if (tags.containsKey("website")){
      list.add(Row(children: <Widget>[Icon(Icons.web),Container(width:10),InkWell(child:Text(tags["website"]), onTap: ()=>launch(tags["website"]),)]));
    }
    if (tags.containsKey("addr:city")){
      String addr = tags["addr:street"]+" "+ tags["addr:housenumber"]+"\n" + tags["addr:city"]+" " + tags["addr:postcode"];
      list.add(Row(children: <Widget>[Icon(Icons.place),Container(width:10),Flexible(child:Text(addr))]));
    }
    if (tags.containsKey("description")){
      list.add(Text(tags["description"]));
    }
    tags.forEach((key, value) {
      bool add =false;
      if (negative.contains(value) ){
        list.add(Row(children: <Widget>[Icon(Icons.close, color: Colors.red), Flexible(child:Text(_capitalize(key)))],));
        add=true;
      }
      if (slightlyNegative.contains(value) ){
        list.add(Row(children: <Widget>[Icon(Icons.close, color: Colors.yellow), Flexible(child:Text(_capitalize(key)))],));
        add=true;
      }
      if (positive.contains(value) ){
        list.add(Row(children: <Widget>[Icon(Icons.check, color: Colors.green), Flexible(child:Text(_capitalize(key)))],));
        add=true;
      }
      if (add){
        customDisplayTags.add(key);
      }
    });
    if (tags.containsKey("opening_hours")){
      list.add(Row(children: <Widget>[Icon(Icons.people_outline),Container(width:10),Flexible(child:Text(tags["opening_hours"]))]));
    }
    return Column(children: list+getGenericDescriptionFromNonCustomTags(customDisplayTags),);
  }
  List<Widget> getGenericDescriptionFromNonCustomTags(List<String> customTags){
    List<Widget> l =[];
    var tags = this.mapObject["tags"] as Map<String, dynamic>;
    tags.forEach((key, value) { 
      if (!customTags.contains(key)){
        String normalizedTagName = _capitalize(_normalizeTagName(key));
        String normalizedTagValue = _normalizeTagValue(value);
        l.add(Row(children:[Text("$normalizedTagName: $normalizedTagValue",)]));
      }
    });
    return l;
  }
  MapObjectVisualRepresentation(this.mapObject){
    String titleSourceType;
    String titleSource;
    List<String> nameOrdering = ["name"] + MapObject.tags;
    var tags = (this.mapObject["tags"] as Map<String, dynamic>);

    if (!tags.containsKey("name")){
      var tagsCopy = jsonDecode(jsonEncode(tags));
      tagsCopy.forEach((key, value) {
        if (key.startsWith("name:")){
          tags["name"] = value;
        }
      });
    }

    for (var element in nameOrdering) {
      if ((this.mapObject["tags"] as Map<String, dynamic>).containsKey(element)) {
        this.title = _capitalize(this.mapObject["tags"][element]);
        titleSourceType="primaryKey";
        titleSource = element;
        break;
      }
    }

    if ((this.mapObject["tags"] as Map<String, dynamic>).containsKey("information"))
      this.subtitle=this.mapObject["tags"]["information"];
    else
      this.subtitle="";


    if (titleSource=="name"){
      this.subtitle=this.mapObject["tags"][MapObject.tags.firstWhere((e) => (this.mapObject["tags"] as Map<String, dynamic>).containsKey(e))];
    }
    if (tags.containsKey("board_type")) this.subtitle=tags['board_type'];
    this.description = _generateDescription();

    this.title = _normalizeTagValue(this.title);
    this.subtitle = _normalizeTagValue(this.subtitle);
  }



}