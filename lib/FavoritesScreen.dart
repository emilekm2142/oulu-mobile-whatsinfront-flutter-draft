import 'package:flutter/material.dart';
import 'package:stuffinfrontofme/Database.dart';
import "ResultsScreen.dart";
import "package:stuffinfrontofme/MapObject.dart";
import "package:stuffinfrontofme/ObjectsService.dart";
class FavoritesScreen extends StatefulWidget{

 FavoritesScreen({this.returnFunction, this.singleViewFunction}):super();
 final Function() returnFunction;
 final Function(MapObject) singleViewFunction;

  @override
  _FavoritesScreen createState() => _FavoritesScreen();


}
class _FavoritesScreen extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    //powiększa się i zmniejsza po kliknięciu
    return  WillPopScope(
        onWillPop: this.widget.returnFunction,child: FutureBuilder(
        future: getFavorites(),
        builder: (BuildContext context, AsyncSnapshot<List<MapObject>> s) {
          if (!s.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
              children: s.data
                  .map((e) => PlaceCard(MapObjectVisualRepresentation(MapObject(e.data)), singleViewFunction: (mapObject){this.widget.singleViewFunction(mapObject);}, favorites:true, onDelete: ()=>setState((){}),))
                  .toList());
        }));
  }
}