import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:stuffinfrontofme/Database.dart';
import "package:stuffinfrontofme/ObjectsService.dart";
import "package:stuffinfrontofme/MapObject.dart";
import 'package:url_launcher/url_launcher.dart';

class ResultsScreen extends StatelessWidget {
  final Function() returnFunction;
  final Function(MapObject) singleViewFunction;
  ResultsScreen({this.returnFunction, this.singleViewFunction}):super();
  @override
  Widget build(BuildContext context) {
    //powiększa się i zmniejsza po kliknięciu
    return WillPopScope(
      onWillPop: returnFunction,
        child:FutureBuilder(
        future: HttpService.getSortedMapObjects(),
        builder: (BuildContext context, AsyncSnapshot<List<MapObject>> s) {
          if (!s.hasData) return Center(child: CircularProgressIndicator());
          if (s.data.length>0)
          return ListView(
              children: s.data
                  .map((e) =>
                      PlaceCard(MapObjectVisualRepresentation(e), singleViewFunction: (mapObject){singleViewFunction(mapObject);},))
                  .toList());
          else
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[Text("No results!"), FlatButton(textColor: Colors.blue,onPressed:(){},child:Text("Return"))]));
        }));
  }
}

class CardTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  CardTitle(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(this.icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final MapObjectVisualRepresentation object;
  final bool favorites;
  final Function() onDelete;
  final Function(MapObject) singleViewFunction;
  PlaceCard(this.object, {this.favorites = false, this.onDelete = null, this.singleViewFunction=null});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),

        width: double.maxFinite,
        child: Card(
            elevation: 3,
            child: InkWell(
                onTap: (){if (singleViewFunction!=null) singleViewFunction(object.mapObject);},
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 244,
                              child: CardTitle(
                                Icons.map,
                                this.object.title,
                                this.object.subtitle,
                              )),
                          IconButton(
                            icon: Icon(Icons.favorite),
                            color:
                                !this.favorites ? Colors.lightBlue : Colors.red,
                            onPressed: !this.favorites
                                ? () {
                                    insertObject(this.object.mapObject);
                                  }
                                : () {
                                    deleteOne(this.object.mapObject['id']);
                                    if (onDelete != null) onDelete();
                                  },
                          )
                        ],
                      ),
                      this.object.description
                    ],
                  ),
                ))));
  }
}
