import 'package:compasstools/compasstools.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart";
import 'package:geodesy/geodesy.dart';
import "dart:convert";
import "dart:math";
import "package:stuffinfrontofme/Database.dart";
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stuffinfrontofme/MapObject.dart';

class HttpService {
  static String getTrashObjectsFilter(String category) {
    if (!MapObject.trashObjects.containsKey(category)) return "";
    var list =
        MapObject.trashObjects[category].map((e) => """["$category"!="$e"]""");
    var d = list.join("");
    debugPrint(d);
    return d;
  }

  static String createOverpassRequestBody(
      double corner1, double corner2, double corner3, double corner4) {
    var g = MapObject.tags.map((e) {
      var filters = getTrashObjectsFilter(e);
      return "node($corner1,$corner2,$corner3,$corner4)[\"$e\"]$filters;";
    }).join("\n");

    var f = """[out:json];
  (
   $g
   <;
);
out meta;""";
    debugPrint(f);
    return f;
  }

  static Future<List<double>> getCorners(double latitude, double longitude,
      {double length = 450}) async {
    var geodesy = Geodesy();
    var azymunnthL = await FlutterCompass.events.take(1).toList();
    var azymunnth = azymunnthL[0];
    debugPrint(azymunnth.toString());
    LatLng userPosition = LatLng(latitude, longitude);
    LatLng LeftStartCorner = geodesy.destinationPointByDistanceAndBearing(
        userPosition, 5, azymunnth - 90);
    LatLng RightStartCorner = geodesy.destinationPointByDistanceAndBearing(
        userPosition, 5, azymunnth + 90);
    LatLng RightEndCorner = geodesy.destinationPointByDistanceAndBearing(
        RightStartCorner, length, azymunnth);
    LatLng LeftEndCorner = geodesy.destinationPointByDistanceAndBearing(
        LeftStartCorner, length, azymunnth);

    return [
      min(LeftStartCorner.latitude, RightEndCorner.latitude),
      min(LeftStartCorner.longitude,RightEndCorner.longitude),
      max(LeftStartCorner.latitude, RightEndCorner.latitude),
      max(LeftStartCorner.longitude,RightEndCorner.longitude),
    ];
  }

  static Future<Map<String, dynamic>> getPosts() async {
    final String postsURL = "https://lz4.overpass-api.de/api/interpreter";
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var corners = await getCorners(position.latitude, position.longitude);
    Response res = await post(postsURL,
        body: createOverpassRequestBody(
            corners[0], corners[1], corners[2], corners[3]));

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      return body;
    }
    throw Exception();
  }
  static Future<List<MapObject>> getSortedMapObjects() async{
    debugPrint("here!");
    var pureObjects = await getPosts();
    debugPrint("downlaoded!");
    debugPrint(pureObjects.toString());
    var mapObjects = (pureObjects["elements"] as List<dynamic>).map((v) => MapObject(v)).toList();
    debugPrint(mapObjects.toString());
    //
    debugPrint(mapObjects.toString());
    return mapObjects;
  }
  static Future<String> getWikipediaIntroduction() async{

  }
  static Future<String> searchOnWikipedia() async{

  }
}
