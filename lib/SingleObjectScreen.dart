import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:stuffinfrontofme/Database.dart';
import "ResultsScreen.dart";
import "package:stuffinfrontofme/MapObject.dart";
import "package:stuffinfrontofme/ObjectsService.dart";
class SingleObjectScreen extends StatefulWidget{
  final Function() returnFunction;
  SingleObjectScreen({this.returnFunction}):super();
  @override
  _SingleObjectScreen createState() => _SingleObjectScreen();
  MapObjectVisualRepresentation mapObjectRepr = MapObjectVisualRepresentation(StaticDataHolder.currentObject);
  bool favorites = false;
}
class _SingleObjectScreen extends State<SingleObjectScreen> {

  @override
  Widget build(BuildContext context) {
    //powiększa się i zmniejsza po kliknięci
    return
      WillPopScope(
        onWillPop: this.widget.returnFunction,
        child:
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),child:
          Card(  elevation: 3,child:
          Column(children:<Widget>[
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width:240, child:CardTitle(Icons.place, this.widget.mapObjectRepr.title, this.widget.mapObjectRepr.subtitle)),IconButton(
              icon: Icon(Icons.favorite),
              color:
              !this.widget.favorites ? Colors.lightBlue : Colors.red,
              onPressed: !this.widget.favorites
                  ? () {
                insertObject(this.widget.mapObjectRepr.mapObject);
              }
                  : () {
                deleteOne(this.widget.mapObjectRepr.mapObject['id']);
                setState(() {

                });
              },
            ) ]),



       Container(height:250, child:FlutterMap(
      options: new MapOptions(
        center: StaticDataHolder.center,
        zoom: 18,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiYW1pZ29kdXBhbmV6IiwiYSI6ImNrN3RjZWNoZTB2MzkzbXBsdTc2aGhwd3oifQ.HU7qa-I8OIoXCLe8kLFpCw',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: StaticDataHolder.center,
              builder: (ctx) =>
              new Container(
                child: Icon(Icons.place, color:Colors.redAccent, size: 35,),
              ),
            ),
    new Marker(
    width: 80.0,
    height: 80.0,
    point: StaticDataHolder.myPosition,
    builder: (ctx) =>
    new Container(
    child: Icon(Icons.place, color:Colors.blueAccent, size: 35,),
    )),
          ],
        ),
      ],
    )),
          Container(height:20),
          Container(padding:EdgeInsets.fromLTRB(10, 0, 10, 0),child:this.widget.mapObjectRepr.description)
          ]))));
  }
}